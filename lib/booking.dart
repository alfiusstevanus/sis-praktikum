// import 'dart:js_interop';
// import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:tubes_prak_app/rounded_button.dart';

late User loggedInUser;

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  // final _auth = FirebaseAuth.instance;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController lapangController = TextEditingController();

  String selectedStatus = 'Booked';
  String selectedLapang = 'Lapang 1';
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference booking = firestore.collection('booking');

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
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 56.0,
                child: TextField(
                  controller: startTimeController,
                  decoration: InputDecoration(
                      labelText: 'Start Time (yyyy-MM-dd HH:mm:ss)'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 56.0,
                child: TextField(
                  controller: endTimeController,
                  decoration: InputDecoration(
                      labelText: 'End Time (yyyy-MM-dd HH:mm:ss)'),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Booking',
                onPressed: () {
                  booking.add({
                    'startTime': startTimeController.text,
                    'endTime': endTimeController.text,
                    'lapang': selectedLapang,
                    'status': selectedStatus
                  });
                  startTimeController.text = '';
                  endTimeController.text = '';

                  //navigate back to the dataMhs page
                  Navigator.pushReplacementNamed(context, 'home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
