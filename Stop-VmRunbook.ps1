
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String[]]
    $ResourceGroupNames
)

$VerbosePreference = 'Continue';

$VirtualMachines = @();

Write-Verbose "[*] logging into Azure"
$conn = Get-AutomationConnection -Name AzureRunAsConnection;
$null = Add-AzureRmAccount -ServicePrincipal -Tenant $conn.TenantID -ApplicationId $conn.ApplicationID -CertificateThumbprint $conn.CertificateThumbprint;

$ResourceGroupNames | ForEach-Object {
    $VirtualMachines += Get-AzureRmVM -ResourceGroupName $_;
}

$VirtualMachines | ForEach-Object {
    $vmRg = $_.ResourceGroupName;
    $vmName = $_.Name;
    $null = Stop-AzureRmVM -Name $vmName -ResourceGroupName $vmRg -Force;
}

