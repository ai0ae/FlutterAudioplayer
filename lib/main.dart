import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_audioplayer/common/themes/themes.dart';
import 'package:flutter_application_audioplayer/common/utils/translation.dart';
import 'package:flutter_application_audioplayer/features/home/screen/home_screen.dart';
import 'package:flutter_application_audioplayer/features/login/service/firebase_signin.dart';
import 'package:flutter_application_audioplayer/models/user.dart';
import 'package:flutter_application_audioplayer/providers/favorites_provider.dart';
import 'package:flutter_application_audioplayer/providers/theme_provider.dart';
import 'package:flutter_application_audioplayer/providers/user_provider.dart';
import 'package:flutter_application_audioplayer/routes.dart';
import 'package:flutter_application_audioplayer/constansts/const.dart';
import 'package:flutter_application_audioplayer/features/login/screen/login_screen.dart';
import 'package:flutter_application_audioplayer/common/widgets/custom_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loader.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final themeData = sharedPreferences.getString(kThemeKey);
    ThemeData theme;
    if (themeData != null) {
      theme = getThemeFromEnum(ThemeType.values.byName(themeData));
    } else {
      theme = lightTheme;
    }
  runApp(MultiProvider(providers: [
    //Implement the Provider package to manage the state of your Flutter application. //Implement more than one type of Provider to demonstrate your understanding of the package
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(create: (context) => FavoritesProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider(initialTheme: theme),),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  final auth =
      FirebaseAuthMethods(FirebaseAuth.instance, FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: Provider.of<ThemeProvider>(context).currentTheme,
      title: 'Audio player',
      home: FutureBuilder(
        future: auth.getCurrentUserData(),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: const Loader());
          } else {
            if (snapshot.hasError) {
              return ErrorScreen(
                error: snapshot.error.toString(),
              );
            } else {
              if (snapshot.data != null) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUserFromModel(snapshot.data!);
                return HomeScreen();
              }
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _sectionButton('Log in', () {}),
            const SizedBox(
              height: 28,
            ),
            CustomText(
              text: 'or',
              weight: FontWeight.w200,
            ),
            const SizedBox(
              height: 28,
            ),
            _sectionButton('Sign up', () {}),
          ],
        ),
      ),
    );
  }

  GestureDetector _sectionButton(String text, GestureTapCallback ontap) =>
      GestureDetector(
          onTap: ontap,
          child: Container(
              alignment: Alignment.center,
              width: 264,
              height: 70,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              child: CustomText(
                text: text,
                weight: FontWeight.w200,
              )));
}


