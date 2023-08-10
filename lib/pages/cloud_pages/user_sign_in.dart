import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kelimeezberle/firebase/auth.dart';
import 'package:kelimeezberle/pages/cloud_pages/words_firebase_page.dart';
import '../../global/functions/global_functions.dart';
import '../../utils/file_utils.dart';
import '../../global/my_widgets/app_bar.dart';
import '../../global/my_widgets/my_button.dart';
import '../../global/my_widgets/text_field_builder.dart';
import '../../global/my_widgets/toast.dart';


class UserSignIn extends StatefulWidget {
  const UserSignIn({Key? key}) : super(key: key);

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> with TickerProviderStateMixin {

  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();

  final AuthService _authService = AuthService();
  bool _circularControl = false;

  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  bool _isKeyboardVisible = false;

  bool _isClicked = false;
  bool _obscureText = true;

  late AnimationController _translateController;
  late Animation<double> _translateAnimationValues;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });

    _translateController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _translateAnimationValues = Tween(begin: -800.0,end: 0.0).animate(CurvedAnimation(parent: _translateController, curve: Curves.easeInOut))..addListener(() {
      setState(() {});
    });
    _translateController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _translateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, left: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 22,
      ), center: Padding(
        padding: const EdgeInsets.only(top: 4.0,left: 10),
        child: Transform.translate(
          offset: Offset(-_translateAnimationValues.value, 0.0),
          child: Image.asset(
            "assets/images/logo.png",
            height: 80,
            width: 80,
          ),
        ),
      ),
          leftWidgetOnClick: ()=>{
            onIconPressed(_isKeyboardVisible,context)
          }),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white,Colors.teal.withOpacity(0.30)]
                )
            ),
            child:_circularControl? Center(
              child: const CircularProgressIndicator(
                color: Colors.black38,
              ),
            )
                : Transform.translate(
              offset: Offset(-_translateAnimationValues.value, 0.0),
                  child: Center(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),  // Gölge rengi
                                spreadRadius: 10,  // Gölge yayılma yarıçapı
                                blurRadius: 20,  // Gölge bulanıklık yarıçapı
                              ),
                            ],
                          ),
                          child: Text(
                            'Hoşgeldiniz',
                            style: TextStyle(fontFamily: "Carter",color: Colors.teal.withOpacity(0.7)),
                          ),
                        )
                        ,
                      ),
                      Image.asset("assets/images/wordhive.png",width: 200,height: 200,
                        alignment: Alignment.center,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textFieldBuilder(textEditingController: _userName,
                            hintText: "Kullanıcı Adı",textAlign: TextAlign.start, icon: Icon(Icons.person)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textFieldBuilder(textEditingController: _email,
                            hintText: "Email",textAlign: TextAlign.start, icon: Icon(Icons.email),
                        textInputType: TextInputType.emailAddress),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textFieldBuilder(textEditingController: _password,
                            hintText: "Şifre", textAlign: TextAlign.start, icon: Icon(Icons.password),
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                _isClicked = !_isClicked;
                                if(_isClicked){
                                  _obscureText = false;
                                }else{
                                  _obscureText = true;
                                }
                              });
                            }, icon: Icon(Icons.remove_red_eye_outlined,color: _isClicked? Colors.blue:Colors.white)),
                            obscureText: _obscureText),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 100.0),
                            child: myButton(onPressed: (){
                              if(_userName.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty){
                                showToast("Boş alanlar doldurulmalıdır");
                              }else if(!_email.text.contains("@")){
                                showToast("Geçerli bir email girin");
                              }else if(_password.text.length < 6){
                                showToast("Şifre en az 6 karakter içermelidir");
                              }
                              else{
                                setState(() {
                                  _circularControl = true;
                                });
                                _authService.createPerson(_userName.text.trim(), _email.text.trim().toLowerCase(), _password.text.trim()).then((value){
                                  showToast("Kullanıcı oluşturuldu");
                                  setState(() {
                                    _circularControl = false;
                                  });
                                  FileUtils.saveToFile(_email.text.trim());

                                  _email.text = "";
                                  _userName.text = "";
                                  _password.text = "";
                                  return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WordsFirebasePage(),));
                                }).catchError((dynamic error){

                                  setState(() {
                                    _circularControl = false;
                                  });

                                  switch(error.code){
                                    case "invalid-email":
                                      showToast("Hatalı email hesabı");
                                      break;
                                    case "email-already-in-use":
                                      showToast("Bu hesapla kullanıcı vardır");
                                      break;
                                    default:
                                      break;
                                  }
                                });
                              }
                            }, text: "Kayıt Ol"),
                          ),
                        ],
                      )
                    ],
                  ),
              ),
            ),
                ),
          )
      ),
    );
  }
}
