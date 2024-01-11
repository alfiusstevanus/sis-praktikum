import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String lapang;
  final String status;
  final String documentId;

  ItemCard(
      this.startTime, this.endTime, this.lapang, this.status, this.documentId);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference booking = firestore.collection('booking');

    return Container(
      width: double.infinity,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  lapang,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Waktu mulai: $startTime",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Waktu selesai: $endTime",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Status : $status",
                style: TextStyle(fontSize: 14),
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(60, 40),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'update',
                        arguments: {
                          'lapang': lapang,
                          'status': status,
                          'startTime': startTime,
                          'endTime': endTime,
                          'documentId': documentId,
                        },
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(60, 40),
                    ),
                    child: const Center(
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Warning"),
                            content: const Text("Remove this data?"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("CANCEL"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Remove"),
                                onPressed: () {
                                  booking.doc(documentId).delete();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
