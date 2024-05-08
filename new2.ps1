# Define directory path, drive letter, and target path
$directoryPath = "C:\SharedFiles4"
$driveLetter = "C:\Program Files\Common Files"
$targetPath = "C:\Users\Public"

# Generate a timestamp for file uniqueness
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Define the full path for the output file
$testFilePath = "$directoryPath\TestFile_$timestamp.txt"

# Test content
$content = "Test file created on $timestamp"

# Write content to file
try {
    $content | Out-File -FilePath $testFilePath -Force -ErrorAction Stop
    Write-Host "File created successfully: $testFilePath"
} catch {
    Write-Host "Error creating file: $_"
    exit
}

# Define the script URI for the custom script extension
$scriptUri = "https://cretest.blob.core.windows.net/vmtest/new2.ps1"

# Configure custom script extension
Set-AzVmssExtension -ResourceGroupName "vm_group" -VirtualMachineScaleSet "vm" `
    -Name "CustomScriptExtension" -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" `
    -TypeHandlerVersion "1.10" -SettingString '{"fileUris":["' + $scriptUri + '"]}' `
    -ProtectedSettings '{"commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File script.ps1"}'
