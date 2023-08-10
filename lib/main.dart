import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/splash_screen.dart';
import 'package:kelimeezberle/utils/service_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: ServiceUtils.apiKey,
          appId: ServiceUtils.appId,
          messagingSenderId: ServiceUtils.messagingSenderId,
          projectId: ServiceUtils.projectId,
          storageBucket: ServiceUtils.storageBucket)
    );
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelime Ezberle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}