import 'package:flutter/material.dart';
import 'package:kelimeezberle/database/dao.dart';
import 'package:kelimeezberle/utils/practical_method.dart';
import '../../global/my_widgets/app_bar.dart';
import '../../global/my_widgets/text_field_builder.dart';
import '../../global/my_widgets/toast.dart';
import '../../models/lists.dart';
import '../../models/words.dart';


class CreateListPage extends StatefulWidget {
  const CreateListPage({Key? key}) : super(key: key);

  @override
  State<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final _listName = TextEditingController();

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 5; i++) {
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
      ), center: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Image.asset("assets/images/wordhive.png"),
      ),
      right: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Image.asset(
          "assets/images/logo.png",
          height: 80,
          width: 80,
        ),
      ),leftWidgetOnClick: ()=>{
        Navigator.pop(context)
          }),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              textFieldBuilder(
                  icon: Icon(
                    Icons.list,
                    size: 18,
                  ),
                  hintText: "Liste Adı",
                  textEditingController: _listName,
                  textAlign: TextAlign.left),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
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

    if(!_listName.text.isEmpty){

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

      if(counter >= 4){

        if(!notEmptyPair){

          Lists addedList = await DB.instance.insertList(Lists(name: _listName.text));

          for(int i = 0; i<wordTextEditingList.length/2; ++i){

            String eng = wordTextEditingList[2*i].text;
            String tr = wordTextEditingList[2*i+1].text;

            Word word = await DB.instance.insertWord(Word(list_id: addedList.id,
                word_eng: eng, word_tr: tr, status: false));
            debugPrint(word.id.toString()+" "+word.list_id.toString()+" "+ word.word_tr!!+" "+word.word_eng!!+" "+word.status.toString());
          }
          showToast("Liste oluşturuldu");
          Navigator.pop(context);
          _listName.clear();
          wordTextEditingList.forEach((element) {
            element.clear();
          });

        }else{

          showToast("Boş alanları doldurun veya silin");
        }
      }else{
        showToast("Minimum 4 çift dolu olmalıdır");

      }
    }else{
      showToast("Liste adı olmalı");

    }


  }
  void deleteRow() {
    if(wordListField.length != 4){

      wordTextEditingList.removeAt(wordTextEditingList.length-1);
      wordTextEditingList.removeAt(wordTextEditingList.length-1);

      wordListField.removeAt(wordListField.length-1);

      setState(()=>wordListField);

    }else{
      showToast("Minimum 4 çift gereklidir.");
    }
  }
}
