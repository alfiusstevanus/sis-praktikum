// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tubes_prak_app/rounded_button.dart';

import '../validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailTextController = TextEditingController();
  final _focusEmail = FocusNode();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: Text('My Profile', style: TextStyle(color: Colors.orange)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Enter your email and we will send you a link to reset password',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                    ),
                    hintText: "Email",
                    filled: true,
                  ),
                ),
              ),
              RoundedButton(
                colour: Color.fromARGB(255, 72, 72, 72),
                title: "Confirm",
                onPressed: passwordReset, // Pass the function as a callback
              )
            ],
          ),
        ),
      ),
    );
  }
}
