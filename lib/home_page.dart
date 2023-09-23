import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids_gen_art_canvas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          margin: const EdgeInsets.all(100),
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: CuboidsGenArtCanvas(),
        ),
      ),
    );
  }
}
