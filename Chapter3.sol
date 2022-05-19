・contractをETHにデプロイすると イミュータブル（編集・更新不可）になる。
→デプロイした最初のコードは永久にチェーン上に残る。
→欠陥があっても修正できなくなる。。
でデプロイした関数が使われるから、透明性。
外contractのハードアドレス等に異変があれば更新できる様にしたい。。

・contractのアドレスを一部の人のみ変更可能にしたい。。→Owneble(所有可能)→contractにはオーナーがいることを可能にする。
OpenZepplnライブラリ...Ownebleコントラクト
Ex..
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
・コンストラクタ： function Ownable()はコンストラクタだ。これは特別な関数で、コントラクトと同じ名前だ。コントラクトが最初に作成された時に、1度だけ実行されるぞ。

・関数修飾子：修飾子は半分関数のようなもので、他の関数を編集する際に使うものだ。通常は実行する前に要件をチェックするために使用するぞ。
この例で言えば、onlyOwnerはowner(オーナー）だけが関数を実行できるように、制限をアクセスするために使用されているのだ。
関数修飾子..modefyで宣言
関数のように直接呼び出すことはできず、代わりに関数定義の最後に修飾子の名前をつけることで、関数の動きを変更
Ex.
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}
contract MyContract is Ownable {
  event LaughManiacally(string laughter);

  //`onlyOwner`の使い方を確認せよ：
  function likeABoss() external onlyOwner {
    LaughManiacally("Muahahahaha");
  }
}
likeABoss関数のonlyOwner修飾子を見るのだ。
likeABossを呼び出すと onlyOwnerの中のコードが最初に実行されるのがわかるだろう。それからonlyOwnerの_;ステートメントにたどり着いた時に、
likeABossに戻ってコードを実行するようになっているのだ。

・indexed キーワード：これは無視して良い。必要ない


・Ownableコントラクトは基本的には次のようになる。これを覚えておくようにな：

コントラクトが作られた時、コンストラクタがowner を msg.sender （実行した人物だ）に設定する。

onlyOwner修飾子を追加して、ownerだけが特定の関数にアクセスできるように設定する。

新しいownerにコントラクトを譲渡することも可能だ

onlyOwnerは誰もが皆必要としているものだから非常に一般的になった。だからSolidityのDAppを開発するときには、
皆がこのOwnableコントラクトをコピーペーストしてから、最初のコントラクトの継承を始めているのだ。 我々もsetKittyContractAddress をonlyOwnerに制限したいから、同じ様にするのだぞ。



・solidityではユーザが関数を使うたびに_ガス_通貨を支払う。
ユーザはETHでガスを買い、アプリの関数を実行する。
ガスの量は関数ロジックの複雑さによるもの。
ガスのコスト..各操作に必要なガスの価格の合計。
 
 イーサリアムは、大きくて、遅いけれども、極めて安全なコンピューターのようなものだ。
 関数を実行する時には、ネットワーク上で必要になるすべてのノードで同じ関数が実行されて、出力が正しいことを検証するのだ。
 何千ものノードが関数の実行を検証する仕組みこそが、イーサリアムを分散型にして、データを不変で検閲耐性の強いものにしているのだ。

イーサリアムの作成者は、誰かが無限ループを起こしてネットワークを詰まらせたり、非常に重い処理でネットワークの計算資源を食いつぶしたりしないようにしたいと願っていたのだ。
だからこそ、トランザクションを無料にすることを避け、ユーザーに計算時間とストレージについて支払うようにしたのだ。

Solidityはuintのサイズに関わらず256ビットのストレージを確保する
Ex. uint8,16,32,256も全て256bit確保する。。。
structの中に複数の uintがある場合、できる限り小さい単位の uintを使うことで、Solidityが複数の変数をまとめて、ストレージを小さくすることが可能
また、同じデータ型の変数を一箇所にまとめることで（つまり、structの中で隣り合わせることで）、Solidityのstorageスペースを最小限に抑えることも可能だ。
例えば、uint c; uint32 a; uint32 b;は、uint32 a; uint c; uint32 b;よりもコストが低くなる。なぜなら2つのuint32変数をまとめることできるからだ。

・時間の単位
now変数は、現在のunixタイムスタンプ（1970年1月1日から経過した秒数）
seconds、 minutes、 hours、 days、weeks 、years
それぞれuintの秒数に変換されて使用される。
つまり、1 minutes は 60になり、1 hours は 3600 (60 秒 x 60 分)になり、1 days は86400 (24時間 x 60 分 x 60 秒)となる。

・structを引数として渡す
structへのstorageポインタは、privateやinternal関数の引数として渡すことができる。
Ex.、Zombie　structを関数に渡すことも可能
function _doStuff(Zombie storage _zombie) internal {
  //  _zombieを処理する
}
→ゾンビIDを渡して探す代わりに、関数にゾンビの参照そのものを渡すことが可能！！
