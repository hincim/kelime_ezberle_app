import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kelimeezberle/global/functions/global_functions.dart';
import 'package:kelimeezberle/pages/main_page.dart';
import 'package:kelimeezberle/pages/word_list_page.dart';

import '../../database/dao.dart';
import '../../global/my_widgets/app_bar.dart';
import '../../global/my_widgets/my_button.dart';
import '../../global/my_widgets/text_field_builder.dart';
import '../../global/my_widgets/toast.dart';
import '../../models/lists.dart';
import '../../models/words.dart';
import '../../utils/practical_method.dart';

class UpdateWordDB extends StatefulWidget {


  int? wordId, listId;
  String? word_tr,word_eng, listName;


  UpdateWordDB({required this.listName, this.listId, required this.wordId,required this.word_tr, required this.word_eng});

  @override
  State<UpdateWordDB> createState() => _UpdateWordDBState();
}

class _UpdateWordDBState extends State<UpdateWordDB> {

  final _listName = TextEditingController();
  final _eng = TextEditingController();
  final _tr= TextEditingController();

  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.listId);
    print(widget.wordId);
    print(widget.word_eng);
    print(widget.word_tr);
    print(widget.listName);
   _eng.text = widget.word_eng!;
   _tr.text = widget.word_tr!;
   _listName.text = widget.listName!;
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, left: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 22,
      ),
          right: const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Icon(
                Icons.update_outlined,
                color: Colors.black,
                size: 22,
              )),
          leftWidgetOnClick: ()=>{
            Navigator.pop(context)
          }),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width/1,
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(PracticalMethod.HexaColorConvertColor("#2da2a6")).withOpacity(0.20),
                          Color(PracticalMethod.HexaColorConvertColor("#2da2a6")).withOpacity(0.50),
                        ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Text(
                              "Liste Adı",
                              style:
                              TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                            ),
                          ),
                          Expanded(
                              child: textFieldBuilder(
                                  textEditingController: _listName))
                        ],
                      ),
                    ),
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
                    Row(
                      children: [
                        Expanded(
                            child: textFieldBuilder(
                                textEditingController: _eng)),
                        Expanded(
                            child: textFieldBuilder(
                                textEditingController: _tr))
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async{
                          await DB.instance.updateList(Lists(id: widget.listId,name: _listName.text));

                          await DB.instance.updateWord(Word(status: false,list_id: widget.listId,word_eng: _eng.text,word_tr: _tr.text,id: widget.wordId));
                          onIconPressed(_isKeyboardVisible, context);
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          margin: EdgeInsets.only(bottom: 10,top: 7),
                          child: Icon(
                            Icons.save,
                            size: 28,
                          ),
                          decoration: BoxDecoration(
                              color: Color(PracticalMethod.HexaColorConvertColor("#2da2a6")),
                              shape: BoxShape.circle),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void onIconPressed(isKeyboardVisible,context) {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
      Future.delayed(Duration(milliseconds: 5000));
      showToast("Kelime ve liste adı güncellendi");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage(),), (route) => false); // Önceki sayfaya dönmek için Navigator'ı kullanın
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage(),), (route) => false); // Önceki sayfaya dönmek için Navigator'ı kullanın
      showToast("Kelime ve liste adı güncellendi");
    }
  }
}
