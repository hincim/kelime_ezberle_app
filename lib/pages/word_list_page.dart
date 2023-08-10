import 'package:flutter/material.dart';
import 'package:kelimeezberle/database/dao.dart';
import 'package:kelimeezberle/pages/words_page.dart';
import 'package:kelimeezberle/utils/practical_method.dart';
import '../global/my_widgets/app_bar.dart';
import '../global/my_widgets/toast.dart';
import 'local_database_page/create_list_page.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({Key? key}) : super(key: key);

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {

  List<Map<String,Object?>> _lists = [];
  List<bool> deleteIndexList = [];

  bool pressController = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists();
  }

  void getLists() async{

    _lists = await DB.instance.getListsAll();
    for(int i = 0; i<_lists.length; ++i){

      deleteIndexList.add(false);
    }

    setState(() {
      _lists;
    });  // _lists adlı değişkenin dolduğunu sayfaya bildiririm. Sayfayı güncellemek için.
  }

  void delete() async{

    List<int> removeIndexList = [];

    for(int i = 0; i<_lists.length; ++i){
      if(deleteIndexList[i] == true){
        removeIndexList.add(i);
      }
    }
    for(int i = removeIndexList.length - 1; i>=0; --i){
      // sondan silmeye başlarım hatalı silme olmaması için.

      DB.instance.deleteListsAndWordByList(_lists[removeIndexList[i]]['list_id'] as int);
      _lists.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }

    setState(() {
      _lists;
      deleteIndexList;
      pressController = false;
    });

    showToast("Seçili listeler silindi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, left: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 22,
      ), center: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Image.asset("assets/images/lists.png"),
      ),
      right:Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child:  pressController != true ? Image.asset("assets/images/logo.png",
          height: 80,width: 80,): GestureDetector(
        child: Icon(Icons.delete, color: Colors.teal,size: 28,),
        onTap: delete,
        ),
      ) ,
      leftWidgetOnClick: ()=>{
        Navigator.pop(context)
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateListPage())).then((value){
          getLists();
        });

      },
      backgroundColor: Colors.teal.withOpacity(0.8),child: const Icon(Icons.add),),
      body: SafeArea(
        child: ListView.builder(itemBuilder: (context, index){
          return listItem(_lists[index]['list_id'] as int, index,
              listname: _lists[index]['name'].toString(),
              sumWords: _lists[index]['sum_word'].toString(),
              sumUnlearned: _lists[index]['sum_unlearned'].toString());
        },itemCount: _lists.length,),
        ),
      );
  }

  GestureDetector listItem(int id,int index, {@required String ?listname, @required String ?sumWords,
  @required String ?sumUnlearned}) {
    int sumLearned = int.parse(sumWords!) - int.parse(sumUnlearned!);

    return GestureDetector(
      onTap: (){
        debugPrint(id.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) => WordsPage(id, listname))).then((value) {
          getLists();
        });
      },
      onLongPress: (){
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });

      },
      child: Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Color(PracticalMethod.HexaColorConvertColor("#2da2a6")),
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
                            margin: EdgeInsets.only(left: 15,top: 5),
                            child: Text(listname!,style: TextStyle(color: Colors.black,
                            fontSize: 16,fontFamily: "RobotoMedium"),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Text(sumWords+" terim",style: TextStyle(color: Colors.black,
                                fontSize: 14,fontFamily: "RobotoRegular"),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Text("$sumLearned öğrenildi",style: TextStyle(color: Colors.black,
                                fontSize: 14,fontFamily: "RobotoRegular"),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30,bottom: 5),
                            child: Text("$sumUnlearned öğrenilmedi",style: TextStyle(color: Colors.black,
                                fontSize: 14,fontFamily: "RobotoRegular"),),
                          )
                        ],
                      ),
                      pressController == true ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                        hoverColor: Colors.blueAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value){

                          setState(() {
                            deleteIndexList[index] = value!;

                            bool deleteProcessController = false;

                            deleteIndexList.forEach((element) {

                              if(element == true){
                                deleteProcessController = true;
                              }
                            });
                            if(!deleteProcessController){
                              // hiçbir eleman seçili değilse
                              pressController = false;
                            }
                          });
                        },
                      ):Container()
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
