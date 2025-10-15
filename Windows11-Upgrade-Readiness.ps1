# Prompt for remote computer name or IP
$remoteComputer = Read-Host "Enter the remote computer name or IP"

# Prompt for credentials
$cred = Get-Credential

try {
    # Get license key
    $licenseInfo = Get-WmiObject -ComputerName $remoteComputer -Query "select * from SoftwareLicensingService" -Credential $cred -ErrorAction Stop
    $licenseKey = $licenseInfo.OA3xOriginalProductKey

    # Get OS details
    $osInfo = Get-WmiObject -ComputerName $remoteComputer -Class Win32_OperatingSystem -Credential $cred -ErrorAction Stop

    # Get CPU info
    $cpuInfo = Get-WmiObject -ComputerName $remoteComputer -Class Win32_Processor -Credential $cred -ErrorAction Stop

    # Get RAM info (sum of all RAM sticks)
    $ramInfo = Get-WmiObject -ComputerName $remoteComputer -Class Win32_PhysicalMemory -Credential $cred -ErrorAction Stop
    $totalRamBytes = ($ramInfo | Measure-Object Capacity -Sum).Sum
    $totalRamGB = [math]::Round($totalRamBytes / 1GB, 2)

    # Get Disk free space on C:
    $diskInfo = Get-WmiObject -ComputerName $remoteComputer -Class Win32_LogicalDisk -Filter "DeviceID='C:'" -Credential $cred -ErrorAction Stop
    $freeDiskGB = [math]::Round($diskInfo.FreeSpace / 1GB, 2)

    # Get BIOS version
    $biosInfo = Get-WmiObject -ComputerName $remoteComputer -Class Win32_BIOS -Credential $cred -ErrorAction Stop

    # Get TPM status
    $tpmInfo = Get-WmiObject -Namespace "root\CIMV2\Security\MicrosoftTPM" -Class Win32_TPM -ComputerName $remoteComputer -Credential $cred -ErrorAction SilentlyContinue

    if ($tpmInfo) {
        $TPM_Enabled = ($tpmInfo.IsEnabled()).ReturnValue -eq 0
        $TPM_Activated = ($tpmInfo.IsActivated()).ReturnValue -eq 0
    }
    else {
        $TPM_Enabled = $false
        $TPM_Activated = $false
    }

    # Prepare output
    $output = [PSCustomObject]@{
        ComputerName       = $remoteComputer
        LicenseKey         = if ([string]::IsNullOrEmpty($licenseKey)) {"Not Found"} else {$licenseKey}
        OSName             = $osInfo.Caption
        OSVersion          = $osInfo.Version
        OSArchitecture     = $osInfo.OSArchitecture
        CPU                = $cpuInfo.Name
        CPU_Cores          = $cpuInfo.NumberOfCores
        TotalRAM_GB        = $totalRamGB
        FreeDiskSpace_GB   = $freeDiskGB
        BIOSVersion        = $biosInfo.SMBIOSBIOSVersion
        TPM_Enabled        = $TPM_Enabled
        TPM_Activated      = $TPM_Activated
    }

    # Display results
    $output | Format-List

    # Windows 11 minimum upgrade requirements checks
    $ramReq = 4
    $diskReq = 64
    $cpuCoresReq = 2
    $tpmReq = $TPM_Enabled -and $TPM_Activated
    $osArchReq = $osInfo.OSArchitecture -match "64"

    $compatible = $true
    $reasons = @()

    if (-not $tpmReq) {
        $compatible = $false
        $reasons += "TPM 2.0 not enabled/activated"
    }
    if (-not $osArchReq) {
        $compatible = $false
        $reasons += "OS is not 64-bit"
    }
    if ($totalRamGB -lt $ramReq) {
        $compatible = $false
        $reasons += "Insufficient RAM (< 4 GB)"
    }
    if ($freeDiskGB -lt $diskReq) {
        $compatible = $false
        $reasons += "Insufficient free disk space (< 64 GB)"
    }
    if ($cpuInfo.NumberOfCores -lt $cpuCoresReq) {
        $compatible = $false
        $reasons += "Insufficient CPU cores (< 2)"
    }
    # Additional checks like CPU model or Secure Boot could be added here

    if ($compatible) {
        Write-Output "`nComment: This computer is compatible for Windows 11 upgrade."
    }
    else {
        Write-Output "`nComment: This computer is NOT compatible for Windows 11 upgrade because:"
        foreach ($reason in $reasons) {
            Write-Output " - $reason"
        }
    }
}
catch {
    Write-Error "Failed to retrieve information from $remoteComputer. Error: $_"
}
