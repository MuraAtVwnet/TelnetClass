# Include
$IncludeFile = Join-Path $PSScriptRoot "sample2Class.ps1"
if( -not (Test-Path $IncludeFile) ){
	echo "[FAIL] $IncludeFile not found !"
	exit
}
. $IncludeFile

# インスタンス化
$Telnet = New-Object TelnetAllied

# 動作環境変更
# $Telnet.SetEnvironment( $null, $null, $null, $true, $true )

# 接続
$Telnet.Connect( "172.16.0.254", 23 )

# Logon
$Telnet.Logon( "P@$$w0rd" )

# コマンド送信
$ReceiveStrings = $Telnet.SendCommand( "show interface status" )

# 受信内容をテスト表示
foreach( $ReceiveString in $ReceiveStrings ){
	echo "[TEST] $ReceiveString"
}

# logoff
$Telnet.Logoff()
