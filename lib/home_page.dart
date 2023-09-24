import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/auth/application/auth_service.dart';
import 'package:gen_art_canvas/auth/widgets/artist_home_info.dart';
import 'package:gen_art_canvas/auth/widgets/artist_nickname_dialog.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/application/cuboids_service.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_creator_bottom_sheet.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_gen_art_canvas.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

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
    Artist authArtist,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => CuboidsCreatorBottomSheet(
        settings: settings,
        authArtist: authArtist,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authArtist = ref.watch(authArtistProvider).value;
    final cuboids = ref.watch(cuboidsProvider).value;

    return Scaffold(
      body: ref.watch(cuboidsCanvasSettingsProvider).when(
            data: (CuboidsCanvasSettings settings) => Stack(
              children: [
                CuboidsGenArtCanvas(
                  settings: settings,
                  initialGap: MediaQuery.of(context).size.width * 0.02,
                  cuboidsData: cuboids?.reversed.toList() ?? [],
                ),
                if (authArtist != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 5,
                    left: 10,
                    child: ArtistHomeInfo(
                      authArtist,
                      onSignOut: () =>
                          ref.watch(authServiceProvider).signArtistOut(),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: authArtist == null
                          ? () => _showNicknameDialog(context)
                          : () => _showCreatorBottomSheet(
                                context,
                                settings,
                                authArtist,
                              ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
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
