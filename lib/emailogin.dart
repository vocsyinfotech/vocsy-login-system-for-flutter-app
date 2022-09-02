import 'package:flutter/material.dart';

import 'authentication.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({Key? key}) : super(key: key);

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with email and paassword'),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(
              // border: InputBorder.none,
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(
              // border: InputBorder.none,
              hintText: 'password',
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                emailLogin(email: email.text, password: password.text).then((value) {
                  print('Hello this is done $value');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
