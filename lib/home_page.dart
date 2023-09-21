import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_art_canvas/gen_art_canvas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const padding = 50.0;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(padding),
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: GenArtCanvas(
          size: Size(
            screenSize.width - padding * 2,
            screenSize.height - padding * 2,
          ),
        ),
      ),
    );
  }
}
