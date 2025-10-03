import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class HybridStoragePage extends StatefulWidget {
  const HybridStoragePage({super.key});

  @override
  State<HybridStoragePage> createState() => _HybridStoragePageState();
}

class _HybridStoragePageState extends State<HybridStoragePage> {
  late Box<Map> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Map>('storageBox');
  }

  // Add a new entry
  Future<void> _addEntry() async {
    try {
      // Pick any file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: kIsWeb, // if web, read as bytes
      );

      if (result == null) return; // user canceled

      String _id = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = result.files.single.name;

      String? filePath;

      if (kIsWeb) {
        // Web: store bytes in IndexedDB (Hive metadata contains base64)
        Uint8List bytes = result.files.single.bytes!;
        filePath = 'data:base64,' + base64Encode(bytes);
      } else {
        // Mobile: store file on disk
        final dir = await getApplicationDocumentsDirectory();
        File file = File('${dir.path}/$_id\_$fileName');
        await file.writeAsBytes(result.files.single.bytes! ??
            await File(result.files.single.path!).readAsBytes());
        filePath = file.path;
      }

      // Metadata
      final Map<String, dynamic> metadata = {
        "_id": _id,
        "title": fileName,
        "description": "Stored via Hybrid Storage",
        "status": "new",
        "filePath": filePath,
        "fileType": result.files.single.extension ?? "unknown"
      };

      await box.put(_id, metadata);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry stored successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Fetch & show entry details
  Future<void> _viewEntry(Map data) async {
    String fileContent = '';
    if (kIsWeb) {
      if (data['filePath'] != null && data['filePath'].startsWith('data:base64,')) {
        final base64Str = data['filePath'].substring('data:base64,'.length);
        fileContent = utf8.decode(base64Decode(base64Str));
      }
    } else {
      if (data['filePath'] != null) {
        File file = File(data['filePath']);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          fileContent = utf8.decode(bytes);
        }
      }
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(data['title']),
              content: SingleChildScrollView(
                  child: Text(
                      "Description: ${data['description']}\nStatus: ${data['status']}\nFileType: ${data['fileType']}\n\nFile Content Preview:\n$fileContent")),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"))
              ],
            ));
  }

  // Delete entry
  Future<void> _deleteEntry(Map data) async {
    if (!kIsWeb && data['filePath'] != null) {
      File file = File(data['filePath']);
      if (await file.exists()) await file.delete();
    }
    await box.delete(data['_id']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final entries = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("/hybrid")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addEntry,
              child: const Text("Add New Entry (File/JSON)"),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text("No entries stored"))
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final data = entries[index];
                      return ListTile(
                        title: Text(data['title'] ?? 'No Title'),
                        subtitle: Text("Status: ${data['status']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () => _viewEntry(data),
                                icon: const Icon(Icons.visibility)),
                            IconButton(
                                onPressed: () => _deleteEntry(data),
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
