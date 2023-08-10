import 'package:flutter/material.dart';
import 'package:kelimeezberle/global/my_widgets/app_bar.dart';
import 'package:kelimeezberle/global/my_widgets/toast.dart';
import '../../firebase/firestore.dart';
import '../../global/my_widgets/my_button.dart';
import '../../global/my_widgets/text_field_builder.dart';

class AddWordFireBase extends StatefulWidget {
  const AddWordFireBase({Key? key}) : super(key: key);

  @override
  State<AddWordFireBase> createState() => _AddWordFireBaseState();
}

class _AddWordFireBaseState extends State<AddWordFireBase> {

  final FireStoreService _fireStoreService = FireStoreService();

  final _eng = TextEditingController();
  final _tr= TextEditingController();
  bool _circularControl = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                            child: textFieldBuilder(textEditingController: _eng,
                            hintText: "İngilizce",),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: textFieldBuilder(textEditingController: _tr,
                            hintText: "Türkçe"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myButton(onPressed: (){
                      if(_eng.text.isEmpty || _tr.text.isEmpty){
                        showToast("Lütfen kelime ve anlamını giriniz");
                        return;
                      }
                      setState(() {
                        _circularControl = true;
                      });
                      _fireStoreService.addWordFirebase(_eng.text, _tr.text).then((value){
                        setState(() {
                          _circularControl = false;
                        });
                        showToast("Kelime eklendi");
                        return Navigator.pop(context);
                      });
                    }, text: "Ekle"),
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
