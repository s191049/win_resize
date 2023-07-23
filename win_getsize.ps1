  $OpenList = @(@("C:\Users\aiueo\Desktop\テスト①",0,0,800,800),
                @("C:\Users\aiueo\Desktop\テスト②",0,0,100,100))

#====================================================================
# ウインドウサイズを変更する関数 Resize-Window
#====================================================================
Add-Type @"
using System;
using System.Runtime.InteropServices;

public struct RECT
{
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}

public class WinAPI
{
    // ウインドウの現在の座標データを取得する関数
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    // ウインドウの座標を変更する関数
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
"@

function GetWindowPosition($wh){
    $rc = New-Object RECT
    $hoge = [WinAPI]::GetWindowRect($wh, [ref]$rc)
    Write-Host "Left" $rc.Left
    Write-Host "Top" $rc.Top
    Write-Host "Right" $rc.Right
    Write-Host "Bottom" $rc.Bottom

}


function Main(){
    $Processes = Get-Process -Name "explorer"
    foreach($pr in $Processes){
        $wh = $pr.MainWindowHandle
        $title = $pr.MainWindowTitle
        Write-Host "★ $title"
        GetWindowPosition $wh
    }
}

Main