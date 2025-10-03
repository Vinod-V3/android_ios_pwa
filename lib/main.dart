import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/details_page.dart';
import 'pages/storage_details_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/hybrid_storage_page.dart';
import 'pages/translation_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'pages/responsive_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map>('storageBox');
  await EasyLocalization.ensureInitialized();
  // runApp(const MyApp());
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const RootSelector(),
        '/home': (ctx) => const HomePage(),
        '/details': (ctx) => const DetailsPage(),
        '/storage': (ctx) => const StorageDetailsPage(),
        '/hybrid': (ctx) => const HybridStoragePage(),
        '/translation': (ctx) => TranslationPage(),
        '/responsive': (ctx) => ResponsivePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootSelector extends StatelessWidget {
  const RootSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Root /')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              child: const Text('Go to /home'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details'),
              child: const Text('Go to /details'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/storage'),
              child: const Text('Go to /storage'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/hybrid'),
              child: const Text('Go to /hybrid'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/translation'),
              child: const Text('Go to /translation'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/responsive'),
              child: const Text('Go to /responsive'),
            ),
          ],
        ),
      ),
    );
  }
}