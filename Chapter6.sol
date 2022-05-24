web3.js .. Ethereum FoundationのJavaScriptライブラリ

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


・web3プロバイダ(infura) .. どのノード に読み書きを処理させるよう働き掛けるかをコードに教えてくれる。(APIの様なもの)→URLの設定みたいなやつ。

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
Ex.
var web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));


・秘密鍵管理(Metamask)
だが我々のDAppは今後多くのユーザーが使用し、彼らはブロックチェーンの読み取りだけでなく書き込みも行っていく
- だからユーザーが秘密鍵でトランザクションに署名する方法が必要となるのだ。


注：イーサリアム（そして一般的なブロックチェーン）は、
トランザクションにデジタル署名をするために公開鍵/秘密鍵のペアを使用します。
これはデジタル署名向けの非常に安全なパスワードであると考えてください。
このようにして、もしあなたがブロックチェーンのデータを変更すると、
あなたは自分の公開鍵を通じてそれを署名した人であると証明することができます。
しかし誰もあなたの秘密鍵は知らないので、あなたに代わってトランザクションを偽造することはできません。

暗号化の方法は複雑だから、お主がセキュリティの専門家で何を行っているかを本当にわかっているわけでもない限り、
アプリのフロントエンドでユーザーの秘密鍵を自ら管理しようとするのは良い考えではない。

だがラッキーなことに秘密鍵管理の必要はない
— すでにこれを行ってくれるサービスがあるのだ。中でももっともポピュラーなサービスは Metamask だ。


・Metamask
MetamaskはChromeとFirefoxのブラウザ拡張機能で、
ユーザーは自分のイーサリアム・アカウントと秘密鍵を安全に管理し、
そのアカウントでWeb3.jsを使用しているウェブサイトとやりとりすることが可能だ
（もし以前使ったことがなければ、絶対にインストールしたいはずだ 
- 自分のブラウザがWeb3に対応して、イーサリアムのブロックチェーンと通信するウェブサイトと対話できるようになるのだ！)。

そして（我々がCryptoZombiesゲームでやっているように）
ユーザーにブラウザのウェブサイトを通してDAppとやりとりさせたい場合、
開発者としてMetamaskと互換性のあるものにしたいと絶対思うだろう。

注: Metamaskは、先ほどやったようにInfuraのサーバーをWeb3プロバイダーとして使用しますが
、Web3プロバイダーを選択するオプションも提供しています。
MetamaskのWeb3プロバイダを使用することでユーザーに選択肢を与えるので、アプリでの懸念事項が少なくなります。


・web3プロバイダの使用（Metamask）
Metamaskは、web3プロバイダをJavaScriptのグローバルオブジェクト web3のブラウザにインジェクトする。
なので web3が存在するか、そしてプロバイダとしてweb3.currentProviderを使用しているかをアプリがチェックすることができる。

ここにあるMetamaskが提供するテンプレートコードは、ユーザーがMetamaskをインストール済みかを検出し、
インストールしていなければアプリを使用するためにMetamaskのインストールが必要だと伝えるものだ:

window.addEventListener('load', function() {

  // Web3がブラウザにインジェクトされているかチェック (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Mist/MetaMaskのプロバイダの使用
    web3js = new Web3(web3.currentProvider);
  } else {
    // ユーザーがweb3を持たない場合の対処。
    // アプリを使用するためにMetamaskをインストールするよう
    // 伝えるメッセージを表示。
  }

  // アプリのスタート＆Web3.jsへの自由なアクセスが可能に:
  startApp()

})


・コントラクタへのアクセス
Web3.jsをMetamaskのWeb3プロバイダで初期化できたから、今度はスマートコントラクトにアクセスできるように設定しよう。

Web3.jsがコントラクトにアクセスするため、必要となるものが２つある: コントラクトの アドレス と ABI だ。


・コントラクタアドレス
スマートコントラクトを書き終えたあと、それをコンパイルしてイーサリアムにデプロイする。 
次のレッスン で デプロイ を扱うが、これはコードを書くこととはあまりに違ったプロセスだ。
だから順番を変えてまずはWeb3.jsをやっていくことにした。

コントラクトをデプロイすると、永久に有効なイーサリアム上の固定アドレスが与えられる
。レッスン２を振り返ると、イーサリアム・メインネット上のCryptoKittiesコントラクトアドレスは0x06012c8cf97BEaD5deAe237070F9587f8E7A266dである。

デプロイ後スマートコントラクトにアクセスするために、このアドレスをコピーしておくことが必要だ。


・コントラクタABI .. (Application Binary Interface)  web3.jsがコントラクタにアクセスするためにさらに必要なもの。
基本的にこれはコントラクトのメソッドをJSON形式で表していて、関数コールをコントラクトが理解できるようフォーマットする方法を、Web3.jsに教えてくれるものだ。
関数呼び出し方法をweb3.jsに教える？？


イーサリアムにデプロイするためにコントラクトをコンパイルする際（レッスン7でこれは説明しよう）、
SolidityコンパイラはABIを提供してくれるので、コントラクトアドレスに加えてこれをコピーして保存しておかなくてはならない。


これでweb3.jsを使ってコントラクトにアクセス可能になった！
web3.jsでコントラクトの関数を呼び出すための２つのメソッドがある。（call, send）


// Call (データの取得？get?)
callはview関数およびpure関数に使われる。
これはローカルのノードでのみ機能し、ブロックチェーン上のトランザクションを生成しない。

復習: viewおよびpure関数は、読み取り専用のものでブロックチェーン上のステートを変更しません。
またガスを必要とせず、ユーザーがMetamaskを使ってトランザクションに署名することも要求されません。

Web3.jsを使って、次のように123をパラメーターにしてmyMethodという名の関数をcallできる:

myContract.methods.myMethod(123).call()


// Send (スマートコントラクト上のデータを変更)
sendはトランザクションを生成し、ブロックチェーン上のデータを変更する。
viewまたはpureではない関数には、sendを使う必要がある。

注: トランザクションをsendすることはユーザーにガスの支払いを要求し、
また彼らがトランザクションに署名するようMetamaskをポップアップします。
Web3プロバイダとしてMetamaskを使用する場合、send()関数を呼び出すとこれを全部行ってくれるので
、コード内で特別なことを行う必要はありません。

Web3.jsを使って、次のように123をパラメーターにして、myMethodという名の関数を呼び出すトランザクションをsendすることができる:

myContract.methods.myMethod(123).send()


Ex. Callメソッド
function getZombieDetails(id) {
  return cryptoZombies.methods.zombies(id).call();
}

// 関数を呼び出し、その結果を処理する:
getZombieDetails(15)
.then(function(result) {
  console.log("Zombie 15: " + JSON.stringify(result));
});

ここで何が起こっているのか、一緒に見ていこう。

cryptoZombies.methods.zombies(id).call() はWeb3プロバイダのノードと通信して、コントラクトにあるZombie[] public zombiesからゾンビとそのインデックスidを返す。

これは外部サーバーへのAPIコールのように非同期であることに注意するのだ。
だからWeb3はここでpromiseを返すことになる。

このPromiseがリゾルブすると(Web3プロバイダからの応答を受けとったという意味だ)、
この見本コードはthenステートメントで続行され、resultをコンソールにログする。

result は次のようなJavaScriptオブジェクトとなる:

{
  "name": "H4XF13LD MORRIS'S COOLER OLDER BROTHER",
  "dna": "1337133713371337",
  "level": "9999",
  "readyTime": "1522498671",
  "winCount": "999999999",
  "lossCount": "0" // Obviously.
}
このオブジェクトを解析してフロントエンドロジックを用意すると、意味がわかるようにフロントエンドに表示することができる。


・データの表示（JQuery）
// コントラクトからゾンビ詳細を探し、`zombie`オブジェクトを返す。
getZombieDetails(id)
.then(function(zombie) {
  // ES6の「テンプレート文字列」を使い、HTMLに変数をインジェクト。
  // それぞれを #zombies div に追加
  $("#zombies").append(`<div class="zombie">
    <ul>
      <li>Name: ${zombie.name}</li>
      <li>DNA: ${zombie.dna}</li>
      <li>Level: ${zombie.level}</li>
      <li>Wins: ${zombie.winCount}</li>
      <li>Losses: ${zombie.lossCount}</li>
      <li>Ready Time: ${zombie.readyTime}</li>
    </ul>
  </div>`);
  
  ・画像として表示
  // ゾンビの頭を表す1-7の整数を取得:
var head = parseInt(zombie.dna.substring(0, 2)) % 7 + 1

// 連続した数字のファイル名を持つ７つの頭の画像がある:
var headSrc = "../assets/zombieparts/head-" + head + ".png"



・トランザクションの送信（Send）
スマートコントラクト上のデータを変更するためのsendの使用。

call関数とはいくつか大きな違いがある:

トランザクションをsendするのには関数を呼び出す者のfromアドレスが必要
(Solidityのコードではmsg.senderとなる)。
これがDAppのユーザーであるようにしたいから、彼らにトランザクションへの署名を要求するようMetamaskがポップアップする。

トランザクションをsendするにはガスがかかる

ユーザーがトランザクションをsendしてから、それが実際にブロックチェーン上で有効になるまでにはかなりの遅れがある。 
この原因は、トランザクションがブロックに含まれるのを待つ必要があり、
またイーサリアムのブロック生成時間が平均15秒であるからだ。
イーサリアム上にたくさん保留中トランザクションがある場合や、
ユーザーがあまりに低いガスプライスを送信した場合は、
トランザクションが取り込まれるまで数ブロック待たなければならず、数分かかることもある。

このため、コードの非同期性を処理するためのロジックがアプリケーションで必要となる。

Ex.
function createRandomZombie(name) {
  // しばらく時間がかかるので、UIを更新してユーザーに
  // トランザクションが送信されたことを知らせる
  $("#txStatus").text("Creating new zombie on the blockchain. This may take a while...");
  // トランザクションをコントラクトに送信する:
  return cryptoZombies.methods.createRandomZombie(name)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Successfully created " + name + "!");
    // トランザクションがブロックチェーンに取り込まれた。UIをアップデートしよう
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    // トランザクションが失敗したことをユーザーに通知するために何かを行う
    $("#txStatus").text(error);
  });
}


receiptは、トランザクションがEthereumのブロックに含まれると発行される。
これは我々のゾンビが作成され、コントラクトに保存されたことを意味する。
errorは十分な量のガスを送っていないといったように、ブロックへのトランザクションの取り込みを妨げる問題があるときに発生する。 
我々は、UIでトランザクションがうまくいかなかったことをユーザーに通知し、トランザクションをやり直せるようにしたい。

注: sendを呼び出す場合、オプションでgasとgasPriceを指定することができます。
(例 .send({ from: userAccount, gas: 3000000 }))
これを指定しなければ、Metamaskがこれらの数値をユーザーに選ばせます。



・Wei .. いくら送信するかを指定。
関数と併せてEtherを送信するのはシンプルだが、一つ注意が必要だ。
いくら送信するかをEtherではなくweiで指定しなくてはならないのだ。

Weiとは?
weiとはEtherの最小単位で、1 etherには10^18 weiがある。

数えるにはゼロが多すぎるが、ラッキーなことに、Web3.jsには我々のためにこれを行ってくれる変換ユーティリティがある。

// これが1 ETHをWeiに変換してくれる
web3js.utils.toWei("1", "ether");

// how to use
以下のコードを使うと、我々のDAppではlevelUpFee = 0.001 etherと設定したので、
ユーザーがlevelUp関数を呼び出す際に併せて0.001送信させることができる:

cryptoZombies.methods.levelUp(zombieId)
.send({ from: userAccount, value: web3js.utils.toWei("0.001", "ether") })




// Web3.js経由でコントラクトとやり取り..
環境設定
関数をcall、
そしてトランザクションをsendするのは、通常のウェブAPIと全然違う、というわけではないからな。


// eventのサブスクライブ
Web3.jsでは、web3プロバイダがコード中のロジックをトリガーとして引くようにイベントを サブスクライブ できる!

cryptoZombies.events.NewZombie()
.on("data", function(event) {
  let zombie = event.returnValues;
  // `event.returnValues`オブジェクトのこのイベントの戻り値３つにアクセスできる:
  console.log("A new zombie was born!", zombie.zombieId, zombie.name, zombie.dna);
}).on("error", console.error);

but.. これだとそのユーザーの分だけでなく、DApp内でゾンビが作成されるたびに通知が表示されてしまう。
そのユーザーの分だけ通知が必要な場合はどうすればよいのか？

// indexed の使用
イベントをフィルタリングして、そのユーザに関連する変更のみをリッスンするには、
Solidityのコントラクトでは、ERC721の実装で行ったTransferイベントのようにindexedというキーワードを使用しなくてはならない:

event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

この場合、_fromと_toはindexedされているので、フロントエンドのイベントリスナーでそれらをフィルターすることは可能であるという意味だ:


getPastEventsを使って過去のイベントをクエリすることや、
fromBlock及びtoBlockのフィルターを使用してSolidityに期間を指定してイベントのログを取ることも可能だ
("block"はこの場合イーサリアムのブロック番号である):
Ex.
cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: "latest" })
.then(function(events) {
  // `events`は、上でやったように反復可能な`event`配列内のオブジェクトである
  // このコードは、これまで生成された全ゾンビのリストを提供してくれる
});

ユースケース .. 安価なストレージとしてのイベントの使用。→イベントの使用はガスコストよりずっと安価。






