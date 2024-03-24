#!/bin/bash

# Logging setup
log_file="/var/log/internet_monitor.log"

# Function to log messages with timestamps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $log_file
}

# Function to determine the operating system
determine_os() {
    if [ -f /etc/openwrt_release ]; then
        echo "openwrt"
    elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    elif [ "$(uname)" == "Darwin" ]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to restart the v2raya and dnsmasq services based on the operating system
restart_services() {
    os=$(determine_os)
    case $os in
        "openwrt")
            log "Restarting v2raya service on OpenWrt..."
            /etc/init.d/v2raya restart
            sleep 2
            log "Restarting dnsmasq service on OpenWrt..."
            /etc/init.d/dnsmasq restart
            ;;
        "debian")
            log "Restarting v2raya service on Debian/Ubuntu..."
            systemctl restart v2raya
            sleep 2
            log "Restarting dnsmasq service on Debian/Ubuntu..."
            systemctl restart dnsmasq
            ;;
        "redhat")
            log "Restarting v2raya service on Red Hat/CentOS..."
            systemctl restart v2raya
            sleep 2
            log "Restarting dnsmasq service on Red Hat/CentOS..."
            systemctl restart dnsmasq
            ;;
        "macos")
            log "Restarting v2raya service on macOS..."
            brew services restart v2raya
            sleep 2
            log "Restarting dnsmasq service on macOS (if installed)..."
            brew services restart dnsmasq || true
            ;;
        *)
            log "Unsupported operating system. Unable to restart v2raya and dnsmasq."
            ;;
    esac
}

# Function to check internet connectivity
check_internet() {
    local ping_targets=("baidu.com" "8.8.8.8" "223.5.5.5" "120.53.53.84")
    local dns_targets=("google.com" "baidu.com" "bing.com")
    local ping_timeout=1
    local dns_timeout=1
    local failed_ping_count=0
    local failed_dns_count=0
    local consecutive_ping_failures=0
    local consecutive_dns_failures=0
    local required_ping_failures=10
    local required_dns_failures=5

    for (( i=0; i<required_ping_failures || i<required_dns_failures; i++ )); do
        # Check ping connectivity
        for target in "${ping_targets[@]}"; do
            if ! ping -c 1 -W $ping_timeout $target >/dev/null 2>&1; then
                ((failed_ping_count++))
            fi
        done

        # Check DNS resolution
        for target in "${dns_targets[@]}"; do
            if ! timeout $dns_timeout dig $target >/dev/null 2>&1; then
                ((failed_dns_count++))
            fi
        done

        if [ $failed_ping_count -eq ${#ping_targets[@]} ]; then
            ((consecutive_ping_failures++))
            failed_ping_count=0
        else
            consecutive_ping_failures=0
        fi

        if [ $failed_dns_count -eq ${#dns_targets[@]} ]; then
            ((consecutive_dns_failures++))
            failed_dns_count=0
        else
            consecutive_dns_failures=0
        fi

        log "Ping status: $consecutive_ping_failures consecutive failures"
        log "DNS status: $consecutive_dns_failures consecutive failures"

        if [ $consecutive_ping_failures -ge $required_ping_failures ]; then
            return 1
        fi

        if [ $consecutive_dns_failures -ge $required_dns_failures ]; then
            return 2
        fi

        sleep 1
    done

    return 0
}

# Main script
log "Starting internet connectivity monitor..."

while true; do
    log "Checking internet connectivity..."

    check_internet
    result=$?

    if [ $result -eq 1 ]; then
        log "Internet is down. Waiting for recovery..."
        while ! check_internet; do
            sleep 1
        done
        log "Internet has recovered. Restarting v2raya and dnsmasq services..."
        restart_services
    elif [ $result -eq 2 ]; then
        log "DNS resolution failed. Restarting v2raya and dnsmasq services..."
        restart_services
    else
        log "Internet is up. Continuing to monitor..."
    fi

    sleep 1
done
