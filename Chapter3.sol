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

modifier修飾子を関数につけると、修飾された関数を実行する前に、modifierの処理を予め実行させることが可能。
Ex.
modifierの基本構文
modifier modifier名称{
  modifierの処理部分;
  _;
}
解説
1行目のmodifierでは、Solidityのmodifierを利用することを宣言します。modifierの名称という部分で、実装するmodifierの名称を定義します。
{を記載することで、modifierの処理部分を開始したことを定義します。

2行目のmodifierの処理部分では、実際に処理する内容を記載します。処理の最後には;を記載することで、1つの処理が終了したことを表します。

3行目の _; では、処理部分全体が終了したことを意味します。この _; は必ず必要です。

4行目の } では、1行目のmodifier処理定義が終了したことを意味します。


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


・引数のある関数修飾子
// ユーザーの年齢を格納するマッピングだ：
mapping (uint => uint) public age;

// ユーザーの年齢が一定の年齢より高いことを要件とする関数修飾子だ：
modifier olderThan(uint _age, uint _userId) {
  require (age[_userId] >= _age);
  _;
}

// 車の運転は１６歳以上だな（米国の場合だ。日本は１８歳だな）。
//  こういう場合に引数のある`olderThan`修飾子を使うのだ。こんな風に書けばいい：
function driveCar(uint _userId) public olderThan(16, _userId) {
  // 関数のロジックだ
}


・View 関数はガスコストが不要。
view関数を外部から呼び出す場合、ガスは一切かからない。

なぜかというと、view 関数がブロックチェーン上でなにも変更しないからだ。ただデータを参照するだけだからな。
詳しくいうと、関数にviewとマークすることで、その関数を実行するにはローカルのイーサリアムノードに問い合わせるだけでよく、
ブロックチェーン上にトランザクションを生成する必要がないことをweb3.jsに伝えられるためだ（トランザクションを生成すると全てのノードで実行する必要があり、ガスが必要になる）
external view関数を使うことで、DAppのガス使用量を最適にすることが出来ると覚えておくのだ。
注：view関数が同じコントラクトの、view関数ではない別の関数から呼び出される場合、その呼び出しにガスのコストがかかります。
その別の関数はイーサリアム上にトランザクションを生成するので、各ノードの検証が必要になるためです。view関数は外部から呼び出す時のみ、無料になります。

・stoageのコストが高い理由
→
なぜかというと、データを書き込んだり、変更するたびに、それがすべてブロックチェーンに永久に書き込まれるからだ。
世界中の何千個というノードがすべてそのデータをハードドライブに書き込む必要があり、
そのデータ容量はブロックチェーンが成長すればするほど大きくなるのだ。だからどうしてもコストは高くなる。

そこで、コストを抑えるために、絶対に必要な場合を除いてデータをstorageに書き込まないようにするのだ。
そのため、一見非効率的なロジックを作ることもある。例えば、単純に配列を変数に保存するかわりに、関数を呼び出す毎にmemory上の配列を再構築するとか、だ。

・memory内で配列を宣言する
関数の中でmemoryキーワード付きで配列を生成すると、storageに書き込むことなく新しい配列を作ることができる。
配列は関数内でのみ存在するから、storageの配列を更新するよりも圧倒的にガスのコストを抑えることができる

function getArray() external pure returns(uint[]) {
  // 長さ3の新しい配列をメモリ内にインスタンス化する
  uint[] memory values = new uint[](3);
  // 値を追加しよう
  values.push(1);
  values.push(2);
  values.push(3);
  // 配列を返す
  return values;
}
注：memoryの配列は必ず長さを指定して作成する必要があります（この例では3）。
現在はstorage配列のようにarray.push()でサイズを変えることはできませんが、Solidityの将来のバージョンでは可能になるかもしれません。

・forループ
Ex.偶数を格納
function getEvens() pure external returns(uint[]) {
  uint[] memory evens = new uint[](5);
  // 新しい配列のインデックスをトラックする：
  uint counter = 0;
  // 1から10までループさせる：
  for (uint i = 1; i <= 10; i++) {
    // もし `i` が偶数なら...
    if (i % 2 == 0) {
      // 配列に格納する
      evens[counter] = i;
      // カウンタを増やして `evens`の空のインデックスにする：
      counter++;
    }
  }
  return evens;
}
