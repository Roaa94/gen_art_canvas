import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/models/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/cuboids_gen_art_canvas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CuboidsGenArtCanvas(
        settings: const CuboidsCanvasSettings(),
        initialGap: MediaQuery.of(context).size.width * 0.02,
      ),
    );
  }
}
