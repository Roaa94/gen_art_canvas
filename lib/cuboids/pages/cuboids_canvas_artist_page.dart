import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/application/auth_service.dart';
import 'package:gen_art_canvas/auth/widgets/artist_home_info.dart';
import 'package:gen_art_canvas/auth/widgets/artist_nickname_dialog.dart';
import 'package:gen_art_canvas/cuboids/widgets/cuboids_creator_bottom_sheet.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class CuboidsCanvasArtistPage extends ConsumerWidget {
  const CuboidsCanvasArtistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(cuboidsCanvasSettingsProvider).isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final authArtist = ref.watch(authArtistProvider).value;
    final isAuthLoading = ref.watch(authArtistProvider).isLoading;

    return Scaffold(
      body: authArtist == null
          ? ArtistNicknameDialog(
              onSubmit: (String nickname) => ref
                  .read(authServiceProvider)
                  .signArtistInAnonymously(nickname: nickname),
              isLoading: isAuthLoading,
            )
          : ref.watch(cuboidsCanvasSettingsProvider).when(
                data: (CuboidsCanvasSettings settings) => Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 20, left: 10),
                      child: ArtistHomeInfo(
                        authArtist,
                        onSignOut: () =>
                            ref.watch(authServiceProvider).signArtistOut(),
                      ),
                    ),
                    Expanded(
                      child: CuboidsCreatorBottomSheet(
                        settings: settings,
                        authArtist: authArtist,
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
