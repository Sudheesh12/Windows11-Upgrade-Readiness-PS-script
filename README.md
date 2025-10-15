# Windows11-Upgrade-Readiness-PS-script# Windows 10 to Windows 11 Upgrade Readiness Script

This PowerShell script remotely collects key system information from Windows 10 computers to assess their compatibility for upgrading to Windows 11. It retrieves Windows license key, OS details, hardware specs (CPU, RAM, Disk, BIOS), and TPM status.

## Features

- Collects Windows product key from remote machines
- Retrieves OS name, version, and architecture
- Gathers CPU name and core count
- Calculates total installed RAM and free disk space on system drive
- Retrieves BIOS version
- Checks TPM 2.0 enabled and activated status
- Provides a compatibility comment based on Windows 11 upgrade requirements

## Requirements

- PowerShell with administrative privileges to run the script
- Remote computers must be accessible on the network
- Admin credentials on target machines (local admin for workgroup computers)
- Remote WMI and/or WinRM enabled and firewall ports open between systems

## Usage

1. Clone or download this repository.
2. Run the script from a jumpbox or admin workstation:
    ```
    .\Check-Win11Readiness.ps1
    ```
3. Enter the remote computer name or IP address when prompted.
4. Enter the credentials with admin access on the remote machine.
5. View the collected results and compatibility comment.

## Compatibility Criteria Checked

- TPM 2.0 enabled and activated
- 64-bit operating system architecture
- Minimum 4 GB RAM
- Minimum 64 GB free disk space on system drive
- Minimum 2 CPU cores

## Example Output

ComputerName : EXAMPLE-PC
LicenseKey : ****-****-****-****
OSName : Microsoft Windows 10 Pro
OSVersion : 10.0.19044
OSArchitecture : 64-bit
CPU : Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
CPU_Cores : 4
TotalRAM_GB : 8
FreeDiskSpace_GB : 120
BIOSVersion : 1.0.0
TPM_Enabled : True
TPM_Activated : True

Comment: This computer is compatible for Windows 11 upgrade.

text

## License

This script is provided as-is under the [MIT License](LICENSE).

---

For detailed usage and troubleshooting, refer to the script comments.

