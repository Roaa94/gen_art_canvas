import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/data.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_gen_art_canvas.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(cuboidsCanvasSettingsProvider).when(
            data: (CuboidsCanvasSettings settings) => CuboidsGenArtCanvas(
              settings: settings,
              initialGap: MediaQuery.of(context).size.width * 0.02,
              cuboidsData: cuboids,
            ),
            error: (e, _) {
              log('Error fetching cuboids canvas settings');
              log(e.toString());
              return const Center(child: Text('An error occurred!'));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
