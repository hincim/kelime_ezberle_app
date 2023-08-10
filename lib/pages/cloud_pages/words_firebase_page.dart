import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kelimeezberle/global/my_widgets/my_button.dart';
import 'package:kelimeezberle/pages/cloud_pages/update_word_firebase.dart';
import 'package:kelimeezberle/utils/file_utils.dart';
import 'package:kelimeezberle/global/my_widgets/app_bar.dart';
import 'package:kelimeezberle/global/my_widgets/toast.dart';
import 'package:kelimeezberle/pages/cloud_pages/add_word_firebase.dart';
import 'package:kelimeezberle/pages/main_page.dart';

import '../../firebase/auth.dart';
import '../../firebase/firestore.dart';
import '../../utils/practical_method.dart';

class WordsFirebasePage extends StatefulWidget {
  const WordsFirebasePage({Key? key}) : super(key: key);

  @override
  State<WordsFirebasePage> createState() => _WordsFirebasePageState();
}

class _WordsFirebasePageState extends State<WordsFirebasePage>
    with TickerProviderStateMixin {
  final FireStoreService _fireStoreService = FireStoreService();
  final AuthService _authService = AuthService();

  late AnimationController _animationControl;

  late Animation<double> _scaleAnimationValues;
  late Animation<double> _rotateAnimationValues;

  bool _fabState = false;

  String _email = "";

  late GlobalKey<RefreshIndicatorState> _refreshKey;

  bool _circularControl = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshKey = GlobalKey<RefreshIndicatorState>();

    FileUtils.readFromFile().then((value) {
      setState(() {
        _email = value;
      });
    });

    _animationControl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _scaleAnimationValues = Tween(begin: 0.0, end: 1.0).animate(_animationControl)
      ..addListener(() {
        setState(() {});
      });

    _rotateAnimationValues =
        Tween(begin: 0.0, end: pi / 2).animate(_animationControl)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        left: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 22,
        ),
        leftWidgetOnClick: () => {Navigator.pop(context)},
        center: Text(
          "Hoşgeldin $_email",
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async {
          setState(() {
            _circularControl = true;
          });
          _fireStoreService.getWordsFirebase().listen((event) {
            if (event.docs.isNotEmpty) {
              setState(() {
                _circularControl = false;
              });
            }
          });
        },
        child: _circularControl
            ? Center(
                child: const CircularProgressIndicator(
                  color: Colors.black38,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.teal])),
                child: StreamBuilder(
                    stream: _fireStoreService.getWordsFirebase(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: const CircularProgressIndicator(
                                color: Colors.black38,
                              ),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                var myWords = snapshot.data?.docs[index];

                                Future<void> _showChoiseDialog(BuildContext) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("${myWords!["eng"]}"
                                            " silinsin mi?"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        content: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              myButton(
                                                  onPressed: () {
                                                    _fireStoreService
                                                        .removeWordsFirebase(
                                                            myWords.id)
                                                        .then((value) {
                                                      showToast(
                                                          "${myWords["eng"]} silindi");
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  text: "Evet"),
                                              myButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  text: "Hayır")
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                                return Dismissible(
                                  key: Key(myWords!.id),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    await _showChoiseDialog(context);
                                    return null;
                                  },
                                  background: Container(
                                      decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateWordFirebase(myWords)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(PracticalMethod
                                                      .HexaColorConvertColor(
                                                          "#2da2a6")),
                                                  Color(PracticalMethod
                                                      .HexaColorConvertColor(
                                                          "#2da2a6"))
                                                ])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "${myWords!["eng"]}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "RobotoMedium",
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 18),
                                              ),
                                              Text("${myWords["tr"]}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          "RobotoMedium",
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 18)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                    }),
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 40,
                right: MediaQuery.of(context).size.width / 40),
            child: Transform.scale(
              scale: _scaleAnimationValues.value,
              child: myFab(onPressed: (){
                _authService.signOut();
                FileUtils.deleteFile();
                showToast("Çıkış yapıldı");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                        (route) => false);
              },label: "Çıkış Yap", icon: Icon(Icons.logout),
              backgroundColor: Colors.orange,)
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 100),
            child: Transform.rotate(
              angle: _rotateAnimationValues.value,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  if (_fabState) {
                    _animationControl.reverse();
                    _fabState = false;
                  } else {
                    _animationControl.forward();
                    _fabState = true;
                  }
                },
                tooltip: "Menü",
                child: Icon(Icons.menu),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 40,
                right: MediaQuery.of(context).size.width / 40),
            child: Transform.scale(
              scale: _scaleAnimationValues.value,
              child: myFab(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddWordFireBase(),
                    ));
              },label: "Kelime Ekle", icon: Icon(Icons.add),backgroundColor: Colors.deepPurple)
            ),
          )
        ],
      ),
    );
  }

  FloatingActionButton myFab(
      {@required Function? onPressed, @required String? label,
      String? tooltip, Widget? icon, Color? backgroundColor}) {
    return FloatingActionButton.extended(
        heroTag: null,
        label: Text(
          label!,
          style: TextStyle(fontSize: 10),
        ),
        onPressed: () => onPressed!(),
        tooltip: label,
        icon: icon,
        backgroundColor: backgroundColor);
  }
}
