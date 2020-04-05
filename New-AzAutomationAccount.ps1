[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [String]
    $ResourceGroupName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $Location,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $AutomationAccountName,
    
    # Parameter help description
    [Parameter(Mandatory)]
    [String]
    $PlanType,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $PathToRunbook,

    # Parameter help description
    [Parameter(Mandatory)]
    [String]
    $RunbookName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [DateTime]
    $StartDateTime,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [DayOfWeek]
    $DayOfWeek,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $AutomationScheduleName,

    # Parameter help description
    [Parameter(Mandatory = $true)]
    [String]
    $ScheduleTimeZone

)

$ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue;



if ($notPresent) {    
    $ResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $Location;
}

$AutomationAccount = Get-AzAutomationAccount -Name $AutomationAccountName -ResourceGroupName $ResourceGroup.ResourceGroupName -ErrorVariable noAutomationAccount  -ErrorAction SilentlyContinue;

if ($noAutomationAccount) {
    $AutomationAccount = New-AzAutomationAccount -Name $AutomationAccountName -ResourceGroupName $ResourceGroup.ResourceGroupName -Location $Location -Plan $PlanType;   
}

Import-AzAutomationRunbook -Path $PathToRunbook -Name $RunbookName -Type PowerShell -ResourceGroupName $ResourceGroup.ResourceGroupName -AutomationAccountName $AutomationAccount.AutomationAccountName -Force;

New-AzAutomationSchedule -AutomationAccountName $AutomationAccount.AutomationAccountName -Name $AutomationScheduleName -StartTime $StartDateTime -WeekInterval 1 -DaysOfWeek $DayOfWeek -ResourceGroupName $ResourceGroup.ResourceGroupName -TimeZone $ScheduleTimeZone;

Publish-AzAutomationRunbook -AutomationAccountName $AutomationAccount.AutomationAccountName -Name $RunbookName -ResourceGroupName $ResourceGroup.ResourceGroupName;

$parameters = @{ResourceGroupNames =  @("rg-one", "rg-two")};

Register-AzAutomationScheduledRunbook -AutomationAccountName $AutomationAccount.AutomationAccountName -Name $RunbookName -ScheduleName $AutomationScheduleName -ResourceGroupName $ResourceGroup.ResourceGroupName -Parameters $parameters;