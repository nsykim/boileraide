import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseManagementWidget extends StatelessWidget {
  const DatabaseManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _deleteDatabaseFile(context);
      },
      child: Text('Delete Database File'),
    );
  }

  Future<void> _deleteDatabaseFile(BuildContext context) async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final dbPath = '${appDocumentDir.path}/chat_database.db';
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database file deleted successfully.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database file not found.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting database file: $e'),
        ),
      );
    }
  }
}
