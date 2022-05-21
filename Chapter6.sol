// web3.js .. Ethereum FoundationのJavaScriptライブラリ

・コントラクトの呼び出し
イーサリアムのネットワークは、ブロックチェーンのコピーをそれぞれ持ったノードで構成されていることを思い出すのだ。
スマートコントラクトの関数を呼び出したい時、これらノードのどれか一つをクエリする必要がある:

スマートコントラクトのアドレス
呼び出したい関数。そして、
その関数に渡したい変数


イーサリアムのノードは、人間が読むことができない JSON-RPC という言語でのみ会話する。
コントラクトの関数を呼び出したいとノードに伝えるクエリはこんな感じのものだ:

// うむ...関数呼び出しは全てこうやって書くのだ、頑張れ!
{"jsonrpc":"2.0","method":"eth_sendTransaction","params":
[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":
"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0",
"gasPrice":"0x9184e72a000","value":"0x9184e72a","data":
"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}



幸運にもWeb3.jsはサーフェイスの下にこの面倒なクエリを隠してくれるから、
便利で読みやすいJavaScriptインターフェイスとやり取りするだけで良い。

上のクエリを構成する代わりに、コード中で関数を呼び出すのはこんな感じになる:

cryptoZombies.methods.createRandomZombie("Vitalik Nakamoto 🤔")
  .send({ from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "3000000" })
  
  
・install
// NPMを使用
npm install web3

// Yarnを使用
yarn add web3

// Bowerを使用
bower install web3


・web3プロバイダ .. どのノード に読み書きを処理させるよう働き掛けるかをコードに教えてくれる。(APIの様なもの)

よし! Web3.jsがプロジェクトで使えるようになったから、今度はこれを初期化してブロックチェーンにアクセスできるようにしていこう。

まず必要なのは、 Web3プロバイダ というものだ。

イーサリアムは ノード で構成されていて、全ノードが同じデータのコピーをシェアしていることを覚えているだろうか。
Web3.jsにおけるWeb3プロバイダの設定は、 どのノード に読み書きを処理させるよう働き掛けるかをコードに教えてくれる。
これは従来のウェブアプリでAPIコールをするためにリモートのウェブサーバーのURLを設定するようなものだ。

自分のイーサリアム・ノードをプロバイダとして運営することも可能だが、
もっと手軽なサードパーティのサービスがあるから、DAppのユーザーのために自分のイーサリアム・ノードをもつ必要はない。
そのサービスとは Infura だ。


・infura
Infura とは、高速な読み込みのためのキャッシュレイヤーをもつイーサリアム・ノードのセットを保持するサービスで、
API経由でこれらノードに無料でアクセスで可能だ。 
Infuraをプロバイダとして使用することで、自分のノードをセットアップして維持しなくても、イーサリアムブロックチェーンとメッセージをしっかりと送受信できる。


