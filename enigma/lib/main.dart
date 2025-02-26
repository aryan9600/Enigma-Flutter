import 'package:enigma/providers/auth.dart';
import 'package:enigma/screens/auth_screen.dart';
import 'package:enigma/screens/leaderboard_screen.dart';
import 'package:enigma/screens/profile_screen.dart';
import 'package:enigma/screens/profile_setup.dart';
import 'package:enigma/screens/question_screen.dart';
import 'package:enigma/screens/rules_initial_screen.dart';
import 'package:enigma/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/rules_screen.dart';
import 'package:provider/provider.dart';

void main() async{

	await SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
		DeviceOrientation.portraitDown
	]);

	runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Enigma 6.0',
          home: auth.isAuth
            ?
            QuestionScreen()
            :
            FutureBuilder(
              future: auth.autoLogin(),
              builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen()
        ),
          routes: {
            AuthScreen.routeName : (ctx) => AuthScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            ProfileSetupScreen.routeName: (ctx) => ProfileSetupScreen(),
            LeaderBoardScreen.routeName: (ctx) => LeaderBoardScreen(),
            QuestionScreen.routeName: (ctx) => QuestionScreen(),
            RulesScreen.routeName: (ctx) => RulesScreen(),
            RulesInitialScreen.routeName: (ctx) => RulesInitialScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Enigma 6.0!", style: TextStyle(fontSize: 30),),
      ),
    );
  }
}
