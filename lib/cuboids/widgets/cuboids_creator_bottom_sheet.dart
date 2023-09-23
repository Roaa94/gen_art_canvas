import 'package:flutter/material.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsCreatorBottomSheet extends StatelessWidget {
  const CuboidsCreatorBottomSheet({
    super.key,
    required this.settings,
    required this.authArtist,
  });

  final CuboidsCanvasSettings settings;
  final Artist authArtist;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Create your cuboid'),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit Cuboid'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
