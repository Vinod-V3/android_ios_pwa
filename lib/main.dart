import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/details_page.dart';

void main() {
  runApp(const MyApp());
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
      initialRoute: '/',
      routes: {
        '/': (ctx) => const RootSelector(),
        '/home': (ctx) => const HomePage(),
        '/details': (ctx) => const DetailsPage(),
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
          ],
        ),
      ),
    );
  }
}