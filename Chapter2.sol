** 【ゾンビが人間をおそう】 **
・アドレス ... 銀行口座番号の様なもの。特定のユーザorスマートコントラクトで所有するもの。
ETHのブロックチェーンはアカウント(口座)で構成されている。アカウントにはEtherの残高が記録されている。アカウントにはアドレスがある。
・Mappings ... データを格納。データの保管と参照。キーバリューストア。
// アカウントの残高にuintを格納。(金融系) key=address, value=uint
mapping(address => uint) public accountBalance; 
// ユーザIDをもとにユーザ名を参照・格納 key=uint, value=string
mapping(uint=> string) useIdToName;
・msg.sender...ユーザのaddressを参照できるG変数。関数をcallするときに使用。securityをもたらす。
・require ... 条件を満たさないとエラーを投げて実行STOP.
// require(aa == ??);
   return hoge;
・solidityはネイティブで文字列比較ができない。→keccak256でハッシュを比較!! 
Ex.. require( keccak256(_name) == keccak256("Vital") );

・継承
// BabyDogeはcatchphraseとanotherCatchphrase両方使える。
contract Doge(){
   function catchphrase() public returns (string){
      return "SO WOW CRYPTODOGE";
   }
}
contract BabyDoge is Doge{
   function anotherCatchphrase() public returns (string){
      return "SUCH MOON BABYDOGE";
      }
}

・変数の格納場所 .. storage, memory
storage(HDD) ..チェーン上に永久に格納される変数。状態変数(関数外で宣言された変数)。
memory(RAM) .. 一時的な変数。外部関数をcontractにcallするときに消去される。(関数内で宣言された変数)
EX...
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    // 明示的に宣言！
    
    // storage宣言：
    Sandwich storage mySandwich = sandwiches[_index];
    //この場合`mySandwich`がstorage内の`sandwiches[_index]`を示すポインタだから...
    mySandwich.status = "Eaten!";
    // これで sandwiches[_index] をブロックチェーン上でも永久に変更することになる。

    // コピーしたいだけなら memory の方が便利：
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // この場合 anotherSandwich は memory内のデータをコピーすることになり
    anotherSandwich.status = "Eaten!";
    // 一時的な変数を変更するだけで sandwiches[_index + 1] にはなんの影響もない。次のようにすることも可能 
    sandwiches[_index + 1] = anotherSandwich;
  }
}


