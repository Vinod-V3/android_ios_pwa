import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/sample_json.dart';

class StorageDetailsPage extends StatelessWidget {
  const StorageDetailsPage({super.key});
  Future<void> _storeData() async {
    var box = Hive.box<Map>('storageBox');
    await box.put(sampleJsonData["_id"], sampleJsonData);
  }

  Future<void> _fetchData(BuildContext context) async {
    var box = Hive.box<Map>('storageBox');
    var data = box.get(sampleJsonData["_id"]);
    debugPrint("Local Data $data");

    if (data != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(data["title"] ?? "No Title"),
          content: Text(
              "Description: ${data["description"]}\n\nStatus: ${data["status"]}"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Close"))
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No data found for this ID")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Storage Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _storeData,
              child: Text("Store JSON Data"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _fetchData(context),
              child: Text("Fetch JSON Data"),
            ),
          ],
        ),
      ),
    );
  }
}
