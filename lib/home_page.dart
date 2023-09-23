import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/auth/data/auth_service.dart';
import 'package:gen_art_canvas/auth/widgets/artist_nickname_dialog.dart';
import 'package:gen_art_canvas/data.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_gen_art_canvas.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    this.authArtist,
  });

  final Artist? authArtist;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _showNicknameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ArtistNicknameDialog(
        onSubmit: (String nickname) => ref
            .read(authServiceProvider)
            .signArtistInAnonymously(nickname: nickname),
      ),
    );
  }

  @override
  void initState() {
    if (widget.authArtist == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNicknameDialog(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCuboidsGenArtCanvas(),
          if (widget.authArtist == null)
            Positioned(
              left: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: ElevatedButton(
                child: const Text('Start Creating 🎨'),
                onPressed: () => _showNicknameDialog(context),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCuboidsGenArtCanvas() {
    return ref.watch(cuboidsCanvasSettingsProvider).when(
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
        );
  }
}
