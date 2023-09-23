import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/auth/data/auth_service.dart';
import 'package:gen_art_canvas/auth/widgets/artist_nickname_dialog.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_creator_bottom_sheet.dart';
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

  void _showCreatorBottomSheet(
    BuildContext context,
    CuboidsCanvasSettings settings,
  ) {
    if (widget.authArtist == null) {
      log('Auth artist not found!');
      return;
    }
    final screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth:
            screenSize.width > 1200 ? screenSize.width * 0.6 : double.infinity,
        maxHeight: screenSize.height * 0.8,
      ),
      builder: (context) => CuboidsCreatorBottomSheet(
        settings: settings,
        authArtist: widget.authArtist!,
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
      body: ref.watch(cuboidsCanvasSettingsProvider).when(
            data: (CuboidsCanvasSettings settings) => Stack(
              children: [
                CuboidsGenArtCanvas(
                  settings: settings,
                  initialGap: MediaQuery.of(context).size.width * 0.02,
                  cuboidsData: cuboids,
                ),
                if (widget.authArtist != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    left: 5,
                    child: Row(
                      children: [
                        const Text('Welcome, '),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            '${widget.authArtist!.nickname} 🧑🏻‍🎨!',
                            style: const TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: widget.authArtist == null
                          ? () => _showNicknameDialog(context)
                          : () => _showCreatorBottomSheet(context, settings),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.firebaseDarkGrey,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: const Text('Start Creating 🎨'),
                      ),
                    ),
                  ),
                ),
              ],
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
