import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/application/auth_service.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/auth/widgets/artist_nickname_dialog.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/presentation/widgets/cuboids_creator_bottom_sheet.dart';
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
      body: isAuthLoading
          ? const Center(child: CircularProgressIndicator())
          : authArtist == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GenArtCanvas',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    ArtistNicknameDialog(
                      onSubmit: (String nickname) => ref
                          .read(authServiceProvider)
                          .signArtistInAnonymously(nickname: nickname),
                      isLoading: isAuthLoading,
                    ),
                  ],
                )
              : ref.watch(cuboidsCanvasSettingsProvider).when(
                    data: (CuboidsCanvasSettings settings) => Column(
                      children: [
                        _buildArtistInfo(
                          context,
                          artist: authArtist,
                          onSignOut: () =>
                              ref.watch(authServiceProvider).signArtistOut(),
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
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
    );
  }

  Widget _buildArtistInfo(
    BuildContext context, {
    required Artist artist,
    VoidCallback? onSignOut,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Welcome, ',
                style: Theme.of(context).textTheme.bodySmall,
                children: <TextSpan>[
                  TextSpan(
                    text: '${artist.nickname}!',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          if (artist.createdCuboidsCount > 0)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Crafted cuboids: ${artist.createdCuboidsCount}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.googleBlue600,
                      ),
                ),
              ),
            ),
          TextButton.icon(
            onPressed: onSignOut,
            icon: const Icon(
              Icons.logout,
              size: 12,
            ),
            label: const Text(
              'Exit',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
