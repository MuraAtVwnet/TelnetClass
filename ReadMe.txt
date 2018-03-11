telnet client class

◆ これは何?
PowerSehll (v5 以降) で使用できる telnet client class です。
ネットワーク機器等 telnet を使用して設定する機器を自動設定するのに使えます。

◆ 何が出来るの?
・機器に対する telnet 接続
・コマンド送信(login / logoff 含む)
・コマンド送信結果受信
・切断

◆ 出来ない事
・機器の自動設定 ww
telnet client 機能しか実装していないので、自動設定に必要な処理は自分で書く必要があります。
この class を継承して機器用のカスタムクラスを作るのもよし、この telnet client class をそのまま使ってスクリプトを書くもよし

◆ クラス メンバー説明
・コンストラクタ
	TelnetClient()
	TelnetClient(string, int)
		指定ノードへ接続する
			string : 接続先 IP またはホスト名
			int: ポート番号

・public メソッド
	# 接続
	[void] Connect(string, int)
		指定ノードへ接続する
			string : 接続先 IP またはホスト名
			int: ポート番号

	# 切断
	[void] DisConnect()
		接続中ノードから切断する
		(logoff 等の処理ではなく TCP レベル切断)

	# 送信
	[void] Send(string, bool)
		コマンドを送信する
			string : 送信するコマンド
			bool : 送信コマンドをログ記録出力するか否か
				$true : 出力する
				$false : 出力しない(**** がログに記録される)

	# 受信
	[string[]] Receive(string)
		受信する(telnet ネゴシエーションもこの中で実現されている)
		受信内容はログに記録されます
			string : 待ち受けするプロンプト
			このプロンプトが受信されるまで受信を待ち続ける(タイムアウト:30秒)

	# 環境設定変更
	[void] SetEnvironment(string, bool, int, bool, bool)
		動作環境を変更する
			string : ログファイルのフルパス($null をセットすると default が使用される)
				default : スクリプトパス telnet_YYYY-MMDD.log
			bool : ログ保存抑制
					$false : ログ保存する
					$true : ログ保存しない(表示はする)
					default : $false
			int : タイムアウト(秒)
				default : 30
			bool : ネゴシエーション/プロンプト待ち状態をログに出力するか否か
				$true : ログに出力する
				$false : ログに出力しない
				default : $false
			bool : 開発用 debug をログに出力するか否か
				$true : ログに出力する
				$false : ログに出力しない
				default : $false

	# ログ出力
	[string] Log(string)
		ログ出力する
			string : ログ出力メッセージ

・public プロパティ
	なし

◆ 使い方
	TelnetClient クラスをそのまま使うか、継承したカスタムクラスを作って下さい
	動かす時には、TelnetClient.ps1 と DecisionTable.csv を同一フォルダに置いてください

◆ files
	TelnetClient.ps1
		Telnet Client class 本体

	DecisionTable.csv
		動作制御用デシジョンテーブル データ

	ReadMe.txt
		このファイル

	sample1.ps1
		Telnet Client class を裸で使う場合の実装サンプル

	sample2.ps1
		Telnet Client class を継承する場合の実装サンプル

	sample2Class.ps1
		Telnet Client class 継承サンプル(sample2.ps1 で使っている)

	デシジョンテーブル.xlsx
		人が見る用の動作制御用デシジョンテーブル

	メソッド構造.txt
		内部で呼んでいるメソッドのツリー構造

	memo.txt
		telnet ネゴシエーション 動作メモ

