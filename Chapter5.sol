//ABOUT TOKEN
トークン、特に ERC20トークン が話題になってるのを恐らく聞いたことがあるだろう。
イーサリアム上のトークン は、基本的にいくつかの共通ルールに従ったスマート・コントラクトだ。

具体的に言うと、transfer(address _to, uint256 _value) や balanceOf(address _owner) といった関数のスタンダードセットを実装しているものだ。
通常スマートコントラクトは、内部に各アドレスにどれだけの残高があるかを記録する mapping(address => uint256) balancesを持っている。

つまり基本的には、トークンとは、誰がトークンをどれくらいを所有しているのかを記録するコントラクトと、
ユーザーが自分のトークンを他のアドレスに送ることができるようにする機能のことなのだ。

・なぜトークンが重要なのか?
すべてのERC20トークンは同じ名前の同じ関数セットを共用しているから、同じ方法で相互に作用することが可能となっている。

つまり、とあるERC20トークンとやりとりするアプリケーションを作った場合、他のERC20トークンとやりとりすることも可能なのだ。
こうすることでカスタムコーディングをせずとも、将来もっと多くのトークンをアプリに追加することができるぞ。
ただ新しいトークンのコントラクト・アドレスを入力するだけで、もうアプリは別のトークンを使えるようになる。

この一例として挙げられるのは取引所であろう。
取引所が新たなERC20トークンを追加するのに必要なのは、トークンとやり取りするためのスマート・コントラクトをただ追加することだ。
ユーザーはトークンを取引所のウォレットアドレスに送るようコントラクトに指示でき、取引所はユーザーが引き出しを要求した場合にトークンを彼らに送り返すようコントラクトに指示することができる。

取引所はこのトランスファー・ロジックを一度実装すれば、新たにERC20トークンを追加したい場合に、新しいコントラクト・アドレスをデータベースに追加するだけで良いということだ。

//ERC20トークンは、通貨のような働きをする非常に素晴らしいトークンだ。

BUT..ERC20で我らがゾンビ・ゲーム内のゾンビを表すのは非常に不便である。
理由としてまず、ゾンビは通貨のように分けることができないことが挙げられる。
例えば0.237ETHをお主に送ることはできても、0.237のゾンビを送るだなんて訳がわからないからな。

なのでそれとは別に、CryptoZombiesのようなクリプト収集物により適したトークン規格がある。 ERC721トークン と呼ばれるものだ。

ERC721トークン は、それぞれがユニークであると仮定され、分割出来ないので 相互に交換可能でない 。
一つの単位ごとの取引のみ可能で、それぞれが特有のIdを持っている。
だからゾンビをトレード可能にするのに完璧に適したものなのだ。


//ERC721規格
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function transfer(address _to, uint256 _tokenId) public;
  function approve(address _to, uint256 _tokenId) public;
  function takeOwnership(uint256 _tokenId) public;
}

//多重継承
コントラクトは次のように複数コントラクトを継承可能だ:
contract SatoshiNakamoto is NickSzabo, HalFinney {
  // Omg, the secrets of the universe revealed!
}


・ERC７２１規格の２つの異なるトークン移転方法。

function transfer(address _to, uint256 _tokenId) public;
function approve(address _to, uint256 _tokenId) public;
function takeOwnership(uint256 _tokenId) public;

一番目の方法はトークン所有者が送り先のaddress、そして送りたいトークンの_tokenIdを送ってtransfer関数を呼び出すものだ。(LIKE送金)

二番目の方法は、トークン所有者がまずapprove関数を呼び出し、一番目と同じ情報を関数に送る。(LIKE受取)
すると、コントラクトが誰がトークン受け取りを許可されたのかを、通常はmapping (uint256 => address)にて記録する。
さらに誰かがtakeOwnershipを呼び出すと、コントラクトはそのmsg.senderがトークンを受け取ることを所有者から承認されているかをチェックし、承認済みの場合は彼にトークンを移転する。

transferとtakeOwnershipのどちらも同じ転送ロジックを含むことに気付くことになるだろうが、順序が逆になる
。（ひとつはトークンの送り手が関数を呼び出すケース、もうひとつはトークンの受け手が関数を呼び出すケース）。


例えばユーザーがアドレス0にうっかりゾンビを送らないよう確認するよう、さらなるチェックを実装に加える方が良いかもしれない
（これはトークン『焼却』と呼ばれ、誰もプライベート・キーを持たないアドレスにトークンは送られ、基本的にそれはリカバーできない)。

・コントラクトのセキュリティ強化: オーバーフローとアンダーフロー
オーバーフロー
例として、uint8は８ビットのみを持つが、つまりここに格納できる最大数値はバイナリの11111111ということだ(またはデシマルだと 2^8 - 1 = 255となる)。
最後はnumberはどうなっているだろうか?

uint8 number = 255;
number++;

この場合、オーバーフローの原因となってしまうとなってしまう。
つまりnumberを増やしても、0になるという通常の感覚に反することが起こる
(もしバイナリの11111111に１を足すと、00000000に戻ってしまう。時計が23:59から00:00になってしまうような感じだ)。

・アンダーフロー
0と等しいuint8から1を引くと、255となる(uintは符号なしであるので、マイナスとなれないからだ)。

我々はここでuint8は使っていないし、uint256を毎回1ずつ増やしてオーバーフローとなることはなさそうであるが(2^256 はかなり大きな数になる)、
このDAppが将来予期せぬ動きを起こさないよう、コントラクト内で対策を講じておくのが良いだろう。

この問題はSafeMathライブラリで回避可能。
(library とは、Solidityにおける特別なタイプのコントラクトだ。
便利なことの一つとして、ネイティブデータ型への関数アタッチができることがある。)
Ex.
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10

・ライブラリについて..
Ex.SafeMath
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

usingで自動的にライブラリの全メソッドを別のデータ型に追加できる！
using SafeMath for uint;
// now we can use these methods on any uint
uint test = 2;
test = test.mul(3); // test now equals 6
test = test.add(5); // test now equals 11
mulとadd関数はそれぞれ２つの引数を必要とするが、using SafeMath for uintを宣言する際、
関数上で呼び出すuint(test)は自動的に一つ目の引数として渡される



今度はSafeMathが何を行なっているかaddの中身のコードを見てみよう:

function add(uint256 a, uint256 b) internal pure returns (uint256) {
  uint256 c = a + b;
  assert(c >= a);
  return c;
}

基本的にaddは２つのuintを+のようにただ足しているが、その合計がaより大きいことを確認するassertステートメントを含んでいる。
こうして我々をオーバーフローから守ってくれるのだ。

assertはrequireと同じようなものだが、偽の場合はエラーを投げる。 
assertとrequireの違いは、requireは関数呼び出しが失敗した場合にユーザーにガスの残りを返却するが、このときassertはそうしない。 
なのでコード中ではほとんどrequireを使いたい。assertはコードにひどい間違いがおこった場合に一般的に使用される(uintのオーバーフローのようにである)。

なのでSafeMathのadd、sub、mulそしてdiv関数をシンプルに使えば、基本的な四則演算を行うし、オーバーフローやアンダーフローの際にはエラーを投げてくれるのだ。

→assertはテストで使うのが良い？？？？


uint16とuint32でオーバーフロー/アンダーフローを回避するには、
さらに２つのライブラリを実装することが必要なのだ。
それらライブラリを、SafeMath16、SafeMath32と呼ぼう。
(SafeMatgはデフォルトでuint256)


// コメントアウト
Solidityのコミュニティでは、 natspec というフォーマットを用いることがスタンダードとなっている。こんな感じだ:

/// @title A contract for basic math operations
/// @author H4XF13LD MORRIS 💯💯😎💯💯
/// @notice For now, this contract just adds a multiply function
contract Math {
  /// @notice Multiplies 2 numbers together
  /// @param x the first uint.
  /// @param y the second uint.
  /// @return z the product of (x * y)
  /// @dev This function does not currently check for overflows
  function multiply(uint x, uint y) returns (uint z) {
    // This is just a normal comment, and won't get picked up by natspec
    z = x * y;
  }
}
@notice は ユーザー に、コントラクトや関数が何を行うか説明する。
@devは開発者向けのさらなる詳細の説明だ。
@paramと@returnでは、関数の各パラメーターが何であり、どんな値を返すのかを記述する。
