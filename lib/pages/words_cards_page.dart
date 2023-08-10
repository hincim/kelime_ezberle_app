import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kelimeezberle/global/variable/global_variable.dart';
import 'package:kelimeezberle/utils/practical_method.dart';
import '../global/my_widgets/app_bar.dart';
import '../global/my_widgets/toast.dart';
import '../database/dao.dart';
import '../global/functions/global_functions.dart';
import '../models/words.dart';

class WordsCardsPage extends StatefulWidget {
  const WordsCardsPage({Key? key}) : super(key: key);

  @override
  State<WordsCardsPage> createState() => _WordCardPageState();


}


class _WordCardPageState extends State<WordsCardsPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLists().then((value) => setState(() => lists));

  }


  List<Word> words = [];
  bool _isStarted = false;
  List<bool> changeLang = [];
  Which? _chooseQuestionType = Which.learned;
  bool _listMixed = true;

  void getSelectedWordOfLists(List<int> selectedListID) async{

    if(_chooseQuestionType == Which.learned){

      words = await DB.instance.getWordByLists(selectedListID, status: true);
    }else if(_chooseQuestionType == Which.unlearned){
      words = await DB.instance.getWordByLists(selectedListID, status: false);
    }else{
      words = await DB.instance.getWordByLists(selectedListID);
    }

    if(words.isNotEmpty){

      for(int i = 0; i<words.length; ++i){
        changeLang.add(true);
      } // -> İngilizce Türkçe anlamlarını göstermek için for.

      if(_listMixed) words.shuffle();
      // listeyi karıştır.
      _isStarted = true;

      setState(() {
        words;
        _isStarted;
      });

    }else{
      showToast("Seçilen şartlarda liste boş");

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context,
          left: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
          center: const Text("Kelime Kartları",
              style: TextStyle(
                  color: Colors.black, fontFamily: "Carter", fontSize: 22)),
          leftWidgetOnClick: () => Navigator.pop(context)),
      body: SafeArea(
        child: _isStarted == false ? Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(PracticalMethod.HexaColorConvertColor("#1DACC9")),
                    Color(PracticalMethod.HexaColorConvertColor("#0C33B2")),
                  ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(
                  text: "Öğrenmediklerimi sor", value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi sor", value: Which.learned),
              whichRadioButton(text: "Hepsini sor", value: Which.all),
              checkBox(text: "Listeyi karıştır", fWhat: ForWhat.forListMixed),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.black, thickness: 0.5,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Listeler", style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18,),),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 10),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1)
                ),
                child: Scrollbar(
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView.builder(itemBuilder: (context, index){
                    return checkBox(index: index, text: lists[index]["name"].toString());
                  },itemCount: lists.length,),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ), elevation: 6.0),
                    onPressed: (){
                      List<int> selectedIndexNumOfList = [];

                      for(int i = 0; i<selectedListIndex.length; ++i){

                        if(selectedListIndex[i]){
                          selectedIndexNumOfList.add(i);
                          // print(selectedIndexNumOfList);
                        }
                      }

                      List<int> selectedListIDList = [];

                      for(int i = 0; i<selectedIndexNumOfList.length; ++i){

                        selectedListIDList.add(lists[selectedIndexNumOfList[i]]["list_id"] as int);
                        // print(_lists[selectedIndexNumOfList[0]]);
                        // print(_lists[selectedIndexNumOfList[i]]["list_id"]);
                      }

                      if(selectedListIDList.isNotEmpty){
                        getSelectedWordOfLists(selectedListIDList);

                      }else{
                        showToast("En az 1 tane liste seçiniz.");
                      }
                    },
                    child: Text("Başla",style: TextStyle(fontFamily: "RobotoRegular",fontSize: 18),),
                  )
                ),
              )
            ],
          ),
        ) :
        CarouselSlider.builder(
          options: CarouselOptions(
            height: double.infinity,
          ),
          itemCount: words.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){

            String word = "";
            if(chooseLang == Lang.tr){

              word = changeLang[itemIndex] ?( words[itemIndex].word_tr!) : (words[itemIndex].word_eng!);
            }else{

              word = changeLang[itemIndex] ?( words[itemIndex].word_eng!) : (words[itemIndex].word_tr!);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               Expanded(
                 child: Stack(
                   children: [
                     GestureDetector(
                       onTap: (){

                         if(changeLang[itemIndex]){

                           changeLang[itemIndex] = false;
                         }else{
                           changeLang[itemIndex] = true;
                         }
                         setState(() {
                           changeLang;
                         });
                       },
                       child: Container(
                         alignment: Alignment.center,
                         width: double.infinity,
                         margin:
                         const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 16),
                         padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
                         decoration: BoxDecoration(
                             color: Colors.red,
                             borderRadius: const BorderRadius.all(Radius.circular(8)),
                             gradient: LinearGradient(
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                                 colors: [
                                   Color(PracticalMethod.HexaColorConvertColor("#1DACC9")),
                                   Color(PracticalMethod.HexaColorConvertColor("#0C33B2")),
                                 ])),
                         child: Text(word, style: TextStyle(fontFamily: "RobotoRegular",fontSize: 28),),
                       ),
                     ),
                     Positioned(child: Text("${itemIndex+1}/${words.length}", style: TextStyle(fontFamily: "RobotoRegular",fontSize: 16),),
                       left: 25, top: 10,)
                   ],
                 ),
               ),
               SizedBox(
                 width: 160,
                 child: CheckboxListTile(
                    title: Text("Öğrendim"),
                   value: words[itemIndex].status,
                   onChanged: (value){
                      words[itemIndex] = words[itemIndex].copy(status: value);
                      // o kelimenin durumunu değiştirdim.
                     DB.instance.markAsLearned(value!, words[itemIndex].id as int);
                     // vtde de değiştiririm.
                     showToast(value ? "Öğrenildi olarak işaretlendi": "Öğrenilmedi olarak işaretlendi");

                     setState(() {
                       words[itemIndex];
                     });
                     },
                 ),
               )
             ],
            );
          }
        ),
      ),
    );
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 274,
      height: 32,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
          activeColor: Colors.black,
        ),
      ),
    );
  }

  SizedBox checkBox({int index = 0, @required String? text, ForWhat fWhat = ForWhat.forList}) {
    // parametre yollamazsam varsayılan olarak kullan. varsayılan olarak liste için
    // kullanılacak.

    return SizedBox(
      width: 270,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.black,
          hoverColor: Colors.blueAccent,
          value: fWhat == ForWhat.forList ? selectedListIndex[index]:_listMixed,
          onChanged: (bool? value){

            setState(() {
              if(fWhat == ForWhat.forList){
                selectedListIndex[index] = value!;
              }else{

                _listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
