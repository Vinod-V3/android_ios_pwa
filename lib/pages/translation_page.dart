import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TranslationPage extends StatelessWidget {
  const TranslationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("description".tr()),
            SizedBox(height: 20),

            DropdownButton<Locale>(
              value: context.locale,
              items: [
                DropdownMenuItem(
                  child: Text("English"),
                  value: Locale('en'),
                ),
                DropdownMenuItem(
                  child: Text("हिन्दी"),
                  value: Locale('hi'),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
