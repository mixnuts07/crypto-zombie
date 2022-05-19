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

・関数修飾子：修飾子は半分関数のようなもので、他の関数を編集する際に使うものだ。通常は実行する前に要件をチェックするために使用するぞ。この例で言えば、onlyOwnerはowner(オーナー）だけが関数を実行できるように、制限をアクセスするために使用されているのだ。
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

onlyOwnerは誰もが皆必要としているものだから非常に一般的になった。だからSolidityのDAppを開発するときには、皆がこのOwnableコントラクトをコピーペーストしてから、最初のコントラクトの継承を始めているのだ。 我々もsetKittyContractAddress をonlyOwnerに制限したいから、同じ様にするのだぞ。



・solidityではユーザが関数を使うたびに_ガス_通貨を支払う。
ユーザはETHでガスを買い、アプリの関数を実行する。
ガスの量は関数ロジックの複雑さによるもの。
ガスのコスト..各操作に必要なガスの価格の合計。
 
