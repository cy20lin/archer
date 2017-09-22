#minimize notepad example
$signature = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@
$showWindowAsync = Add-Type -MemberDefinition $signature -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru
$showWindowAsync::ShowWindowAsync((Get-Process -name notepad).MainWindowHandle, 2)

#Set focus to notepad example
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Tricks {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@
