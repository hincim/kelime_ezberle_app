import 'package:flutter/material.dart';
import 'package:kelimeezberle/database/dao.dart';
import 'package:kelimeezberle/global/functions/global_functions.dart';
import '../global/my_widgets/app_bar.dart';
import '../global/my_widgets/toast.dart';
import '../models/words.dart';
import '../utils/practical_method.dart';
import 'local_database_page/add_word_page.dart';
import 'local_database_page/update_word_db.dart';

class WordsPage extends StatefulWidget {
  final int ?_listID;
  final String ?_listName;

  const WordsPage(this._listID, this._listName,{Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() => _WordsPageState(listID: _listID,listName: _listName);
}

class _WordsPageState extends State<WordsPage> {
  int ?_listID;
  String ?_listName;

  _WordsPageState({@required int? listID, @required String? listName}) : _listName = listName, _listID = listID;

  List<Word> wordList = [];

  bool _pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("$_listID - $_listName");
    getWordByList();
  }

  void getWordByList() async{


    wordList = await DB.instance.getWordByList(_listID);

    for(int i = 0; i<wordList.length; i++){
      deleteIndexList.add(false);
    }
    setState(() => wordList);
    // sayfaya kelimelerin geldiğini bildiririm.

  }

  void delete() async{

    List<int> removeIndexList = [];
    for(int i = 0; i<deleteIndexList.length; ++i){
      if(deleteIndexList[i]){
        removeIndexList.add(i);
      }
    }

    for(int i = removeIndexList.length -1; i>=0; --i){
      DB.instance.deleteWord(wordList[removeIndexList[i]].id!);
      wordList.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }

    setState(() {
      wordList;
      deleteIndexList;
      _pressController = false;
    });

    showToast("Seçili kelimeler silindi.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appBar(context, left: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 22,
      ), center: Text(_listName!, style: TextStyle(fontFamily: "carter",fontSize: 22,
      color: Colors.black),),
          right: _pressController!=true ? Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset("assets/images/logo.png",
              height: 80,width: 80,)
          ): GestureDetector(
            onTap: delete,
            child: Icon(Icons.delete, color: Colors.teal,size: 28,),
          ) ,
          leftWidgetOnClick: ()=>{
            Navigator.pop(context)
          }),

      body: SafeArea(
        child: ListView.builder(itemBuilder: (context, index) {
          
          return wordItem(wordList[index].id!,
              index, word_tr: wordList[index].word_tr, word_eng: wordList[index].word_eng, status: wordList[index].status);
        },
        itemCount: wordList.length,),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => AddWordPage(_listID, _listName))).then((value){
          getWordByList();
        });

      },
        backgroundColor: Colors.teal.withOpacity(0.8),child: const Icon(Icons.add),),
    );
  }

  GestureDetector wordItem(int wordId, int index, {@required String ?word_tr,
  @required String ?word_eng, @required bool ?status}) {
    return GestureDetector(
      onLongPress: (){
        setState(() {
          _pressController = true;
          deleteIndexList[index] = true;
        });
      },
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateWordDB(listName: _listName, listId: _listID, wordId: wordId,word_tr: word_tr,word_eng: word_eng,))).then((value){
          getWordByList();
          getLists();
        });
      },
      child: Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: _pressController!=true? Color(PracticalMethod.HexaColorConvertColor("#2da2a6")):
                  Color(PracticalMethod.HexaColorConvertColor("#92d5d7")),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  margin: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15,top: 10),
                            child: Text(word_tr!,style: TextStyle(color: Colors.black,
                                fontSize: 18,fontFamily: "RobotoMedium"),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30,bottom: 10),
                            child: Text(word_eng!,style: TextStyle(color: Colors.black,
                                fontSize: 16,fontFamily: "RobotoRegular"),),
                          ),
                        ],
                      ),
                      _pressController!=true? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                        hoverColor: Colors.blueAccent,
                        value: status,
                        onChanged: (bool? value){

                          wordList[index] = wordList[index].copy(status: value);
                          if(value == true){
                            showToast("Öğrenildi olarak işaretlendi");
                            DB.instance.markAsLearned(true, wordList[index].id as int);
                          }else{
                            showToast("Öğrenilmedi olarak işaretlendi");
                            DB.instance.markAsLearned(false, wordList[index].id as int);
                          }
                          setState(() {
                            wordList;
                            // listeyi güncellerim.
                          });
                        },
                      ):Checkbox(checkColor: Colors.white,
                        activeColor: Colors.black,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                      onChanged: (bool ?value){

                        setState(() {
                          deleteIndexList[index] = value!;
                          bool deleteProcessController = false;

                          deleteIndexList.forEach((element) {
                            if(element == true){
                              deleteProcessController = true;
                            }
                          });

                          if(!deleteProcessController){
                            _pressController = false;
                          }

                        });
                      },) // silme checkboxı
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
