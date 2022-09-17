// translated by Henrik Haftmann

// DIALOG(EX)
#define S10000	"エミュレーション"
#define S10001	"エミュレートしたポート･アドレス (&A)："
#define S10002	"LPTの強化モード (&E)："
#define S10003	"INとOUT命令のトラップする方法"
#define S10004	"デバッグ･レジスターのトラップ (&D)"
#define S10005	"(すべてのINとOUT命令の種類のトラッピング)"
#define S10006	"以前に割り当てれば、割り当てを強行する (&F)"
#define S10007	"&READ/WRITE_PORT_UCHAR/USHORT/ULONGリダイレクト"
#define S10008	"(より速い、より安定)"
#define S10009	"パフォーマンス･オプション"
#define S10010	"OUT命令についてライトバックを使用する (&W)"
#define S10011	"(複数のOUT命令を1つのUSBパケットに連結する)"
#define S10012	"このタイムアウトの後、パケットを送信する (&T)："
#define S10014	"OUTポートのローカルの副本をリードバックする (&B)"
#define S10015	"より正確に... (&M)"
#define S10016	"(最後のOUT命令のバイトをIN命令の場合で直接に復帰する。ライン出力が外部デバイスから低レベルに引かれば、その方法は動作しません。)"

#define S10100	"統計"
#define S10101	"デバッグ･レジスターのトラップ"
#define S10102	"ゼロにリセット (&R)"
#define S10103	"OUT命令："
#define S10104	"IN命令："
#define S10105	"エミュレーション･エラー："
#define S10106	"(非対応の命令、例えばOUTSB)"
#define S10107	"盗まれたデバッグ･レジスター："
#define S10108	"(不明なドライバはデバッグ･レジスターに書いた)"
#define S10109	"上書きしたデバッグ･レジスターは100ミリ秒タイマーから検出されています。"
#define S10110	"実際に割り当てられた："
#define S10114	"READ_PORT_UCHAR/WRITE_PORT_UCHARリダイレクト"
#define S10115	"ゼロにリセット (&Z)"
#define S10116	"特大："
#define S10117	"USB2LPT特別... (&E)"
#define S10118	"ファームウェア･アップデート... (&U)"
#define S10119	"haftmann#software、ケムニッツ工科大学、電子工学と情報技術学部、検出技術講座、2006-2009年"

#define S10200	"リードバック出力レジスターのコピー"
#define S10201	"データ･ポート〖ベース･アドレス+0〗 (&D)"
#define S10202	"制御ポート〖ベース･アドレス+2〗 (&C)"
#define S10203	"他のポート〖ECPとEPP〗 (&O)"
#define S10204	"ＯＫ"
#define S10205	"キャンセル"

#define S10302	"間違った設定をお使いのコンピュータがクラッシュしたり、ハードディスクの内容を食べたりの！三つの定義済みのアドレスの使用は安全です。"
#define S10304	"LPTの強化モードの場合で、追加なアドレスをトラッピングを追加する。\nそれらの設定は非常にめったにので、SPPのはいい。"
#define S10305	"これら後で、Windowsのデバイス･マネージャでより詳細な設定をすることができる。USB2LPTデバイスを見つけて、プロパティを開く。"

#define S10400	"USB2LPT特別"
#define S10401	"素性レジスター"
#define S10402	"(素性レジスターはUSB2LPTの中のEEPROMに永続的に保持される。アクセスはDeviceIoControlを経由だ。)"
#define S10403	"データ･ポート(+0)のためのオープン･コレクタ (&D)"
#define S10404	"コントロール･ポート(+2)のためのオープン･コレクタ (&C)"
#define S10405	"プル･アップを無効にする、またピン25の5V有線で場合は遮断する。(&P)"
#define S10406	"直接&I/Oモード（USB2LPTはI/Oデバイスに変換する。）"
#define S10407	"(強力な3.3Vの代わりに弱い5Vの高レベルの出力)"
#define S10408	"(グレーのチェックマークの意味：SPPモードでオープン･コレクタ、それ以外でプッシュ･プル)"
#define S10409	"(省エネだけ)"
#define S10410	"(反転信号はでない。だから、LPTエミュレーションは正しくないし、DeviceIoControlの使用をアクセスに推奨される。新しいUSB2LPTは17の代わりに20のI/Oラインを持っている。方向の選択は一つビット当たりのピン。)"
#define S10411	"設定とリードバック (&S)"
#define S10412	"ショート回路をスキャンする (&T)"
#define S10413	"シリアル番号"
#define S10414	"ファームウェアの日付"

#define S10500	"観察"
#define S10501	"データ･ポート(+0) (&P)"
#define S10502	"読む"
#define S10503	"ステータス･ポート(+1) (&S)"
#define S10504	"コントロール･ポート(+2) (&C)"
#define S10506	"バイトを読む (&R)"
#define S10507	"アドレス (&A)"
#define S10508	"データ (&D)"
#define S10509	"バイトを書き込む (&W)"
#define S10512	"FIFOはフル"
#define S10513	"FIFOは空"
#define S10514	"方向レジスター（USB2LPT特定）"

// STRINGTABLE 
#define S16 "本当に、この非標準のポートアドレスを使用したいですか？\n\nお使いはコンピュータがクラッシュすることがあります！"
#define S17 "このアドレスは有効な１６進数ではありません！"
#define S18 "このアドレスは間違っている：過小、過大、または４で整除できない！"
#define S19 "アドレスは８で整除できないし、EPPエミュレーションは不可能だ。"
#define S20 "タイムアウト値は不正だ！（以上の1000ミリ秒でない。）"
#define S21 "エミュレーションのポート･アドレスの割り当て"
#define S22 "このポート･アドレスはアプリケーション･ソフトウェアで使用するアドレスと一致する必要があります。"
#define S23 "このファームウェアはUSB2LPTの特定の機能のレジスターをサポートしていません。"
#define S24 "何もない"	// serial number
#define S25 "コンテキスト･ヘルプ (&H)"

#define S32 "このファームウェアはEEPROMに正常に書かれています。\n新しいファームウェアを起動するのために、デバイスに電源サイクル！"
#define S33 "ファームウェアをEEPROMに書き込み中、不明なエラーが発生しました。デバイスの接続を解除するものではなく、もう一度試してください。USB2LPTデバイスは動作していない可能性があります。"
#define S34 "ファイル「%s」はUSB2LPTデバイスのファームウェアとして受け入れされていません！"
#define S35 "実行中の実際のファームウェアの日付：%s\n\n書き込まれるようにファームウェアの日付：%s\n\n続行しますか？"
#define S36 "不明"		// firmware date (early releases have no date inside)
#define S37 "ファームウェア\0*.iic"	// filter for open file standard dialog
#define S38 "完璧に機能します。"
#define S39 "不正な機能を検出した！Kurzschlusstest.EXEを起動すれば、もっと詳細を受け取る。"
#define S40 "すべての17行に高濃度を測定するか？"
#define S41 "低ATmegaコントローラ用のファームウェアを更新することはできませんが、ここUSB2LPTデバイスのスピードが、活性化のためのフラグを設定するためのブートローダーを内蔵。パワーサイクルの後、bootloadHID.EXEを使用して更新する必要があります。\n\n続行しますか？"

#define S48 "SPP（ニブル）\0双方向\0自動ストローブ\0ECP\0EPP\0予約\0テストモード\0設定"
#define S49 "追加\0予約\0割り込み要求\0エラー\0オンライン\0講演終了\0認める\0忙しい"
#define S50 "ストローブ\0自動給紙方式\0リセット\0選択入力\0割り込み有効\0データの方向、1=入力\0実装されていない"
#define S51 "コマンド (&O)\0アドレス (&A)"	// Changing text for radio button 105/122
#define S52 "正常\0ニブルモード\0バイトモード\0ECPのモード\0EPPのモード"

// VERSIONINFO
#define I002	17,1
#define S003	"プロパティ･シート･プロバイダ"	// FileDescription
#define S004	"%d.%02d (%d年%d月);1;2;3;4/"		// FileVersion (awk-processed)
#define S005	"パブリック･ドメイン"		// LegalCopyright
#define S006	"h#s･USBからLPTまでのコンバータ"	// ProductName
#define S007	"カーネルモードドライバ"	// FileDescription for .SYS driver

/* INF file strings (processed by makefile)
InstDisk="h#s･USBからLPTまでのコンバータのドライバディスク"
DevDesc ="h#s･USBからLPTまでのコンバータ"
SvcDesc ="h#s･USBからLPTまでのコンバータのドライバ(usb2lpt.sys)"
*/
