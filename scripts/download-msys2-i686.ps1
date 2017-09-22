# $url = "http://mirror.internode.on.net/pub/test/10meg.test"
$url = "https://downloads.sourceforge.net/project/msys2/Base/i686/msys2-base-i686-20161025.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmsys2%2Ffiles%2FBase%2Fi686%2F&ts=1497707915&use_mirror=nchc"
$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
# $output_dir = "$pwd"
$output_dir = "$PSScriptRoot"
$output_name = "msys2-base-i686-20161025.tar.xz"
$output = "$output_dir\$output_name"
Write-Output "$output"
$start_time = Get-Date

# Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
#OR
# Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
