import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Peminjaman {
  String available;
  String fieldId;
  String name;
  var quantity;
  String type;

  Peminjaman({
    required this.available,
    required this.fieldId,
    required this.name,
    required this.quantity,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'available': available,
      'fieldId': fieldId,
      'name': name,
      'quantity': quantity,
      'type': type,
    };
  }
}

class PeminjamanService {
  final CollectionReference _peminjamanCollection =
      FirebaseFirestore.instance.collection('peminjaman');

  Future<void> importPeminjamanFromCSV(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String csvString = utf8.decode(file.bytes!);
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

      for (List<dynamic> row in csvTable) {
        Peminjaman peminjaman = Peminjaman(
          available: row[0] as String,
          fieldId: row[1] as String,
          name: row[2] as String,
          quantity: row[3],
          type: row[4] as String,
        );

        await _peminjamanCollection.add(peminjaman.toMap());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Peminjaman Berhasil Diimpor'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  Future<void> deletePeminjaman(String documentId) async {
    await _peminjamanCollection.doc(documentId).delete();
  }
}
