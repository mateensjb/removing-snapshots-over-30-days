Write-Host "starting script...."

 

# Local variables
$vcenter = "myvcenter.domain.com"
$vcenter_user = "username"
$vcenter_pass = "password"
$vms = "" 
$snaps = ""

 

# Email Variables
$To = “to@gmail.com”
$From = “from@gmail.com”
$Subject = “ALERT: Snapshots over 30 days deleted.”
$emailMessage = "The following VMS have snapshots over 30 days: `n $vms `n `n The following snapshots have been deleted: `n $snapsDelete"
$SmtpServer = “smtp.server.com”
$Port = 25

 

Write-Host "------------CONNECT TO VCENTER-------------"
# Connect-VIServer -Server vsca-01a.corp.Local -User administrator@vsphere.Local-Password VMware1!
Connect-VIServer -Server $vcenter -User $vcenter_user -Password $vcenter_pass  | Out-Null

 

Write-Host "`n------------GET ALL VMS-------------"
#$vms = Get-VM
$vms = Get-VM #| Format-Table -AutoSize| Select-Object Name
Write-Host $vms

 

Write-Host "`n------------GET ALL SNAPSHOTS-------------"
$snaps = Get-VM | Get-Snapshot
#Write-Host $snaps

 

Write-Host "`n------------OVER 30 DAYS SNAPS-------------"
snapsDelete = Get-VM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays(-30)}
write-Host $snapsDelete

 

Write-Host "`n------------DELETE SNAPSHOTS-------------"
$snapsDelete | Remove-Snapshot -Confirm:$false

 

Write-Host "`n------------DISCONNECT FROM VCENTER-------------"
# Disconnect to VCenter
Disconnect-VIServer -Server $vcenter -Confirm:$False -Force | Out-Null

 

Write-Host "`n------------SEND EMAIL-------------"
Send-MailMessage -To $To -From $From  -Subject $Subject -Body $emailMessage -SmtpServer $SmtpServer -Port $Port