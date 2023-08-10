import 'package:flutter/material.dart';
import '../../database/dao.dart';
import '../../global/my_widgets/app_bar.dart';
import '../../global/my_widgets/text_field_builder.dart';
import '../../global/my_widgets/toast.dart';
import '../../models/words.dart';
import '../../utils/practical_method.dart';


class AddWordPage extends StatefulWidget {

  final int ?_listID;
  final String ?_listName;

  const AddWordPage(this._listID, this._listName, {Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState(listID: _listID, listName: _listName);
}

class _AddWordPageState extends State<AddWordPage> {

  int ?_listID;
  String ?_listName;

  _AddWordPageState({@required int? listID, @required String? listName}) : _listName = listName, _listID = listID;

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 3; i++) {
      debugPrint(
          "====>>>>" + (2 * i).toString() + "     " + (2 * i + 1).toString());
      wordListField.add(Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i])),
          Expanded(
              child: textFieldBuilder(
                  textEditingController: wordTextEditingList[2 * i + 1]))
        ],
      ));
    }
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
          right: const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 22,
              )          ),
          leftWidgetOnClick: ()=>{
            Navigator.pop(context)
          }),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "İngilizce",
                      style:
                      TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                    ),
                    Text("Türkçe",
                        style: TextStyle(
                            fontSize: 18, fontFamily: "RobotoRegular"))
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: wordListField,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionBtn(addRow, Icons.add),
                  actionBtn(save, Icons.save),
                  actionBtn(deleteRow, Icons.remove)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(
        Row(
          children: [
            Expanded(
                child: textFieldBuilder(
                    textEditingController: wordTextEditingList[wordTextEditingList.length -2])),
            Expanded(
                child: textFieldBuilder(
                    textEditingController: wordTextEditingList[wordTextEditingList.length -1])),
          ],
        )
    );
    setState(()=>wordListField);
  }
  void save() async {

      int counter = 0;
      bool notEmptyPair = false;

      for(int i = 0; i<wordTextEditingList.length/2; ++i){

        String eng = wordTextEditingList[2*i].text;
        String tr = wordTextEditingList[2*i+1].text;

        if(!eng.isEmpty && !tr.isEmpty){

          counter++;
        }else{

          notEmptyPair = true;
        }
      }

      if(counter >= 1){

        if(!notEmptyPair){

          for(int i = 0; i<wordTextEditingList.length/2; ++i){

            String eng = wordTextEditingList[2*i].text;
            String tr = wordTextEditingList[2*i+1].text;

            Word word = await DB.instance.insertWord(Word(list_id: _listID,
                word_eng: eng, word_tr: tr, status: false));
            debugPrint(word.id.toString()+" "+word.list_id.toString()+" "+ word.word_tr!!+" "+word.word_eng!!+" "+word.status.toString());
          }
          showToast("Kelimeler eklendi");
          Navigator.pop(context);
          wordTextEditingList.forEach((element) {
            element.clear();
          });

        }else{

          showToast("Boş alanları doldurun veya silin");
        }
      }else{
        showToast("Minimum 1 çift dolu olmalıdır");

      }
    }

  void deleteRow() {
    if(wordListField.length != 1){

      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);

      wordListField.removeAt(wordListField.length-1);

      setState(()=>wordListField);

    }else{
      showToast("Minimum 1 çift gereklidir");
    }
  }

  InkWell actionBtn(Function() click, IconData icon) {
    return InkWell(
      onTap: () => click(),
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(bottom: 10,top: 7),
        child: Icon(
          icon,
          size: 28,
        ),
        decoration: BoxDecoration(
            color: Color(PracticalMethod.HexaColorConvertColor("#2da2a6")),
            shape: BoxShape.circle),
      ),
    );
  }
}
