import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tubes_prak_app/peminjaman.dart';

class TabelPeminjaman extends StatelessWidget {
  final PeminjamanService _peminjamanService = PeminjamanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      _peminjamanService.importPeminjamanFromCSV(context);
                    },
                    icon: Icon(
                      Icons.file_upload,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Text(
                        'Import File CSV',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('peminjaman')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                  List<DataRow> rows = [];
                  for (var document in documents) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    DataRow row = DataRow(
                      cells: [
                        DataCell(Text(data['available'] ?? '')),
                        DataCell(Text(data['fieldId'] ?? '')),
                        DataCell(Text(data['name'] ?? '')),
                        DataCell(Text(data['quantity']?.toString() ?? '')),
                        DataCell(Text(data['type'] ?? '')),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
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
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('REMOVE'),
                                        onPressed: () {
                                          _peminjamanService
                                              .deletePeminjaman(document.id);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Data successfully deleted'),
                                              duration: Duration(seconds: 5),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );

                    rows.add(row);
                  }

                  return DataTable(
                    columns: [
                      DataColumn(label: Text('Available')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: rows,
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
