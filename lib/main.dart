import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'authentication.dart';
import 'emailogin.dart';
import 'mobilenumber.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.isMobile});
  final bool? isMobile;
  @override
  HomePageState createState() => HomePageState();
}

UserModel userModel = UserModel();

class HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jay"),
      ),
      body: Column(
        children: [
          if (_isLoggedIn != false)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userModel.url),
              ),
            ),
          if (_isLoggedIn != false) Text(userModel.name),
          if (_isLoggedIn != false) Text(userModel.email),
          if (widget.isMobile != null) const Text("Login with mobile number"),

          /*  Image.network(_userObj["picture"]["data"]["url"]),
          Text(_userObj["email"]),*/
          if (_isLoggedIn != false || widget.isMobile != null)
            TextButton(
                onPressed: () {
                  // signInWithFacebook();
                  FacebookAuth.instance.logOut();
                  FirebaseAuth.instance.signOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                    });
                  });
                },
                child: const Text("Logout")),
          Column(
            children: [
              Center(
                child: ElevatedButton(
                  child: const Text("Login with Facebook"),
                  onPressed: () async {
                    facebookSignIn().then((value) {
                      User? user = value!.user;
                      userModel.name = user!.displayName.toString();
                      userModel.email = user.email.toString();
                      userModel.url = user.photoURL.toString();

                      setState(() {
                        _isLoggedIn = true;
                      });
                    });

                    // FacebookAuth.instance.login(
                    //     permissions: ['email', 'public_profile'])
                    //     .then((value) {
                    //   FacebookAuth.instance.getUserData().then((userData) {
                    //     setState(() {
                    //
                    // _userObj = userData;
                    // });
                    //   });
                    // });
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text("Login with Google"),
                  onPressed: () async {
                    googleSignIn().then((value) {
                      User? user = value!.user;
                      userModel.name = user!.displayName.toString();
                      userModel.email = user.email.toString();
                      userModel.url = user.photoURL.toString();
                      setState(() {
                        _isLoggedIn = true;
                      });
                      if (kDebugMode) {
                        print("after login $_isLoggedIn");
                      }
                    });
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text("Ligin via mobile"),
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text("Ligin via email And password"),
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginEmail()));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserModel {
  String? _name;
  String? _email;
  String? _url;

  String get name => _name!;

  set name(String value) => _name = value;

  String get email => _email!;

  set email(String value) => _email = value;

  String get url => _url!;

  set url(String value) => _url = value;
}
