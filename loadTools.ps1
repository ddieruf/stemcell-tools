$ErrorActionPreference = "Stop"

$tmpFolder = "tmp"
$tmpPath = "c:\"+$tmpFolder
$psModulesFile = "PSWindowsUpdate.zip"
$vmwFile = "vmware-tools.exe"
$reboot = $FALSE

New-Item -Path "C:\" -Name "tmp" -ItemType "directory" | Set-Location

Invoke-WebRequest -Uri "http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/25/PSWindowsUpdate.zip" -OutFile $psModulesFile

Invoke-WebRequest -Uri "https://packages.vmware.com/tools/releases/10.3.10/windows/x64/VMware-tools-10.3.10-12406962-x86_64.exe" -OutFile $vmwFile

Expand-Archive -Path $psModulesFile -DestinationPath "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"

#INSTALL VMWARE TOOLS
$arguments = "/S /v ""/qn REBOOT=R ADDLOCAL=ALL REMOVE=Hgfs"""
$process = [diagnostics.process]::start($tmpPath+"\"+$vmwFile, $arguments)
$process.WaitForExit()

#INSTALL WINDOWS UPDATES supress reboot
Get-WUInstall -AcceptAll -IgnoreReboot
#$reboot = (Get-WURebootStatus -Silent)

#REBOOT
#if ($reboot) {Restart-Computer}