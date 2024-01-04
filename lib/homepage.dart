import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_prak_app/login.dart';

class HomePage extends StatefulWidget {
  final bool useMaterial3;
  const HomePage({
    Key? key,
    this.useMaterial3 = false,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    bool _isSendingVerification = false;
    
    var _currentIndex = 0;
    final _auth = FirebaseAuth.instance;

    late User _currentUser;

    @override
    void initState() {
      super.initState();
    }

    

    Color primaryColor = widget.useMaterial3 ? Colors.blue : Colors.blueAccent;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Si Bulu',
            style: TextStyle(
              fontSize: 32,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Welcome to Si Bulu Home',
            style: TextStyle(
              fontSize: 24,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            elevation: widget.useMaterial3 ? 2.0 : 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Content',
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'This is the content of your card. You can customize it as needed.',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              //* Button Action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Click Me'),
          ),
          const SizedBox(height: 4.0),
          const Divider(
            height: 16,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
