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
          IconButton(
            alignment: Alignment.topRight,
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookingSearchDelegate(),
              );
            },
          ),
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

class BookingSearchDelegate extends SearchDelegate<String> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference booking =
      FirebaseFirestore.instance.collection('booking');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Please enter a search query'));
    }

    return FutureBuilder(
      future: booking.where('lapang', isEqualTo: query).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No results found'));
        }

        return ListView(
          children: snapshot.data!.docs.map((e) {
            return GestureDetector(
              child: ItemCard(
                (e.data() as dynamic)['startTime']?.toString() ?? 'null',
                (e.data() as dynamic)['endTime']?.toString() ?? 'null',
                (e.data() as dynamic)['lapang'].toString() ?? 'null',
                (e.data() as dynamic)['status'] ?? 'N/A',
                e.id,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Please enter a search query'));
    }

    return FutureBuilder(
      future: booking
          .where('lapang', isGreaterThanOrEqualTo: query)
          .where('lapang', isLessThan: query + 'z')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No suggestions'));
        }

        return ListView(
          children: snapshot.data!.docs.map((e) {
            return GestureDetector(
              child: ItemCard(
                (e.data() as dynamic)['startTime']?.toString() ?? 'null',
                (e.data() as dynamic)['endTime']?.toString() ?? 'null',
                (e.data() as dynamic)['lapang'].toString() ?? 'null',
                (e.data() as dynamic)['status'] ?? 'N/A',
                e.id,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
