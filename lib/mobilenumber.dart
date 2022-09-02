import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: const Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+91'),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: controller,
              ),
            )
          ]),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OTPScreen(controller.text)));
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen(this.phone, {super.key});
  @override
  OTPScreenState createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +91-${widget.phone}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              onSubmitted: (val) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode!, smsCode: val))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(isMobile: true)));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    ///
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          /// in this function we can auto validate mobile without tap button

          // await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
          //   if (value.user != null) {
          //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
          //   }
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}
