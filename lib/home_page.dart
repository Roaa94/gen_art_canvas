import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids_gen_art_canvas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const ratio = 1080/1920;
    return Scaffold(
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * ratio,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: CuboidsGenArtCanvas(),
            ),
          ),
        ),
      ),
    );
  }
}
