# Class Include
$IncludeFile = Join-Path $PSScriptRoot "TelnetClient.ps1"
if( -not (Test-Path $IncludeFile) ){
	echo "[FAIL] $IncludeFile not found !"
	exit
}
. $IncludeFile

# インスタンス化
$Telnet = New-Object TelnetClient

# 動作環境変更
# $Telnet.SetEnvironment( $null, $null, $null, $true, $true )

# 接続
$Telnet.Connect( "172.16.0.254", 23 )

# ネゴシエーションしてログインプロンプトを待つ
$ReceiveStrings = $Telnet.Receive( "login:" )

# ID 送信
$Telnet.Send( "admin", $true )

# パスワードプロンプトを待つ
$ReceiveStrings = $Telnet.Receive( "Password:" )

# パスワード送信
$Telnet.Send( "P@$$w0rd", $false )

# プロンプトを待つ
$ReceiveStrings = $Telnet.Receive( ">" )

# モード変更
$Telnet.Send( "enable", $true )

# パスワードプロンプトを待つ
$ReceiveStrings = $Telnet.Receive( "Password:" )

# パスワード送信
$Telnet.Send( "P@$$w0rd", $false )

# プロンプトを待つ
$ReceiveStrings = $Telnet.Receive( "#" )

# コマンド送信
$Telnet.Send( "show interface status", $true)

# プロンプトを待つ
$ReceiveStrings = $Telnet.Receive( "#" )

# 受信した内容をテスト表示
foreach( $ReceiveString in $ReceiveStrings ){
	echo "[TEST] $ReceiveString"
}

# コマンド送信
$Telnet.Send( "disable", $true )

# プロンプトを待つ
$ReceiveStrings = $Telnet.Receive( ">" )

# logoff コマンド送信
$Telnet.Send( "exit", $true )

# 切断
$Telnet.DisConnect()

