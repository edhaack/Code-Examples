# Markus Scholtes, DEVK 2017
# Create examples in subdir "Examples"

$SCRIPTPATH = Split-Path $SCRIPT:MyInvocation.MyCommand.Path -parent
gci "$SCRIPTPATH\PowerShellScript\*.ps1" | %{
	."$SCRIPTPATH\ps2exe.ps1" "$($_.Fullname)" "$($_.Fullname -replace '.ps1','.exe')" -verbose
	."$SCRIPTPATH\ps2exe.ps1" "$($_.Fullname)" "$($_.Fullname -replace '.ps1','-GUI.exe')" -verbose -noConsole
}

$NULL = Read-Host "Press enter to exit"