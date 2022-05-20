・可視性修飾子 .. いつどこで関数を呼び出すかをコントロールするもの。
Ex..
private修飾詞はコントラクト内の別の関数からのみ呼び出されるという意味だ。
internal修飾詞はprivate修飾詞に似ているが、そのコントラクトを継承したコントラクトからも呼び出す事ができる。
external修飾詞はコントラクト外からだけ呼び出す事ができて、
public修飾詞だが、これはコントラクト内部・外部どちらからでも呼び出せるぞ。

・状態修飾詞 .. 関数がブロックチェーンとどのように作用し合うのか示してくれるものもある。
Ex..
view修飾詞は関数が動作しても、なんのデータも保存または変更されないということだ。
pure修飾詞は、関数がブロックチェーンにデータを保存しないだけでなく、ブロックチェーンからデータを読み込むこともないと表しているぞ。
どちらも、コントラクト外部から呼び出された場合はガスは必要ない。（ただし、コントラクト内にある別の関数から呼び出されるとガスが必要となるからな。）

・カスタムのmodifier、
これら修飾詞の関数への影響の仕方を決定するための、カスタムした理論を定義することが可能だ


・これらの修飾詞は、全て以下のように一つの関数定義に組み込むことができる。
function test() external view onlyOwner anotherModifier { /* ... */ }


・playable関数 .. 関数修飾子。Etherを直接受け取ることができる。
イーサリアムでは、お金(Ether)もデータ(トランザクションの内容)も、コントラクト・コード自体も全てイーサリアム上にあるから、
ファンクション・コール及びお金の支払いが同時に可能だ。
→
関数を実行するため、コントラクトへいくらかの支払いを要求するというようなすごく面白いこともできてしまうのだ。
Ex.
contract OnlineStore {
  function buySomething() external payable {
    // Check to make sure 0.001 ether was sent to the function call:
    require(msg.value == 0.001 ether);
    // If so, some logic to transfer the digital item to the caller of the function:
    transferThing(msg.sender);
  }
}
ここのmsg.valueは、コントラクトにどのくらいEtherが送られたかを見るやり方で、etherは組み込み単位だ。

Ex. web3.js(DappsのJSフロントエンド)から以下の関数を呼び出した場合、
OnlineStore.buySomething({from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001)})
valueの部分を見て欲しい。
ここではJavaScriptのファンクション・コールでetherをどのくらい送るかを定めている(0.001etherだ）。
もしトランザクションを封筒のようなものと考えると、ファンクション・コールに渡すパラメーターは、封筒の中に入れた手紙の内容だ。
そしてvalueを追加するのは、封筒の中に現金を入れるようなものだ。受取人に手紙とお金が一緒に届けられるからな。
注：関数にpayable修飾詞がなく、Etherを上記のように送ろうとする場合、その関数はトランザクションを拒否します。


・コントラクトに送られたEthは、コントラクトのイーサリアム・アカウントに貯められる。
コントラクトからEtherを引き出す関数を追加しない限りはそこに閉じ込められたままになってしまうのだ。

Etherをコントラクトから引き出す関数は、次のように書くぞ。

contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
}
インポートされていることを想定して、ownerとonlyOwner修飾詞をOwnableコントラクトから用いていることに注目してくれ。

transfer関数を使ってEtherをあるアドレスに送ることができ、this.balanceはコントラクトに溜まっている残高の総量を返す。
なのでもし100人のユーザーが１Etherを我々のコントラクトに支払ったとしたら、this.balanceは100Etherに等しくなるはずだ。

transferを使えば、どんなイーサリアムのアドレスにも送金可能だ。
例えば下にあるように、あるアイテムに対する支払いが多すぎた場合に、Etherをmsg.senderに送り返す関数を作ることだってできるのだ。

uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);

または購入者と販売者間のコントラクトにおいて、販売者のアドレスをストレージに保存しておいて、
誰かが販売者のアイテムを購入する際に、購入者が支払った料金を販売者に送金することも可能となる。
やり方はこうだ。seller.transfer(msg.value)

