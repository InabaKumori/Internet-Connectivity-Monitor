# Internet Connectivity Monitor

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This script is designed to monitor internet connectivity by periodically checking ping accessibility and DNS resolution. If the internet connection is down or DNS resolution fails, the script automatically restarts the v2raya and dnsmasq services to attempt to restore connectivity.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Logging](#logging)
- [Supported Operating Systems](#supported-operating-systems)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features

- Monitors internet connectivity by checking ping accessibility to multiple targets
- Monitors DNS resolution by checking the ability to resolve multiple domain names
- Automatically restarts v2raya and dnsmasq services if internet connectivity or DNS resolution fails
- Configurable ping and DNS failure thresholds
- Detailed logging of internet connectivity status and service restarts
- Supports multiple operating systems, including OpenWrt, Debian/Ubuntu, Red Hat/CentOS, and macOS

## Prerequisites

Before using this script, ensure that you have the following:

- Bash shell (version 4.0 or later)
- `ping` command
- `dig` command
- `timeout` command
- `v2raya` service (installed and configured)
- `dnsmasq` service (installed and configured)

## Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/inabakumori/internet-connectivity-monitor.git
   ```

2. Navigate to the cloned directory:

   ```bash
   cd internet-connectivity-monitor
   ```

3. Make the script executable:

   ```bash
   chmod +x internet_monitor.sh
   ```

## Usage

To start monitoring internet connectivity, simply run the script:

```bash
./internet_monitor.sh
```

The script will continuously monitor internet connectivity and DNS resolution. If any issues are detected, it will automatically attempt to restart the v2raya and dnsmasq services to restore connectivity.

To stop the script, press `Ctrl+C`.

## Configuration

The script provides several configurable options that you can modify according to your needs:

- `log_file`: The path to the log file where the script will write its output (default: `/var/log/internet_monitor.log`).
- `ping_targets`: An array of ping targets to check for internet connectivity (default: `("baidu.com" "8.8.8.8" "223.5.5.5" "120.53.53.84")`).
- `dns_targets`: An array of domain names to check for DNS resolution (default: `("google.com" "baidu.com" "bing.com")`).
- `ping_timeout`: The timeout value in seconds for each ping attempt (default: `1`).
- `dns_timeout`: The timeout value in seconds for each DNS resolution attempt (default: `1`).
- `required_ping_failures`: The number of consecutive ping failures required to consider the internet connection as down (default: `10`).
- `required_dns_failures`: The number of consecutive DNS resolution failures required to consider DNS resolution as failed (default: `5`).

You can modify these options directly in the script file (`internet_monitor.sh`) according to your requirements.

## Logging

The script logs its output to a file specified by the `log_file` variable (default: `/var/log/internet_monitor.log`). Each log entry includes a timestamp and a description of the event.

The log file will contain information about:

- Script startup
- Internet connectivity checks
- Ping and DNS failure status
- Internet connectivity status (up or down)
- DNS resolution status (success or failure)
- Service restarts (v2raya and dnsmasq)

You can monitor the log file to keep track of the script's activity and any issues that may occur.

## Supported Operating Systems

This script has been tested and confirmed to work on the following operating systems:

- OpenWrt
- Debian/Ubuntu
- Red Hat/CentOS
- macOS

If you are using a different operating system, the script may still work, but it has not been explicitly tested.

## Testing

To ensure that the script is functioning correctly, you can perform the following tests:

1. Disconnect from the internet and observe the script's behavior. It should detect the internet connectivity failure, wait for recovery, and restart the v2raya and dnsmasq services once the connection is restored.

2. Simulate a DNS resolution failure by temporarily disabling or misconfiguring your DNS server. The script should detect the DNS resolution failure and restart the v2raya and dnsmasq services.

3. Verify that the script continues to monitor internet connectivity and DNS resolution even after successful restarts of the services.

4. Check the log file to ensure that the script is logging events accurately and with the expected format.

If you encounter any issues during testing or have suggestions for improvement, please open an issue on the GitHub repository.

## Contributing

Contributions to this project are welcome! If you find any bugs, have feature requests, or want to contribute improvements, please follow these steps:

1. Fork the repository on GitHub.
2. Create a new branch with a descriptive name for your feature or bug fix.
3. Make your changes in the new branch.
4. Write tests to validate your changes, if applicable.
5. Commit your changes and push them to your forked repository.
6. Open a pull request on the original repository, describing your changes in detail.

Please ensure that your code follows the existing style and conventions used in the project. Also, make sure to update the documentation, including the README file, if necessary.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for more information.

```
Copyright (C) 2023 inabakumori

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

Please note that this script comes with no warranty, and the author and contributors are not liable for any damages or issues arising from its use. Use it at your own risk.

If you have any questions, suggestions, or feedback, please open an issue on the GitHub repository or contact the author directly.

Happy monitoring!
