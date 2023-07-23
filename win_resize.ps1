# Left,Top,Right-Left,Bottom-Top
$OpenList = @(@("C:\Users\aiueo\Desktop\テスト①",175,126,1139,600),
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


function Relocate-Window{
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
  foreach($opn in $OpenList){
    # エクスプローラで開く
    # $process = Start-Process explorer.exe -ArgumentList $opn[0] -PassThru
    Start-Process explorer.exe -ArgumentList $opn[0] -PassThru
    # 開くまで待つ
    $null = $process.WaitForInputIdle() # 必要？
    Start-Sleep -Seconds 3
    #$handle = $process.MainWindowHandle

    $WindowSearchName = Split-Path -Path $opn[0] -Leaf
    $SearchHandle = (Get-Process | ?{$_.MainWindowTitle -eq $WindowSearchName } ).MainWindowHandle
    while($SearchHandle -eq ""){
      $SearchHandle = (Get-Process | ?{$_.MainWindowTitle -eq $WindowSearchName } ).MainWindowHandle
      Write-Host $SearchHandle
    }
    Relocate-Window $SearchHandle $opn[1] $opn[2] $opn[3] $opn[4]
  }
}

Main