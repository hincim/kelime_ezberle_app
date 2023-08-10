import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kelimeezberle/pages/cloud_pages/user_login.dart';
import 'package:kelimeezberle/pages/word_list_page.dart';
import 'package:kelimeezberle/pages/words_cards_page.dart';
import 'package:kelimeezberle/utils/practical_method.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../global/variable/global_variable.dart';
import '../utils/location.dart';
import '../utils/weather.dart';
import '../global/my_widgets/app_bar.dart';
import '../global/my_widgets/toast.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

final Uri _urlGithub = Uri.parse('https://github.com/hincim');

Future<void> _launchUrlGithub() async {
  if (!await launchUrl(_urlGithub)) {
    throw Exception('Could not launch $_urlGithub');
  }
}

/*Future<void> _launchUrlGmail() async {
  if (!await launchUrl(_urlGmail)) {
    throw Exception('Could not launch $_urlGmail');
  }
}*/

class _MainPageState extends State<MainPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // bununla drawerı açacağım.

  PackageInfo? packageInfo;
  String version = "";
  late WeatherData weatherData;
  bool spinKitController = true;

  @override
  void initState() {
    super.initState();
    packageInfoInit();
    getWeatherData();
  }


  late String temperature;
  late Icon weatherDisplayIcon;
  late AssetImage backGroundImage;
  late String city;

  void updateDisplayInfo(WeatherData weatherData){
    setState(() {
      temperature = weatherData.currentTemperature.round().toString();
      WeatherDisplayData weatherDisplayData = weatherData.getWeatherDisplayData();
      backGroundImage = weatherDisplayData.weatherImage;
      weatherDisplayIcon = weatherDisplayData.weatherIcon;
      city = weatherData.city;
    });
  }

  late LocationHelper locationData;
  Future<void> getLocationData() async{

    locationData = LocationHelper();
    await locationData.getCurrentLocation();

    if(locationData == null || locationData.longitude == null){
      showToast("Konum bilgisi alınamadı");
    }else{
      print("latitude: "+locationData.latitude.toString());
      print("longitude: "+locationData.longitude.toString());
    }
  }

  void getWeatherData() async{
    await getLocationData();
    // İLK OLARAK KONUMU AL
    weatherData = WeatherData(locationData: locationData);
      await weatherData.getCurrentTemperature();

    if(weatherData.currentTemperature == null || weatherData.currentCondition == null){
      showToast("Hava durumu bilgisi alınamadı");
    }

    updateDisplayInfo(weatherData);
    setState(() {
      spinKitController = false;
    });
  }

  void packageInfoInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    // bununla versiyon bilgisini çekerim.

    setState(() {
      version = packageInfo!.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width / 5;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 80,
                  ),
                  Text(
                    "WordHive",
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 26),
                  ),
                  Text(
                    "İstediğini öğren.",
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 16),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Divider(
                        color: Colors.black,
                      )),
                  Container(
                    margin:
                        EdgeInsets.only(top: 50, right: 8, left: 8, bottom: 8),
                    child: InkWell(
                      onTap: () async {
                        _launchUrlGithub();
                      },
                      child: Text(
                        "Github",
                        style: TextStyle(
                            fontFamily: "RobotoLight",
                            fontSize: 16,
                            color: Color(PracticalMethod.HexaColorConvertColor(
                                "#0A588D"))),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height/5,),
                OutlinedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()));
                }, child: Text("Kullanıcı Girişi"),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(PracticalMethod.HexaColorConvertColor(
                        "#0A588D"))),
                    foregroundColor: Color(PracticalMethod.HexaColorConvertColor(
                        "#0A588D")),
                    backgroundColor: Colors.white60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "İletişim için hakanincim4@gmail.com"
                      "\n\nv$version",
                  style: TextStyle(
                      fontFamily: "RobotoLight",
                      fontSize: 14,
                      color: Color(
                          PracticalMethod.HexaColorConvertColor("#0A588D"))),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar(context, left: const FaIcon(
        FontAwesomeIcons.bars,
        color: Colors.black,
        size: 20,
      ), center: Image.asset("assets/images/logo.png"),
      leftWidgetOnClick: ()=>{_scaffoldKey.currentState?.openDrawer()}),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                langRadioButton(
                    screenSizeWidth: screenSizeWidth,
                    text: "İngilizce - Türkçe",
                    group: chooseLang,
                    value: Lang.eng),
                langRadioButton(
                    screenSizeWidth: screenSizeWidth,
                    text: "Türkçe - İngilizce",
                    value: Lang.tr,
                    group: chooseLang),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WordListPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Listelerim",
                      style: TextStyle(
                          fontSize: 28,
                          fontFamily: "Carter",
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(PracticalMethod.HexaColorConvertColor(
                                  "#2da2a6")),
                              Color(PracticalMethod.HexaColorConvertColor(
                                  "#476462")),
                            ],
                            tileMode: TileMode.repeated)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCard(context,
                          startColor: "#1DACC9",
                          endColor: "#0C33B2",
                          title: "Kelime\nKartları", click: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WordsCardsPage()));
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                           /* gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.black45,Colors.teal]
                            ) */
                          color: Colors.white
                        ),
                        child:Center(
                                  child: spinKitController? SpinKitFadingCircle(
                                    color: Colors.black,
                                    size: 75.0,
                                    duration: Duration(milliseconds: 1200),
                                  ) :
                                  Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.8,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: backGroundImage
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: weatherDisplayIcon
                                            ),
                                          ),
                                          Text("$temperature°", style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 4,
                                                  color: Colors.black,
                                                  offset: Offset(2, 2),
                                                ),
                                              ])),
                                          Text(city, style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 4,
                                                  color: Colors.black,
                                                  offset: Offset(2, 2),
                                                ),
                                              ])),
                                        ],
                                      )
                                  ),
                                )
                            )
                        ),
                  )
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildCard(
    BuildContext context, {
    @required String? startColor,
    @required String? endColor,
    @required String? title,
    @required Function ?click
  }) {
    return GestureDetector(
      onTap: () => click!(),
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title!,
                style: TextStyle(
                    fontSize: 28, fontFamily: "Carter", color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.file_copy,
                size: 32,
                color: Colors.white,
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(PracticalMethod.HexaColorConvertColor(startColor!)),
                  Color(PracticalMethod.HexaColorConvertColor(endColor!)),
                ],
                tileMode: TileMode.repeated)),
      ),
    );
  }

  Padding langRadioButton(
      {@required double? screenSizeWidth,
      @required String? text,
      @required Lang? value,
      @required Lang? group}) {
    // bunları kesin gönder diyorum yoksa doğru çalışmam.
    return Padding(
      padding: EdgeInsets.only(left: screenSizeWidth!),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title:
            Text(text!, style: TextStyle(fontFamily: "Carter", fontSize: 15)),
        leading: Radio<Lang>(
          value: value!,
          groupValue: group,
          onChanged: (Lang? value) {
            setState(() {
              chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
