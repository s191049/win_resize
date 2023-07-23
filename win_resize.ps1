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


# function Relocate-Window($wh, $left, $top, $width, $height) {
function Relocate-Window{
<#
    # ウインドウ座標データ構造体
    # $rc = New-Object RECT

    # ウインドウの現在の座標データを取得
    # [WinAPI]::GetWindowRect($wh, [ref]$rc) > $null
#>
    Param(
      $wh,
      $left,
      $top,
      $width,
      $height
    )
    # ウインドウの位置とサイズを変更
    [WinAPI]::MoveWindow($wh, $left, $top, $width, $height, $true) > $null
}


function Main(){
  $OpenList = @(@("C:\Users\正太\Desktop",0,0,800,800),@("C:\Users\正太\Downloads",0,0,100,100))
  foreach($opn in $OpenList){
    $process = Start-Process explorer.exe -ArgumentList $opn[0] -PassThru
    # $process = Start-Process explorer.exe -PassThru
    $null = $process.WaitForInputIdle()
    Start-Sleep -Seconds 5
    $handle = $process.MainWindowHandle
    
    
    $LatestProcess = Get-Process -Name "Explorer" | Sort-Object Start-Time -Descending | Select-Object -First 1
    
    $LatestHandle = $LatestProcess.MainWindowHandle
    
    # Relocate-Window $handle $opn[1] $opn[2] $opn[3] $opn[4]
    
    Relocate-Window $LatestHandle $opn[1] $opn[2] $opn[3] $opn[4]
  }
}

Main