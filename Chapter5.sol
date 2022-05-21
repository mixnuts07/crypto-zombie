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

一番目の方法はトークン所有者が送り先のaddress、そして送りたいトークンの_tokenIdを送ってtransfer関数を呼び出すものだ。

二番目の方法は、トークン所有者がまずapprove関数を呼び出し、一番目と同じ情報を関数に送る。
すると、コントラクトが誰がトークン受け取りを許可されたのかを、通常はmapping (uint256 => address)にて記録する。
さらに誰かがtakeOwnershipを呼び出すと、コントラクトはそのmsg.senderがトークンを受け取ることを所有者から承認されているかをチェックし、承認済みの場合は彼にトークンを移転する。

transferとtakeOwnershipのどちらも同じ転送ロジックを含むことに気付くことになるだろうが、順序が逆になる
。（ひとつはトークンの送り手が関数を呼び出すケース、もうひとつはトークンの受け手が関数を呼び出すケース）。
