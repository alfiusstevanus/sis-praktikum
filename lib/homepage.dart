import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tubes_prak_app/item_card.dart';
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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference booking = firestore.collection('booking');

    Future<Widget> getDataFromReference(DocumentSnapshot document) async {
      try {
        return ItemCard(
          (document.data() as dynamic)['startTime']?.toString() ?? 'null',
          (document.data() as dynamic)['endTime']?.toString() ?? 'null',
          (document.data() as dynamic)['lapang'].toString() ?? 'null',
          (document.data() as dynamic)['status'] ?? 'N/A',
          document.id,
        );
      } catch (error) {
        return Text('Error: $error');
      }
    }

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
          const SizedBox(height: 40.0),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        //view data here
                        StreamBuilder(
                          stream: booking.snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: snapshot.data!.docs.map((e) {
                                  return FutureBuilder(
                                    future: getDataFromReference(e),
                                    builder: (_, dataSnap) {
                                      if (dataSnap.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (dataSnap.hasError) {
                                        return Text('Error: ${dataSnap.error}');
                                      } else {
                                        // Use the data to create ItemCard
                                        return dataSnap.data as Widget;
                                      }
                                    },
                                  );
                                }).toList() as List<Widget>,
                              );
                            } else {
                              return Text('Loading');
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              //* Button Action
              Navigator.pushReplacementNamed(context, 'booking');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Book Now'),
          ),
          const SizedBox(height: 10.0),
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
