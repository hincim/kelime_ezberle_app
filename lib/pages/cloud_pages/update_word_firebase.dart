
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/firestore.dart';
import '../../global/my_widgets/app_bar.dart';
import '../../global/my_widgets/my_button.dart';
import '../../global/my_widgets/text_field_builder.dart';
import '../../global/my_widgets/toast.dart';

class UpdateWordFirebase extends StatefulWidget {

  QueryDocumentSnapshot<Object?> myWords;

  UpdateWordFirebase(this.myWords, {super.key});

  @override
  State<UpdateWordFirebase> createState() => _UpdateWordFirebaseState();
}

class _UpdateWordFirebaseState extends State<UpdateWordFirebase> {

  final FireStoreService _fireStoreService = FireStoreService();

  final _eng = TextEditingController();
  final _tr= TextEditingController();
  bool _circularControl = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _eng.text = widget.myWords["eng"];
    _tr.text = widget.myWords["tr"];
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, left: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 22,
      ),leftWidgetOnClick: ()=>{
        Navigator.pop(context)
      }),
      body:SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white,Colors.teal]
              )
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  _circularControl? Center(
                child: const CircularProgressIndicator(
                  color: Colors.black38,
                ),
              )
                  :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: textFieldBuilder(textEditingController:_eng),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: textFieldBuilder(textEditingController: _tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myButton(onPressed: (){
                      setState(() {
                        _circularControl = true;
                      });
                      _fireStoreService.updateWordFirebase(widget.myWords, _eng.text == ""?widget.myWords["eng"]: _eng.text,_tr.text == "" ?widget.myWords["tr"]:_tr.text ).then((value){
                        setState(() {
                          _circularControl = false;
                        });
                        showToast("Kelime güncellendi");
                        return Navigator.pop(context);
                      });
                    }, text: "Güncelle"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
