import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:asset_registration/providers/assetRegisterModel.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'constant/routes.dart';
import 'providers/MetamaskProvider.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (context) => assetRegisterModel(),
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     navigatorObservers: [FlutterSmartDialog.observer],
    //     builder: FlutterSmartDialog.init(),
    //     home: home_page(),
    //   ),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<assetRegisterModel>(
          create: (context) => assetRegisterModel(),
        ),
        ChangeNotifierProvider<MetaMaskProvider>(
          create: (context) => MetaMaskProvider()..init(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        // home: home_page(),
      ),
    );
  }
}
