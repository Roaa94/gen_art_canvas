import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/cuboids_gen_art_canvas.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(cuboidsCanvasSettingsProvider).when(
            data: (data) => CuboidsGenArtCanvas(
              settings: data ?? const CuboidsCanvasSettings(),
              initialGap: MediaQuery.of(context).size.width * 0.02,
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
