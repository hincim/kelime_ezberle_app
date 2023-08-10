import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/lists.dart';
import '../models/words.dart';

// bir sınıftan sadece bir adet nesne oluşturmak istersek Singleton
// yapısını kullanırız.

class DB{

  static final DB instance = DB._init();
  static Database? _database;

  DB._init();

  Future<Database> get database async{

    if(_database != null) return _database!;
    // database daha önce tanımlandıysa dön

    _database = await _initDB('kelimeezberle.db');
    // database daha önce tanımlanmadıysa vtyi oluşturur ve _database değişkenine atar.

    return _database!;
  }

  Future<Database> _initDB(String filePath) async{

    final path = join(await getDatabasesPath(),filePath);
    // veri tabanının yolunu alırım.
    return await openDatabase(path,version: 1,onCreate: _createDB);
    // _createDB fonksiyonuna path ve version bilgisi gönderilir.
  }

  Future _createDB(Database db, int version) async{

    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNameLists (
    ${ListsTableFields.id} $idType,
    ${ListsTableFields.name} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNameWords (
    ${WordTableFields.id} $idType,
    ${WordTableFields.list_id} $integerType,
    ${WordTableFields.word_eng} $textType,
    ${WordTableFields.word_tr} $textType,
    ${WordTableFields.status} $boolType,
    FOREIGN KEY(${WordTableFields.list_id}) REFERENCES $tableNameLists (${ListsTableFields.id}))
    ''');
  }

  Future<Lists> insertList(Lists lists) async{

    final db = await instance.database;
    final id = await db.insert(tableNameLists, lists.toJson());

    return lists.copy(id: id);
  }

  Future<Word> insertWord(Word word) async{

    final db = await instance.database;
    final id = await db.insert(tableNameWords, word.toJson());
    return word.copy(id: id);
  }

  Future<List<Word>> getWordByList(int ?listID) async{

    final db = await instance.database;
    final orderBy = '${WordTableFields.id} ASC';
    // düşükten yükseğe doğru sırala.
    final result = await db.query(tableNameWords,orderBy: orderBy,
    where: '${WordTableFields.list_id} =?',whereArgs: [listID]);
    return result.map((json) => Word.fromJson(json)).toList();
  }



  Future<List<Map<String,Object?>>> getListsAll() async{
    final db = await instance.database;

    List<Map<String,Object?>> result = [];
    List<Map<String,Object?>> lists = await db.rawQuery("SELECT id,name FROM lists");

    await Future.forEach(lists, (element) async{
      // element = element as Map;

      var wordInfoByList = await db.rawQuery("SELECT(SELECT COUNT(*) FROM words where list_id=${element['id']}) as sum_word,"
          "(SELECT COUNT(*) FROM words where status=0 and list_id=${element['id']}) as sum_unlearned");
      // her listemizin id bilgisine göre o listeye ait kelimeler tablosundaki kelime sayısını ve öğrenilmemiş
      // kelime sayısını çekerim.

      Map<String,Object?> temp = Map.of(wordInfoByList[0]);
      // gelen mapi kopyaladım.

      temp['name'] = element['name'];
      temp['list_id'] = element['id'];
      result.add(temp);
    });
    
    print(result);

    return result;
  }

  Future<List<Word>> getWordByLists(List<int> listsID, {bool? status}) async{
    final db = await instance.database;

    String idList = "";

    // örn [4,5,6]
    // burada son değerde "," yok o yüzden son değer hariç aralara virgül koyarım.


    for(int i = 0; i<listsID.length; ++i){

      if(i == listsID.length - 1){

        idList += (listsID[i].toString());
      }else{
        idList += (listsID[i].toString()+",");

      }
    }

    List<Map<String, Object?>> result;
    if(status != null){

      result = await db.rawQuery('SELECT * FROM words WHERE list_id IN($idList) and status=${status?"1":"0"}');
    }else{
      result = await db.rawQuery('SELECT * FROM words WHERE list_id IN($idList)');

    }

    return result.map((json) => Word.fromJson(json)).toList();
  }


  Future<int> updateWord(Word word) async{

    final db = await instance.database;
    return db.update(tableNameWords, word.toJson(),where: '${WordTableFields.id} =?',whereArgs: [word.id]);

  }
  Future<int> updateList(Lists lists) async{

    final db = await instance.database;
    return db.update(tableNameLists, lists.toJson(),where: '${ListsTableFields.id} =?',whereArgs: [lists.id]);

  }

  Future<int> deleteWord(int id) async{

    final db = await instance.database;
    return db.delete(tableNameWords,where: '${WordTableFields.id} = ?',whereArgs: [id]);

  }

  Future<int> markAsLearned(bool mark, int id) async{
    final db = await instance.database;
    int result = mark==true?1:0;
    // mark true ise result 1 olsun değilse 0 olsun.
    return db.update(tableNameWords, {WordTableFields.status:result},where: '${WordTableFields.id} = ?',whereArgs: [id]);
  }

  Future<int> deleteListsAndWordByList(int id) async{

    final db = await instance.database;

    int result = await db.delete(tableNameLists,where: '${ListsTableFields.id} =? ',whereArgs: [id]);

    if(result == 1){
      // liste silindiyse
      await db.delete(tableNameWords,where: '${WordTableFields.id} =?',whereArgs: [id]);
    }
    return result;
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

}


