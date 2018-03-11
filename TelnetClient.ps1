##############################################
# Telnet Client Class
##############################################
class TelnetClient {

	### 定数($CC_ : Class Constant)
	# 命令
	[byte] $CC_SE		= 0xf0
	[byte] $CC_SB		= 0xfa
	[byte] $CC_WILL		= 0xfb
	[byte] $CC_WONT		= 0xfc
	[byte] $CC_DO		= 0xfd
	[byte] $CC_DONT		= 0xfe
	[byte] $CC_IAC		= 0xff

	# オプション
	[byte] $CC_ECHO 				= 0x01
	[byte] $CC_GoAhead				= 0x03
	[byte] $CC_Status				= 0x05
	[byte] $CC_TerminalType			= 0x18
	[byte] $CC_WindowSize			= 0x1f
	[byte] $CC_TearminlSpeed		= 0x20
	[byte] $CC_ToggleFlowControl	= 0x21
	[byte] $CC_LineMode				= 0x22
	[byte] $CC_DisplayLocation		= 0x23
	[byte] $CC_EnviromentOptin		= 0x24
	[byte] $CC_NewEnviromentOptin	= 0x27

	# 継続文字
	[byte] $CC_Terminator			= 0x01
	[byte] $CC_NotTerminat			= 0x00

	# 初期設定値
	[byte] $CC_InitValue			= 0x50
	[byte] $CC_FinishValue			= 0x51

	### デシジョンテーブル 用
	# NOP
	[byte] $CC_Nop					= 0x5f

	# Null
	[string] $CC_strNull			= "Null"

	# 対象システム
	[string] $CC_TergetClient 		= "Client"
	[string] $CC_TergetServer		= "Server"

	# 初期値を表現する文字列
	[string] $CC_strInitValue		= "InitValue"

	# バイナリ Decode
	[Hashtable] $CC_TelnetControlDecode = @{
		$this.CC_SE					= "SE"
		$this.CC_SB					= "SB"
		$this.CC_WILL				= "WILL"
		$this.CC_WONT				= "WONT"
		$this.CC_DO					= "DO"
		$this.CC_DONT				= "DONT"
		$this.CC_IAC				= "IAC"

		$this.CC_ECHO				= "ECHO"
		$this.CC_GoAhead			= "GoAhead"
		$this.CC_Status				= "Status"
		$this.CC_TerminalType		= "TerminalType"
		$this.CC_WindowSize			= "WindowSize"
		$this.CC_TearminlSpeed		= "TearminlSpeed"
		$this.CC_ToggleFlowControl	= "ToggleFlowControl"
		$this.CC_LineMode			= "LineMode"
		$this.CC_DisplayLocation	= "DisplayLocation"
		$this.CC_EnviromentOptin	= "EnviromentOptin"
		$this.CC_NewEnviromentOptin	= "NewEnviromentOptin"

		$this.CC_InitValue			= "InitValue"
		$this.CC_FinishValue		= "FinishValue"
		$this.CC_Nop				= "Nop"
	}

	# テキスト Encode
	[Hashtable] $CC_TelnetControlEncode = @{
		"SE"					= $this.CC_SE
		"SB"					= $this.CC_SB
		"WILL"					= $this.CC_WILL
		"WONT"					= $this.CC_WONT
		"DO"					= $this.CC_DO
		"DONT"					= $this.CC_DONT
		"IAC"					= $this.CC_IAC

		"ECHO"					= $this.CC_ECHO
		"GoAhead"				= $this.CC_GoAhead
		"Status"				= $this.CC_Status
		"TerminalType"			= $this.CC_TerminalType
		"WindowSize"			= $this.CC_WindowSize
		"TearminlSpeed"			= $this.CC_TearminlSpeed
		"ToggleFlowControl"		= $this.CC_ToggleFlowControl
		"LineMode"				= $this.CC_LineMode
		"DisplayLocation"		= $this.CC_DisplayLocation
		"EnviromentOptin"		= $this.CC_EnviromentOptin
		"NewEnviromentOptin"	= $this.CC_NewEnviromentOptin

		"InitValue"				= $this.CC_InitValue
		"FinishValue"			= $this.CC_FinishValue
		"Nop"					= $this.CC_Nop
	}


	### 設定($CCONF_ : Class Config)
	# デシジョンテーブル
	[System.Object[]] $CCONF_DecisionTable


	## 使用する   $true
	## 使用しない $false
	# Client 設定
	[Hashtable] $CCONF_TelnetClientConfig = @{

		$this.CC_ECHO				= $false	# ECHO
		$this.CC_GoAhead			= $true		# Suppress Go Ahead
		$this.CC_Status				= $false	# Status
		$this.CC_TerminalType		= $true		# Terminal Type
		$this.CC_WindowSize			= $true		# Window Size
		$this.CC_TearminlSpeed		= $false	# Tearminl Speed
		$this.CC_ToggleFlowControl	= $false	# Toggle Flow Control
		$this.CC_LineMode			= $true		# Line Mode
		$this.CC_DisplayLocation	= $false	# Display Location
		$this.CC_EnviromentOptin	= $false	# Enviroment Optin
		$this.CC_NewEnviromentOptin	= $true		# New Enviroment Optin
	}

	# Server 設定
	[Hashtable] $CCONF_TelnetServerConfig = @{
		$this.CC_ECHO				= $true		# ECHO
		$this.CC_GoAhead			= $true		# Suppress Go Ahead
		$this.CC_Status				= $false	# Status
	#	$this.CC_TerminalType		= $false	# Terminal Type
	#	$this.CC_WindowSize			= $false	# Window Size
	#	$this.CC_TearminlSpeed		= $false	# Tearminl Speed
		$this.CC_ToggleFlowControl	= $false	# Toggle Flow Control
	#	$this.CC_LineMode			= $false	# Line Mode
	#	$this.CC_DisplayLocation	= $false	# Display Location
	#	$this.CC_EnviromentOptin	= $false	# Enviroment Optin
	#	$this.CC_NewEnviromentOptin	= $false	# New Enviroment Optin
	}

	# バッファサイズ
	[int] $CCONF_BufferSize = 1024

	# ログファイルフルパス
	[string] $CCONF_LogPath = ""

	# ログを記録しない
	[bool] $CCONF_NotRecordLog = $false

	# タイムアウト
	[int] $CCONF_TimeOut = 30

	# デバッグコントロール
	[bool] $CCONF_Debug = $false

	# 開発デバッグコントロール
	[bool] $CCONF_DevDebug = $false

	### 変数($CV_ : Class Variable)

	# 直前送信状態
	[Hashtable] $CV_PreSendStatus = @{
		$this.CC_ECHO				= $this.CC_InitValue	# ECHO
		$this.CC_GoAhead			= $this.CC_InitValue	# Suppress Go Ahead
		$this.CC_Status				= $this.CC_InitValue	# Status
		$this.CC_TerminalType		= $this.CC_InitValue	# Terminal Type
		$this.CC_WindowSize			= $this.CC_InitValue	# Window Size
		$this.CC_TearminlSpeed		= $this.CC_InitValue	# Tearminl Speed
		$this.CC_ToggleFlowControl	= $this.CC_InitValue	# Toggle Flow Control
		$this.CC_LineMode			= $this.CC_InitValue	# Line Mode
		$this.CC_DisplayLocation	= $this.CC_InitValue	# Display Location
		$this.CC_EnviromentOptin	= $this.CC_InitValue	# Enviroment Optin
		$this.CC_NewEnviromentOptin	= $this.CC_InitValue	# New Enviroment Optin
	}

	# Client 設定状態
	[Hashtable] $CV_TelnetClientStatus = @{
		$this.CC_ECHO				= $this.CC_InitValue	# ECHO
		$this.CC_GoAhead			= $this.CC_InitValue	# Suppress Go Ahead
		$this.CC_Status				= $this.CC_InitValue	# Status
		$this.CC_TerminalType		= $this.CC_InitValue	# Terminal Type
		$this.CC_WindowSize			= $this.CC_InitValue	# Window Size
		$this.CC_TearminlSpeed		= $this.CC_InitValue	# Tearminl Speed
		$this.CC_ToggleFlowControl	= $this.CC_InitValue	# Toggle Flow Control
		$this.CC_LineMode			= $this.CC_InitValue	# Line Mode
		$this.CC_DisplayLocation	= $this.CC_InitValue	# Display Location
		$this.CC_EnviromentOptin	= $this.CC_InitValue	# Enviroment Optin
		$this.CC_NewEnviromentOptin	= $this.CC_InitValue	# New Enviroment Optin
	}

	# Server 設定状態
	[Hashtable] $CV_TelnetServerStatus = @{
		$this.CC_ECHO				= $this.CC_InitValue	# ECHO
		$this.CC_GoAhead			= $this.CC_InitValue	# Suppress Go Ahead
		$this.CC_Status				= $this.CC_InitValue	# Status
	#	$this.CC_TerminalType		= $this.CC_InitValue	# Terminal Type
	#	$this.CC_WindowSize			= $this.CC_InitValue	# Window Size
	#	$this.CC_TearminlSpeed		= $this.CC_InitValue	# Tearminl Speed
		$this.CC_ToggleFlowControl	= $this.CC_InitValue	# Toggle Flow Control
	#	$this.CC_LineMode			= $this.CC_InitValue	# Line Mode
	#	$this.CC_DisplayLocation	= $this.CC_InitValue	# Display Location
	#	$this.CC_EnviromentOptin	= $this.CC_InitValue	# Enviroment Optin
	#	$this.CC_NewEnviromentOptin	= $this.CC_InitValue	# New Enviroment Optin
	}

	# ソケット
	[System.Net.Sockets.TcpClient] $CV_Socket

	# ストリーム
	[System.Net.Sockets.NetworkStream] $CV_Stream

	# ライター
	[System.IO.StreamWriter] $CV_Writer

	# 受信バッファ
	[Byte[]] $CV_ReceiveBuffer

	# 送信バッファ
	[Byte[]] $CV_SendBuffer

	# 受信バッファ Index
	[int] $CV_ReceiveBufferIndex

	# 送信バッファ Index
	[int] $CV_SendBufferIndex


	##########################################################################
	# コンストラクタ(protected)
	##########################################################################
	TelnetClient(){
	}

	##########################################################################
	# コンストラクタ(protected)
	##########################################################################
	TelnetClient([string]$RemoteHost, [int]$Port ){
		# 接続
		$this.Connect($RemoteHost, $Port)
	}

	##########################################################################
	# デシジョンテーブルセット(protected)
	##########################################################################
	[void] SetDecisionTable(){
		# CSV ファイル Path
		$CSV = Join-Path $PSScriptRoot "DecisionTable.csv"

		# CSV 読み込み
		if( Test-Path $CSV ){
			$this.CCONF_DecisionTable = Import-Csv $CSV
		}
		else{
			$FailMessage = "[FAIL] $CSV not found !"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}

		# 文字をバイナリ値へ更新する
		$Max = $this.CCONF_DecisionTable.Count
		for( $i = 0; $i -lt $Max; $i++ ){

			# 受信命令
			if( $this.CCONF_DecisionTable[$i].ReceiveOrder -ne "" ){
				$this.CCONF_DecisionTable[$i].ReceiveOrder = $this.CC_TelnetControlEncode[$this.CCONF_DecisionTable[$i].ReceiveOrder]
			}

			# 直前送信
			if( $this.CCONF_DecisionTable[$i].PreSend -ne "" ){
				$this.CCONF_DecisionTable[$i].PreSend = $this.CC_TelnetControlEncode[$this.CCONF_DecisionTable[$i].PreSend]
			}

			# ステータス設定
			if( ($this.CCONF_DecisionTable[$i].SetStatus -ne "") -or ($this.CCONF_DecisionTable[$i].SetStatus -ne "x") ){
				$this.CCONF_DecisionTable[$i].SetStatus = $this.CC_TelnetControlEncode[$this.CCONF_DecisionTable[$i].SetStatus]
			}

			# 受信オプション
			if( $this.CCONF_DecisionTable[$i].ReceiveOption -ne "" ){
				$this.CCONF_DecisionTable[$i].ReceiveOption = $this.CC_TelnetControlEncode[$this.CCONF_DecisionTable[$i].ReceiveOption]
			}

			# 送信命令
			if( $this.CCONF_DecisionTable[$i].SendOrder -ne "" ){
				$this.CCONF_DecisionTable[$i].SendOrder = $this.CC_TelnetControlEncode[$this.CCONF_DecisionTable[$i].SendOrder]
			}
		}
	}

	##########################################################################
	# byte から Hex へ変換(protected)
	##########################################################################
	[string] Byte2Hex([byte] $InData){
		[string] $HexString = "0x" + $InData.ToString("x")
		return $HexString
	}



	##########################################################################
	# Client 未処理オプション リクエスト(protected)
	##########################################################################
	[void] RequestNotSetClientOption(){

		#### Client 未設定
		# 未設定 Client キーの有無確認
		$Result = $this.CV_TelnetClientStatus.ContainsValue($this.CC_InitValue)
		if( $Result -eq $true ){
			if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] Client 未設定あり") }

			# KeyCollection としてのキーを取得
			$KeyCollectionKeys = $this.CV_TelnetClientStatus.Keys

			# 配列に格納
			$Keys = @()
			foreach ( $KeyCollectionKey in $KeyCollectionKeys ){
				$Keys += $KeyCollectionKey
			}


			# 未設定キー
			$NotSetClientKeys = @()

			# 未設定オプションの列挙
			foreach( $Key in $Keys ){
				$Status = $this.CV_TelnetClientStatus[$Key]

				if( $Status -eq $this.CC_InitValue ){
					# 未設定オプション
					$NotSetClientKeys += $Key

					if( $this.CCONF_DevDebug ){
						$Option = $this.CC_TelnetControlDecode[$Key]
						Write-Host $this.Log( "[DEBUG] Client $Option not set" )
					}
				}
			}

			if( $this.CCONF_DevDebug ){
				$HandShakeMessage = "[DEBUG] デシジョンテーブル抽出条件 / 能動処理 Y : 処理対象 $this.CC_TergetClient"
				Write-Host $this.Log($HandShakeMessage)
			}

			# 未設定オプションごとにリクエストメッセージを作る
			foreach( $NotSetKey in $NotSetClientKeys ){
				[array]$NotSetOptionAnalysis = $this.CCONF_DecisionTable |
													? ActiveSet -eq "Y" |					# 能動処理
													? Terget -eq $this.CC_TergetClient 		# Client 対象

				# オプション
				$binOption = $NotSetKey
				$strOption =  $this.CC_TelnetControlDecode[$binOption]
				$hexOption = $this.Byte2Hex($binOption)

				# 未設定オプションを使用するか否かの確認
				$IsUseOption = $this.CCONF_TelnetClientConfig[$NotSetKey]
				if( $IsUseOption -eq $true ){
					$strIsUseOption = "Y"
				}
				else{
					$strIsUseOption = "N"
				}

				if( $this.CCONF_DevDebug ){
					$HandShakeMessage = "[DEBUG] デシジョンテーブル特定条件 / / 能動処理 Y : 処理対象 $this.CC_TergetClient : オプション使用するか否か $strIsUseOption"
					Write-Host $this.Log($HandShakeMessage)
				}

				# デシジョンテーブル参照
				$NotSetOptionAnalysis = $NotSetOptionAnalysis |
											? UseOptionClient -eq $strIsUseOption

				# デシジョンテーブルチェック
				if( $NotSetOptionAnalysis.Count -eq 0 ){
					# デシジョンテーブルが足りていない
					$FailMessage = "[FAIL] デシジョンテーブルが足りていない / 能動送信 Client : オプション $strOption"
					$this.Log($FailMessage)
					throw $FailMessage
					exit
				}
				elseif( $NotSetOptionAnalysis.Count -eq 1 ){
					# エラー判定の可能性が高いので確認
					$ErrorFlag = $NotSetOptionAnalysis[0].Error
					if( $ErrorFlag -ne "" ){
						$FailMessage = "[FAIL] エラー判定 / 能動送信 Client : オプション $strOption"
						$this.Log($FailMessage)
						throw $FailMessage
						exit
					}
				}
				else{
					# デシジョンテーブルが特定できない
					$FailMessage = "[FAIL] デシジョンテーブルが特定できない / 能動送信 Client : オプション $strOption"
					$this.Log($FailMessage)
					throw $FailMessage
					exit
				}

				if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] デシジョンテーブル特定 / 能動送信 : 対象 Client : オプション $strOption") }


				# 送信バッファセット
				$binSendOrder = $NotSetOptionAnalysis.SendOrder
				$strSendOrder = $this.CC_TelnetControlDecode[$binSendOrder]
				$hexSendOrder = $this.Byte2Hex($binSendOrder)

				if( $this.CCONF_Debug ){
					$HandShakeMessage ="[Send/Client] IAC "
					$HandShakeMessage += $strSendOrder + " "
					$HandShakeMessage += $strOption
					Write-Host $this.Log($HandShakeMessage)
				}

				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC	# IAC
				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binSendOrder	# 命令
				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binOption	# オプション

				# ワーニング
				if( $NotSetOptionAnalysis.Warning -ne "" ){
					if( $this.CCONF_Debug ){ Write-Host $this.Log("[WARN] ワーニング判定 / 能動送信 : オプション $strOption : オプションを使用するか否か $IsUseOption : 送信命令 $strSendOrder") }
				}

				# 直前送信セット
				if( $NotSetOptionAnalysis.SetPreSend -ne "" ){
					$this.CV_PreSendStatus[$binOption] = $binSendOrder
					if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] 直前送信セット $strSendOrder") }
				}

				# ステータスセット
				if( $NotSetOptionAnalysis.SetStatus -ne "" ){
					# Client
					$this.CV_TelnetClientStatus[$binOption] = $binSendOrder
					if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] ステータスセット $strSendOrder") }
				}
			}
		}
	}

	##########################################################################
	# Server 未処理オプション リクエスト(protected)
	##########################################################################
	[void] RequestNotSetServerOption(){

		#### Server 未設定
		# 未設定 Server キーの有無確認
		$Result = $this.CV_TelnetServerStatus.ContainsValue($this.CC_InitValue)
		if( $Result -eq $true ){
			if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] Server 未設定あり") }

			# KeyCollection としてのキーを取得
			$KeyCollectionKeys = $this.CV_TelnetServerStatus.Keys

			# 配列に格納
			$Keys = @()
			foreach ( $KeyCollectionKey in $KeyCollectionKeys ){
				$Keys += $KeyCollectionKey
			}


			# 未設定キー
			$NotSetServerKeys = @()

			# 未設定オプションの列挙
			foreach( $Key in $Keys ){
				$Status = $this.CV_TelnetServerStatus[$Key]

				if( $Status -eq $this.CC_InitValue ){
					# 未設定オプション
					$NotSetServerKeys += $Key

					if( $this.DevDebug ){
						$Option = $this.CC_TelnetControlDecode[$Key]
						Write-Host $this.Log( "[DEBUG] Server $Option not set" )
					}
				}
			}

			if( $this.CCONF_DevDebug ){
				$HandShakeMessage = "[DEBUG] デシジョンテーブル抽出条件 / 能動処理 Y : 処理対象 $this.CC_TergetServer"
				Write-Host $this.Log($HandShakeMessage)
			}

			# 未設定オプションごとにリクエストメッセージを作る
			foreach( $NotSetKey in $NotSetServerKeys ){
				[array]$NotSetOptionAnalysis = $this.CCONF_DecisionTable |
													? ActiveSet -eq "Y" |					# 能動処理
													? Terget -eq $this.CC_TergetServer 		# Server 対象

				# オプション
				$binOption = $NotSetKey
				$strOption =  $this.CC_TelnetControlDecode[$binOption]
				$hexOption = $this.Byte2Hex($binOption)

				# 未設定オプションを使用するか否かの確認
				$IsUseOption = $this.CCONF_TelnetServerConfig[$NotSetKey]
				if( $IsUseOption -eq $true ){
					$strIsUseOption = "Y"
				}
				else{
					$strIsUseOption = "N"
				}

				if( $this.CCONF_DevDebug ){
					$HandShakeMessage = "[DEBUG] デシジョンテーブル特定条件 / 能動処理 Y : 処理対象 $this.CC_TergetServer : オプション使用するか否か $strIsUseOption"
					Write-Host $this.Log($HandShakeMessage)
				}

				# デシジョンテーブル参照
				$NotSetOptionAnalysis = $NotSetOptionAnalysis |
											? UseOptionServer -eq $strIsUseOption

				# デシジョンテーブルチェック
				if( $NotSetOptionAnalysis.Count -eq 0 ){
					# デシジョンテーブルが足りていない
					$this.Log("[FAIL] デシジョンテーブルが足りていない / 能動送信 Server : オプション $strOption")
					throw "[FAIL] デシジョンテーブルが足りていない / 能動送信 Server : オプション $strOption"
					exit
				}
				elseif( $NotSetOptionAnalysis.Count -eq 1 ){
					# エラー判定の可能性が高いので確認
					$ErrorFlag = $NotSetOptionAnalysis[0].Error
					if( $ErrorFlag -ne "" ){
						$FailMessage = "[FAIL] エラー判定 / 能動送信 Server : オプション $strOption"
						$this.Log($FailMessage)
						throw $FailMessage
						exit
					}
				}
				else{
					# デシジョンテーブルが特定できない
					$FailMessage = "[FAIL] デシジョンテーブルが特定できない / 能動送信 Server : オプション $strOption"
					$this.Log($FailMessage)
					throw $FailMessage
					exit
				}

				if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] デシジョンテーブル特定 / 能動送信 : 対象 Server : オプション $strOption") }


				# 送信バッファセット
				$binSendOrder = $NotSetOptionAnalysis.SendOrder
				$strSendOrder = $this.CC_TelnetControlDecode[$binSendOrder]
				$hexSendOrder = $this.Byte2Hex($binSendOrder)

				if( $this.CCONF_Debug ){
					$HandShakeMessage ="[Send/Server] IAC "
					$HandShakeMessage += $strSendOrder + " "
					$HandShakeMessage += $strOption
					Write-Host $this.Log($HandShakeMessage)
				}

				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC	# IAC
				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binSendOrder	# 命令
				$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binOption	# オプション

				# ワーニング
				if( $NotSetOptionAnalysis.Warning -ne "" ){
					if( $this.CCONF_Debug ){ Write-Host $this.Log("[WARN] ワーニング判定 / 能動送信 : オプション $strOption : オプションを使用するか否か $IsUseOption : 送信命令 $strSendOrder") }
				}

				# 直前送信セット
				if( $NotSetOptionAnalysis.SetPreSend -ne "" ){
					$this.CV_PreSendStatus[$binOption] = $binSendOrder
					if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] 直前送信セット $strSendOrder") }
				}

				# ステータスセット
				if( $NotSetOptionAnalysis.SetStatus -ne "" ){
					# Server
					$this.CV_TelnetServerStatus[$binOption] = $binSendOrder
					if( $this.CCONF_DevDebug ){ Write-Host $this.Log("[DEBUG] ステータスセット $strSendOrder") }
				}
			}
		}
	}


	##########################################################################
	# 未処理オプション リクエスト(protected)
	##########################################################################
	[void] RequestNotSetOption(){

		# Client 未設定をリクエスト
		$this.RequestNotSetClientOption()

		# Server 未設定をリクエスト
		$this.RequestNotSetServerOption()
	}


	##########################################################################
	# SB 用のデシジョンテーブル抽出
	##########################################################################
	[PSCustomObject]SelectDecisionTable4SB($binOrder, $binOption){

		# 命令
		$strOrder = $this.CC_TelnetControlDecode[$binOrder]
		$hexOrder = $this.Byte2Hex($binOrder)

		# オプション
		$strOption =  $this.CC_TelnetControlDecode[$binOption]
		$hexOption = $this.Byte2Hex($binOption)

		if( $this.CCONF_DevDebug ){
			$HandShakeMessage = "[DEBUG] デシジョンテーブル抽出条件 / IAC : 命令 $strOrder : オプション $strOption"
			Write-Host $this.Log($HandShakeMessage)
		}

		# 命令でデシジョンテーブルを絞る
		[array]$ReceiveMessageAnalysis = $this.CCONF_DecisionTable |
											? ReceiveEscape -eq "Y" |		# IAC
											? ReceiveOrder -eq $binOrder	# 命令

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			# デシジョンテーブルが足りていない
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		# 1件ならエラー判定になっていないか確認
		elseif( $ReceiveMessageAnalysis.Count -eq 1 ){
			# エラー判定の可能性が高いので確認
			$ErrorFlag = $ReceiveMessageAnalysis[0].Error
			if( $ErrorFlag -ne "" ){
				$FailMessage = "[FAIL] エラー判定 / IAC 受信 : 命令 $strOrder : オプション $strOption : Error $ErrorFlag"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}

		### 直前送信を特定する
		# 対象システム確認
		$ContainsClinet =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetClient )	# Client が含まれているか
		$ContainsServer =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetServer )	# Server が含まれているか

		# 各対象システムに設定されている状態確認
		# Client
		$ClientStatus = $this.CV_TelnetClientStatus[$binOption]
		if( $ClientStatus -eq $this.CC_FinishValue){
			# 終了の場合は初期値と同じ扱い
			$ClientStatus = $this.CC_InitValue
		}

		# Server
		$ServerStatus = $this.CV_TelnetServerStatus[$binOption]
		if( $ServerStatus -eq $this.CC_FinishValue){
			# 終了の場合は初期値と同じ扱い
			$ServerStatus = $this.CC_InitValue
		}

		# 値がセットされているシステム確認
		# Client だけ
		if( ($ContainsClinet -eq $true) -and ( $ContainsServer -eq $false )){
			if( $ClientStatus -eq $null ){
				# 未知のオプションなので、状態と不使用を追加
				$this.CV_TelnetClientStatus.Add( $binOption, $binOrder )
				$ClientStatus = $binOrder
			}

			# システム状態と対象システム設定
			$SystemStatus = $ClientStatus
			$TergetSystem = $this.CC_TergetClient
		}
		# 対象が Server だけ
		elseif( ($ContainsClinet -eq $false) -and ( $ContainsServer -eq $true )){
			if( $ServerStatus -eq $null ){
				# 未知のオプションなので、状態と不使用を追加
				$this.CV_TelnetServerStatus.Add( $binOption, $binOrder )
				$ServerStatus = $binOrder

				# オプションを使用する/しない設定を Null
				# if( $this.CCONF_Debug -eq $true ){ Write-Host $this.Log("[WARN] オプション使用
				# $UseOptionServer = $this.CC_strNull
			}

			# システム状態と対象システム設定
			$SystemStatus = $ServerStatus
			$TergetSystem = $this.CC_TergetServer
		}
		# 対象が Client / Server の両方が含まれて特定出来ないとき
		else{
			$TergetSystem = $null
			# Server / Client のどちらに直前設定がセットされているか
			if($ClientStatus -ne $this.CC_InitValue){
				# Client がセットされている
				$SystemStatus = $ClientStatus
				$TergetSystem = $this.CC_TergetClient
			}
			elseif( $ServerStatus -ne $this.CC_InitValue ){
				# Server がセットされている
				$SystemStatus = $ServerStatus
				$TergetSystem = $this.CC_TergetServer
			}
			else{
				# どちらもセットされていない
				$SystemStatus = $this.CC_InitValue
			}
		}

		$strSystemStatus = $this.CC_TelnetControlDecode[$SystemStatus]

		# 直前送信 でデシジョンテーブルを絞る(IAC / 受信命令は絞り済み)
		[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
											? PreSend -eq $SystemStatus

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		# 1件ならエラー判定になっていないか確認
		elseif( $ReceiveMessageAnalysis.Count -eq 1 ){
			# エラー判定の可能性が高いので確認
			$ErrorFlag = $ReceiveMessageAnalysis[0].Error
			if( $ErrorFlag -ne "" ){
				$FailMessage = "[FAIL] エラー判定 / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}

		# デシジョンテーブル上の対象システム確認
		$ContainsClinet =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetClient )	# Client が含まれているか
		$ContainsServer =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetServer )	# Server が含まれているか

		# Client だけ
		if( ($ContainsClinet -eq $true) -and ( $ContainsServer -eq $false )){

			if( $TergetSystem -eq $this.CC_TergetServer ){
				# 事前送信の判定と違っている
				$FailMessage = "[FAIL] 事前送信とデシジョンテーブルの条件が合致していない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}
		# Server だけ
		elseif( ($ContainsClinet -eq $false) -and ( $ContainsServer -eq $true )){
			if( $TergetSystem -eq $this.CC_TergetClient ){
				# 事前送信の判定と違っている
				$FailMessage = "[FAIL] 事前送信とデシジョンテーブルの条件が合致していない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}
		else{
			$TergetSystem = $ReceiveMessageAnalysis[0].Terget
		}


		# オプションでデシジョンテーブルを絞る
		if( $TergetSystem -eq $this.CC_TergetClient ){
			# Client
			[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
												? ReceiveOption -eq $binOption
		}
		elseif( $TergetSystem -eq $this.CC_TergetServer ){
			# Server
			[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
												? ReceiveOption -eq $binOption
		}

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		elseif( $ReceiveMessageAnalysis.Count -ne 1 ){
			$FailMessage = "[FAIL] デシジョンテーブルが特定できない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}


		if( $ReceiveMessageAnalysis.Warning -ne "" ){
			if( $this.CCONF_Debug ){ Write-Host $this.Log("[WARN] ワーニング判定  / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem") }
		}

		# デシジョンテーブル 返す
		return $ReceiveMessageAnalysis
	}



	##########################################################################
	# NewEnviromentOptin 送信バッファセット(protected)
	##########################################################################
	[void] SetSendBufferNewEnviromentOptin(){
		if( $this.CCONF_Debug ){
			$HandShakeMessage ="[Send] IAC SB NewEnviromentOptin NotTerminat IAC SE"
			Write-Host $this.Log($HandShakeMessage)
		}

		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC					# IAC
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_SB					# 命令
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_NewEnviromentOptin	# オプション
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_NotTerminat			# 継続
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC					# IAC
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_SE					# SE
	}

	##########################################################################
	# SetSendBufferTerminalType 送信バッファセット(protected)
	##########################################################################
	[void] SetSendBufferTerminalType(){
		if( $this.CCONF_Debug ){
			$HandShakeMessage ="[Send] IAC SB TerminalType NotTerminat ANSI IAC SE"
			Write-Host $this.Log($HandShakeMessage)
		}

		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC			# IAC
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_SB			# 命令
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_TerminalType	# オプション
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_NotTerminat	# 継続

		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = [byte] 0x41			# A
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = [byte] 0x4E			# N
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = [byte] 0x53			# S
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = [byte] 0x49			# I


		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC			# IAC
		$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_SE			# SE
	}


	##########################################################################
	# SB 命令処理(protected)
	##########################################################################
	[void] ReceiveSBOrder($binOrder, $binOption){
		## 受信バッファ解析 & ハンドシェーク リプライ作成
		# 命令
		$strOrder = $this.CC_TelnetControlDecode[$binOrder]
		$hexOrder = $this.Byte2Hex($binOrder)

		# オプション
		$strOption =  $this.CC_TelnetControlDecode[$binOption]
		$hexOption = $this.Byte2Hex($binOption)

		if( $this.CCONF_Debug ){
			# 命令受信を Log に出力
			$HandShakeMessage = "[Receive] IAC "
			$HandShakeMessage += $strOrder + " "
			$HandShakeMessage += $strOption
			$HandShakeMessage += " Termnater IAC SE"
			Write-Host $this.Log($HandShakeMessage)
		}



		# デシジョンテーブル抽出(SB)
		$SelectedDecisionTable = $this.SelectDecisionTable4SB($binOrder, $binOption)

		# 送信バッファセット
		switch ( $binOption ){
			$this.CC_NewEnviromentOptin {
				$this.SetSendBufferNewEnviromentOptin()
			}

			$this.CC_TerminalType {
				$this.SetSendBufferTerminalType()
			}
		}

		# 内部データーセット
		$this.SetInternalData( $SelectedDecisionTable, $strOrder, $binOption )

		$this.CV_ReceiveBufferIndex += 6
	}

	##########################################################################
	# 内部データーセット(protected)
	##########################################################################
	[void] SetInternalData( $SelectedDecisionTable, $binSendOrder,$binOption ){

		### ステータスセット
		# 対象システム
		$TergetSystem = $SelectedDecisionTable.Terget

		# 構文チェック回避のための dummy(?) 初期化
		[byte] $SetStatus = $this.CC_InitValue

		# セットするステータス
		if( $SelectedDecisionTable.SetStatus -eq "x" ){
			# 送信した命令をセットする
			$SetStatus = $binSendOrder
		}
		elseif($SelectedDecisionTable.SetStatus -ne ""){
			# 指定された値をセットする
			$SetStatus = $SelectedDecisionTable.SetStatus
		}

		# 対象システムを特定
		if( $TergetSystem -eq $this.CC_TergetClient ){
			# Client
			$this.CV_TelnetClientStatus[$binOption] = $SetStatus
		}
		else{
			#Server
			$this.CV_TelnetServerStatus[$binOption] = $SetStatus
		}
	}

	##########################################################################
	# 送信バッファセット
	##########################################################################
	[void] SetSendBuffer( $binSendOrder, $binOption ){
		# 送信バッファセット
		$strSendOrder = $this.CC_TelnetControlDecode[$binSendOrder]
		$hexSendOrder = $this.Byte2Hex($binSendOrder)

		# オプション
		$strOption =  $this.CC_TelnetControlDecode[$binOption]
		$hexOption = $this.Byte2Hex($binOption)

		# NOP 以外は送信バッファセットする(NOP は処理スキップ)
		if( $binSendOrder -ne $this.CC_Nop ){
			if( $this.CCONF_Debug ){
				$HandShakeMessage ="[Send] IAC "
				$HandShakeMessage += $strSendOrder + " "
				$HandShakeMessage += $strOption
				Write-Host $this.Log($HandShakeMessage)
			}

			$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $this.CC_IAC	# IAC
			$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binSendOrder	# 命令
			$this.CV_SendBuffer[$this.CV_SendBufferIndex++] = $binOption	# オプション
		}
		else{
			if( $this.CCONF_Debug ){
				$HandShakeMessage ="Skip by NOP"
				Write-Host $this.Log($HandShakeMessage)
			}
		}
	}

	##########################################################################
	# SB 以外のデシジョンテーブル抽出
	##########################################################################
	[PSCustomObject]SelectDecisionTable4NotSB($binOrder, $binOption){
		# 命令
		$strOrder = $this.CC_TelnetControlDecode[$binOrder]
		$hexOrder = $this.Byte2Hex($binOrder)

		# オプション
		$strOption =  $this.CC_TelnetControlDecode[$binOption]
		$hexOption = $this.Byte2Hex($binOption)

		if( $this.CCONF_DevDebug ){
			$HandShakeMessage = "[DEBUG] デシジョンテーブル抽出条件 / IAC : 命令 $strOrder : オプション $strOption"
			Write-Host $this.Log($HandShakeMessage)
		}

		# 命令でデシジョンテーブルを絞る
		[array]$ReceiveMessageAnalysis = $this.CCONF_DecisionTable |
											? ReceiveEscape -eq "Y" |		# IAC
											? ReceiveOrder -eq $binOrder	# 命令

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			# デシジョンテーブルが足りていない
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		# 1件ならエラー判定になっていないか確認
		elseif( $ReceiveMessageAnalysis.Count -eq 1 ){
			# エラー判定の可能性が高いので確認
			$ErrorFlag = $ReceiveMessageAnalysis[0].Error
			if( $ErrorFlag -ne "" ){
				$FailMessage = "[FAIL] エラー判定 / IAC 受信 : 命令 $strOrder : オプション $strOption : Error $ErrorFlag"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}

		### 直前送信を特定する
		# 対象システム確認
		$ContainsClinet =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetClient )	# Client が含まれているか
		$ContainsServer =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetServer )	# Server が含まれているか

		# 各対象システムに設定されている状態確認
		# Client
		$ClientStatus = $this.CV_TelnetClientStatus[$binOption]
		if( $ClientStatus -eq $this.CC_FinishValue){
			# 終了の場合は初期値と同じ扱い
			$ClientStatus = $this.CC_InitValue
		}

		# Server
		$ServerStatus = $this.CV_TelnetServerStatus[$binOption]
		if( $ServerStatus -eq $this.CC_FinishValue){
			# 終了の場合は初期値と同じ扱い
			$ServerStatus = $this.CC_InitValue
		}

		# 値がセットされているシステム確認
		# Client だけ
		if( ($ContainsClinet -eq $true) -and ( $ContainsServer -eq $false )){
			if( $ClientStatus -eq $null ){
				# 未知のオプションなので、状態と不使用を追加
				$this.CV_TelnetClientStatus.Add( $binOption, $binOrder )
				$ClientStatus = $binOrder
			}

			# システム状態と対象システム設定
			$SystemStatus = $ClientStatus
			$TergetSystem = $this.CC_TergetClient
		}
		# 対象が Server だけ
		elseif( ($ContainsClinet -eq $false) -and ( $ContainsServer -eq $true )){
			if( $ServerStatus -eq $null ){
				# 未知のオプションなので、状態と不使用を追加
				$this.CV_TelnetServerStatus.Add( $binOption, $binOrder )
				$ServerStatus = $binOrder

				# オプションを使用する/しない設定を Null
				# if( $this.CCONF_Debug -eq $true ){ Write-Host $this.Log("[WARN] オプション使用
				# $UseOptionServer = $this.CC_strNull
			}

			# システム状態と対象システム設定
			$SystemStatus = $ServerStatus
			$TergetSystem = $this.CC_TergetServer
		}
		# 対象が Client / Server の両方が含まれて特定出来ないとき
		else{
			$TergetSystem = $null
			# Server / Client のどちらに直前設定がセットされているか
			if($ClientStatus -ne $this.CC_InitValue){
				# Client がセットされている
				$SystemStatus = $ClientStatus
				$TergetSystem = $this.CC_TergetClient
			}
			elseif( $ServerStatus -ne $this.CC_InitValue ){
				# Server がセットされている
				$SystemStatus = $ServerStatus
				$TergetSystem = $this.CC_TergetServer
			}
			else{
				# どちらもセットされていない
				$SystemStatus = $this.CC_InitValue
			}
		}

		$strSystemStatus = $this.CC_TelnetControlDecode[$SystemStatus]

		# 直前送信 でデシジョンテーブルを絞る(IAC / 受信命令は絞り済み)
		[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
											? PreSend -eq $SystemStatus

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		# 1件ならエラー判定になっていないか確認
		elseif( $ReceiveMessageAnalysis.Count -eq 1 ){
			# エラー判定の可能性が高いので確認
			$ErrorFlag = $ReceiveMessageAnalysis[0].Error
			if( $ErrorFlag -ne "" ){
				$FailMessage = "[FAIL] エラー判定 / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}

		# デシジョンテーブル上の対象システム確認
		$ContainsClinet =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetClient )	# Client が含まれているか
		$ContainsServer =$ReceiveMessageAnalysis.Terget.Contains( $this.CC_TergetServer )	# Server が含まれているか

		# Client だけ
		if( ($ContainsClinet -eq $true) -and ( $ContainsServer -eq $false )){

			if( $TergetSystem -eq $this.CC_TergetServer ){
				# 事前送信の判定と違っている
				$FailMessage = "[FAIL] 事前送信とデシジョンテーブルの条件が合致していない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}
		# Server だけ
		elseif( ($ContainsClinet -eq $false) -and ( $ContainsServer -eq $true )){
			if( $TergetSystem -eq $this.CC_TergetClient ){
				# 事前送信の判定と違っている
				$FailMessage = "[FAIL] 事前送信とデシジョンテーブルの条件が合致していない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem"
				$this.Log($FailMessage)
				throw $FailMessage
				exit
			}
		}
		else{
			$TergetSystem = $ReceiveMessageAnalysis[0].Terget
		}

		# Server / Client でオプションを使用するか否かを確認
		if( $TergetSystem -eq $this.CC_TergetClient ){
			# Client
			$UseOption = $this.CCONF_TelnetClientConfig[$binOption]
		}
		else{
			# Server
			$UseOption = $this.CCONF_TelnetServerConfig[$binOption]
		}

		if( $UseOption -eq $null ){
			$UseOption = $this.CC_strNull
		}
		elseif( $UseOption -eq $true ){
			$UseOption = "Y"
		}
		else{
			$UseOption = "N"
		}

		# オプション使用 Y/N でデシジョンテーブルを絞る
		if( $TergetSystem -eq $this.CC_TergetClient ){
			# Client
			[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
												? UseOptionClient -eq $UseOption
		}
		elseif( $TergetSystem -eq $this.CC_TergetServer ){
			# Server
			[array]$ReceiveMessageAnalysis = $ReceiveMessageAnalysis |
												? UseOptionServer -eq $UseOption
		}

		# 0件ならデシジョンテーブル不足エラー
		if( $ReceiveMessageAnalysis.Count -eq 0 ){
			$FailMessage = "[FAIL] デシジョンテーブルが足りていない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem : オプション使用 $UseOption"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}
		elseif( $ReceiveMessageAnalysis.Count -ne 1 ){
			$FailMessage = "[FAIL] デシジョンテーブルが特定できない / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem : オプション使用 $UseOption"
			$this.Log($FailMessage)
			throw $FailMessage
			exit
		}

		if( $ReceiveMessageAnalysis.Warning -ne "" ){
			if( $this.CCONF_Debug ){ Write-Host $this.Log("[WARN] ワーニング判定  / IAC 受信 : 命令 $strOrder : オプション $strOption : 直前送信 $strSystemStatus : 対象システム $TergetSystem : オプション使用 $UseOption") }
		}

		# デシジョンテーブル 返す
		return $ReceiveMessageAnalysis
	}


	##########################################################################
	# SB 以外命令処理(protected)
	##########################################################################
	[void] ReceiveNotSBOrder($binOrder, $binOption){
		## 受信バッファ解析 & ハンドシェーク リプライ作成
		# 命令
		$strOrder = $this.CC_TelnetControlDecode[$binOrder]
		$hexOrder = $this.Byte2Hex($binOrder)

		# オプション
		$strOption =  $this.CC_TelnetControlDecode[$binOption]
		$hexOption = $this.Byte2Hex($binOption)

		if( $this.CCONF_Debug ){
			# 命令受信を Log に出力
			$HandShakeMessage = "[Receive] IAC "
			$HandShakeMessage += $strOrder + " "
			$HandShakeMessage += $strOption
			Write-Host $this.Log($HandShakeMessage)
		}

		# デシジョンテーブル抽出(Not SB)
		$SelectedDecisionTable = $this.SelectDecisionTable4NotSB($binOrder, $binOption)

		# 送信バッファセット
		$binSendOrder = $SelectedDecisionTable.SendOrder
		$this.SetSendBuffer( $binSendOrder, $binOption )

		# 内部データーセット
		$this.SetInternalData( $SelectedDecisionTable, $binSendOrder,$binOption )

		$this.CV_ReceiveBufferIndex += 3
	}


	##########################################################################
	# IAC 受信(protected)
	##########################################################################
	[void] ReceiveIAC (){
		# IAC 受信

		## 受信バッファ解析 & ハンドシェーク リプライ作成
		# 命令
		$binOrder = $this.CV_ReceiveBuffer[$this.CV_ReceiveBufferIndex + 1]

		# オプション
		$binOption = $this.CV_ReceiveBuffer[$this.CV_ReceiveBufferIndex + 2]


		### SB 命令受信は特別処理
		if( $binOrder -eq $this.CC_SB ){
			# SB 命令処理
			$this.ReceiveSBOrder($binOrder, $binOption)
		}
		else{
			# SB 以外命令処理
			$this.ReceiveNotSBOrder($binOrder, $binOption)
		}
	}


### ここ以降が本来の public #####################################################

	##########################################################################
	# 接続(public)
	##########################################################################
	[void] Connect([string]$RemoteHost, [int]$Port ){

		# ログパス
		if( $this.CCONF_LogPath -eq "" ){
			$Now = Get-Date
			$YYYYMMDD = $Now.ToString("yyyy-MMdd")
			$this.CCONF_LogPath = Join-Path $PSScriptRoot "telnet_$YYYYMMDD.log"
		}

		# デシジョンテーブルセット
		$this.SetDecisionTable()

		# 受信バッファ
		$this.CV_ReceiveBuffer = New-Object byte[] $this.CCONF_BufferSize

		# 送信バッファ
		$this.CV_SendBuffer = New-Object byte[] $this.CCONF_BufferSize

		# Text バッファ
		# $this.CV_TextBuffer = New-Object byte[] $this.CCONF_BufferSize

		# tcp 接続
		Add-Type -AssemblyName System.Net

		$this.CV_Socket = New-Object System.Net.Sockets.TcpClient($RemoteHost, $Port)
		$this.CV_Stream = $this.CV_Socket.GetStream()
		$this.CV_Writer = New-Object System.IO.StreamWriter($this.CV_Stream)

	}



	##########################################################################
	# 受信(public)
	##########################################################################
	[string[]] Receive ( [string]$Prompt ){


		# Text バッファ
		$TextBuffer = New-Object byte[] $this.CCONF_BufferSize

		# テキスト メッセージ
		[string]$TextMeaage = ""

		# エンコード
		$Encoding = New-Object System.Text.AsciiEncoding

		# 初期タイムアウト設定
		$Now = Get-Date
		$TimeOver = $Now.AddSeconds($this.CCONF_TimeOut)

		sleep 1

		while( (Get-Date) -le $TimeOver ){

			# 送信バッファクリア
			$this.CV_SendBufferIndex = 0

			if( $this.CV_Stream.DataAvailable ){
				# 受信バッファ読み取り
				$Read = $this.CV_Stream.Read($this.CV_ReceiveBuffer, 0, $this.CCONF_BufferSize)

				# 受信したのでタイムアウト リセット
				$Now = Get-Date
				$TimeOver = $Now.AddSeconds($this.CCONF_TimeOut)

				# 受信バッファ解析
				for($this.CV_ReceiveBufferIndex = 0; $this.CV_ReceiveBufferIndex -lt $Read; ){
					if( $this.CV_ReceiveBuffer[$this.CV_ReceiveBufferIndex] -eq $this.CC_IAC ){
						# IAC 受信処理
						$this.ReceiveIAC()

					}
					else{
						# テキスト受信
						for( $i = 0; $this.CV_ReceiveBufferIndex -lt $Read; $i++ ){
							$TextBuffer[$i] = $this.CV_ReceiveBuffer[$this.CV_ReceiveBufferIndex++]
						}
						$RaceveTempText = ($Encoding.GetString( $TextBuffer, 0, $i ))
						$TextMeaage += $RaceveTempText
					}
				}

				# 未処理オプション リクエスト
				$this.RequestNotSetOption()

				# 受信テキストがプロンプトだったら抜ける
				[string]$TmpBuffer = $TextMeaage -replace "`r",""
				[array]$Lines = $TmpBuffer -split "`n"
				if( $Lines.Count -ne 0 ){
					$LastLine = $Lines[$Lines.Count -1]
					if( $LastLine -Match $Prompt ){
						if( $this.CCONF_Debug ){ Write-Host $this.Log( "[DEBUG] 受信テキストがプロンプトに一致した : `"$Prompt`" / `"$LastLine`""  ) }
						break
					}
					else{
						if( $this.CCONF_Debug ){ Write-Host $this.Log( "[DEBUG] 受信テキストがプロンプトに一致しない : `"$Prompt`" / `"$LastLine`"" ) }
					}
				}
				else{
					if( $this.CCONF_Debug ){ Write-Host $this.Log( "[DEBUG] 受信テキストサイズ Zero" ) }
				}
			}

			# ハンドシェークリプライ送信
			if( $this.CV_SendBufferIndex -ne 0 ){
				$this.CV_Stream.Write($this.CV_SendBuffer, 0, $this.CV_SendBufferIndex)
				if( $this.CCONF_Debug ){ Write-Host $this.Log("[DEBUG] ---- Send Message ----") }
			}
			else{
				if( $this.CCONF_Debug ){ Write-Host $this.Log("[DEBUG] ---- Receive wait ----") }
			}

			# 送信後少し待つ
			sleep 1
		}

		# テキスト受信していたらログに書く
		[string[]] $Lines
		if( $TextMeaage.Length -ne 0 ){
			$TmpBuffer = $TextMeaage -replace "`r",""
			$Lines = $TmpBuffer -split "`n"
			foreach( $Line in $Lines ){
				Write-Host $this.Log("[Receive] $Line")
			}
			#Write-Host $this.Log("[Receive] $TextMeaage")
		}

		return $Lines
		#return $TextMeaage
	}


	##########################################################################
	# 送信(public)
	##########################################################################
	[void]Send( [string]$Message, [bool]$Display ){
		if( $Display -eq $true ){
			Write-Host $this.Log("[SEND] $Message")
		}
		else{
			Write-Host $this.Log("[SEND] ********")
		}


		$this.CV_Writer.WriteLine($Message)
		$this.CV_Writer.Flush()
	}

	##########################################################################
	# 切断(public)
	##########################################################################
	[void]DisConnect(){
		$this.CV_Stream.Close()
		$this.CV_Writer.Close()
		$this.CV_Socket.Close()

		$this.CV_Stream.Dispose()
		$this.CV_Writer.Dispose()
		$this.CV_Socket.Dispose()
	}

	##########################################################################
	# 環境設定変更(public)
	##########################################################################
	[void]SetEnvironment( [string]$LogPath, [bool]$NotRecordLog, [int] $TimeOut, [bool]$Debug, [bool]$DevDebug ){

		# ログパス
		if( $LogPath -ne [string]$null ){
			$this.CCONF_LogPath = $LogPath
		}

		$this.CCONF_NotRecordLog = $NotRecordLog

		# タイムアウト
		if( $TimeOut -ne [int]$null ){
			$this.CCONF_TimeOut = $TimeOut
		}

		# Debug
		$this.CCONF_Debug = $Debug

		# DevDebug
		$this.CCONF_DevDebug = $DevDebug
	}

	##########################################################################
	# ログ出力(public)
	##########################################################################
	[string] Log( [string]$LogString ){

		$Now = Get-Date

		$Log = $Now.ToString("yyyy/MM/dd HH:mm:ss.fff") + " "
		$Log += $LogString

		# ログフォルダーがなかったら作成
		$LogPath = Split-Path -Parent $this.CCONF_LogPath
		if( -not (Test-Path $LogPath) ) {
			New-Item $LogPath -Type Directory
		}

		if( -not $this.CCONF_NotRecordLog ){
			Write-Output $Log | Out-File -FilePath $this.CCONF_LogPath -Encoding utf8 -append
		}

		Return $Log
	}
}
