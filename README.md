ブラウザで動くKali Linuxデスクトップ
このリポジトリには、NoVNCを通じてウェブブラウザからアクセス可能なKali Linuxデスクトップを実行するDocker Composeアプリケーションが含まれています。

スクリーンショット

説明
このDocker Composeアプリケーションは以下を提供します：

Kali Linux: NoVNCで動作するKali Linuxデスクトップ環境のウェブサーバー
デフォルトパスワード: kalilinux
デフォルト公開ポート: 8080
必要条件
このアプリケーションを実行するには、以下が必要です：

Docker Engine
Docker Compose
使い方
クイックスタート
リポジトリをクローンします:

bash
git clone https://github.com/csalab-id/kalilinux-docker.git
リポジトリのディレクトリに移動します:

bash
cd kalilinux-docker
必要なDockerイメージをプルします:

bash
docker compose pull
環境用にカスタムパスワードを設定します（任意）:

bash
export PASSWORD="YourVNCPassword"
コンテナをデタッチモードで起動します:

bash
docker compose up -d
ウェブアプリケーションにアクセスします: http://localhost:8080/vnc.html

環境変数
次の環境変数でアプリケーションをカスタマイズできます：

変数名	説明	デフォルト
PASSWORD	VNCのパスワード	kalilinux
BIND	サーバーのバインドアドレスとポート（形式: IP:PORT）	0.0.0.0:8080
使用例:

bash
export PASSWORD="mysecretpassword"
export BIND="0.0.0.0:9090"
docker compose up -d
ライセンス
このDocker ComposeアプリケーションはMITライセンスのもとで公開されています。詳細はLICENSEファイルをご覧ください。

免責事項
ハッキング目的で開発・配布される本ソフトウェアは、教育およびテスト目的のみでの利用を意図しています。本ソフトウェアを違法な活動に使用することは固く禁止されています。開発者および配布者は、本ソフトウェアの誤用によるいかなる損害や法的責任についても責任を負いません。
