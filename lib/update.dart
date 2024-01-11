import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tubes_prak_app/homepage.dart';
import 'package:tubes_prak_app/rounded_button.dart';

late User loggedInUser = FirebaseAuth.instance.currentUser!;

class UpdateBulu extends StatefulWidget {
  @override
  UpdateBuluState createState() => UpdateBuluState();
}

class UpdateBuluState extends State<UpdateBulu> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController lapangController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  String selectedStatus = 'Booked';
  String selectedLapang = 'Lapang 1';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference booking = firestore.collection('booking');

    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Set initial values from arguments
    if (args != null) {
      lapangController.text = args['lapang'] ?? '';
      statusController.text = args['status'] ?? '';
      startTimeController.text = args['startTime'] ?? '';
      endTimeController.text = args['endTime'] ?? '';
    }

    String documentId = args?['documentId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'home');
          },
        ),
        title: Text('Booking Lapangan'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: selectedLapang,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLapang = newValue!;
                  });
                },
                items: <String>[
                  'Lapang 1',
                  'Lapang 2',
                  'Lapang 3',
                  'Lapang 4',
                  'Lapang 5'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Lapang'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                items: <String>['Booked', 'Cancel', 'Done']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 16.0),
              SizedBox(height: 8.0),
              Container(
                height: 56.0,
                child: TextField(
                  controller: startTimeController,
                  decoration: InputDecoration(
                      labelText: 'Start Time (yyyy-MM-dd HH:mm:ss)'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 56.0,
                child: TextField(
                  controller: endTimeController,
                  decoration: InputDecoration(
                      labelText: 'End Time (yyyy-MM-dd HH:mm:ss)'),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 8.0),
              // Button to edit data
              RoundedButton(
                colour: Color.fromARGB(255, 206, 74, 12),
                title: 'Edit Data',
                onPressed: () async {
                  // Show AlertDialog with loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Editing Data...'),
                          ],
                        ),
                      );
                    },
                  );

                  booking.doc(documentId).update({
                    'lapang': selectedLapang,
                    'status': selectedStatus,
                    'startTime': startTimeController.text,
                    'endTime': endTimeController.text,
                  });

                  // Clear controllers

                  startTimeController.text = '';
                  endTimeController.text = '';

                  // Close the AlertDialog
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
