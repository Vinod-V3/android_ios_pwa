import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  final String pdfUrl = "https://bmzbbujw9kal.cb26c.pdf"; // give valid downloadable url here

  Future<void> _downloadAndSharePdf(BuildContext context) async {
    if (kIsWeb) {
      _showWebDialog(context);
      return;
    }

    try {
      // Download PDF
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        // Save to temp directory
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/shared.pdf');
        await file.writeAsBytes(response.bodyBytes);

        // Share file
        await Share.shareXFiles(
          [XFile(file.path)],
          text: "Here is the PDF file",
          subject: "Shared PDF",
        );
      } else {
        _showError(context, "Failed to download PDF (status ${response.statusCode})");
      }
    } catch (e) {
      _showError(context, "Error: $e");
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showWebDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Share PDF"),
          content: SelectableText(pdfUrl),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: pdfUrl));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Link copied to clipboard")),
                );
              },
              child: const Text("Copy"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('/details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _downloadAndSharePdf(context),
          child: const Text("Share PDF"),
        ),
      ),
    );
  }
}
