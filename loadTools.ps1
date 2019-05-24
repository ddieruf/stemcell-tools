$tmp = "C:\tmp"
mkdir $tmp; cd $tmp

#GET WINDOWS UPDATE MODULES
$filename = "PSWindowsUpdate.zip"
Invoke-WebRequest -Uri "http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/25/PSWindowsUpdate.zip" -OutFile $filename
Expand-Archive -Path $filename -DestinationPath "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"

#INSTALL VMWARE-TOOLS
$filename = "vmware-tools.exe"
Invoke-WebRequest -Uri "https://packages.vmware.com/tools/releases/10.3.10/windows/x64/VMware-tools-10.3.10-12406962-x86_64.exe" -OutFile $filename

$arguments = "/S /v ""/qn REBOOT=R ADDLOCAL=ALL REMOVE=Hgfs"""
$process = [diagnostics.process]::start($filename, $arguments)
$process.WaitForExit()

#INSTALL WINDOWS UPDATES supress reboot
Get-WUInstall -AcceptAll -IgnoreReboot
$reboot = (Get-WURebootStatus -Silent)

#REBOOT
if ($reboot) {Reboot-Computer}