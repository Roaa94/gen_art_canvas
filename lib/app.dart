
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/home_page.dart';

class GenArtCanvasApp extends StatelessWidget {
  const GenArtCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenArtCanvas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
