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


