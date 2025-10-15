# Windows 10 to Windows 11 Upgrade Readiness Script

This PowerShell script remotely collects key system information from Windows 10 computers to assess their compatibility for upgrading to Windows 11. It retrieves Windows license key, OS details, hardware specs (CPU, RAM, Disk, BIOS), TPM status, and handles backup license keys stored in the registry.

## Features

- Collects Windows product key from remote machines (WMI and registry backup)
- Retrieves OS name, version, and architecture
- Gathers CPU name and core count
- Calculates total installed RAM and free disk space on system drive
- Retrieves BIOS version
- Checks TPM 2.0 enabled and activated status
- Provides a compatibility comment based on Windows 11 minimum upgrade requirements

## Requirements

- PowerShell with administrative privileges to run the script
- Remote computers must be accessible on the network
- Admin credentials on target machines (local admin for workgroup computers)
- Remote WMI and firewall ports open between systems

## License Key Details

The script retrieves two license keys:

- **LicenseKey_WMI (`OA3xOriginalProductKey`)**: 
  - Usually the original OEM or embedded key from system firmware or Windows setup.
- **LicenseKey_Registry (`BackupProductKeyDefault`)**: 
  - A backup copy of the Windows product key stored in the registry for recovery or installation purposes.
  - May differ from the OEM embedded key, reflecting a migrated, retail, or recently applied license.

**Which to use?**  
Use **LicenseKey_WMI** for the original license information when available. Use **LicenseKey_Registry** as a fallback or if the system was reactivated or upgraded.

## Usage

1. Clone or download this repository.
2. Run the script in PowerShell from a jumpbox or admin workstation:
    ```
    .\Check-Win11Readiness.ps1
    ```
3. Enter the remote computer name or IP address when prompted.
4. Enter credentials with admin access on the remote machine.
5. Review the collected results and upgrade compatibility assessment.

## Upgrade Compatibility Criteria Checked

- TPM 2.0 enabled and activated status
- 64-bit OS architecture
- Minimum 4 GB system RAM
- Minimum 64 GB free disk space on system drive
- Minimum 2 CPU cores

## Example Output

```text
ComputerName : IT-TESTING
LicenseKey_WMI : ****-****-****-****-****
LicenseKey_Registry : ****-****-****-****-****
OSName : Microsoft Windows 10 Enterprise LTSC Evaluation
OSVersion : 10.0.19044
OSArchitecture : 64-bit
CPU : 12th Gen Intel(R) Core(TM) i7-1270P
CPU_Cores : 12
TotalRAM_GB : 32
FreeDiskSpace_GB : 359.71
BIOSVersion : N3MET17W (1.16 )
TPM_Enabled : True
TPM_Activated : True
```

Comment: This computer is compatible for Windows 11 upgrade.


## License

This script is provided as-is under the [MIT License](LICENSE).

---

For detailed usage and troubleshooting, refer to the script comments.

