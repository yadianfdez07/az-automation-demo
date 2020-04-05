$ResourceGroupName = "oc-automation-rg";

$Location = "eastus";

$AutomationAccountName = "oc-automator-acct";

$PlanType = "Free";


$PathToRunbook = (Resolve-Path -Path ".\Stop-VmRunbook.ps1").Path;

$RunbookName = "Stop-VmRunbook";

$StartDateTime = (Get-Date "18:00:00").AddDays(5);

$DayOfWeek =  $StartDateTime.DayOfWeek;

$AutomationScheduleName = "Stop-VmSchedule";

$ScheduleTimeZone = "America/New_York";

.\New-AzAutomationAccount.ps1 -ResourceGroupName $ResourceGroupName `
    -Location $Location -AutomationAccountName $AutomationAccountName `
    -PlanType $PlanType -PathToRunbook $PathToRunbook -RunbookName $RunbookName `
    -StartDateTime $StartDateTime -DayOfWeek $DayOfWeek -AutomationScheduleName $AutomationScheduleName `
    -ScheduleTimeZone $ScheduleTimeZone;