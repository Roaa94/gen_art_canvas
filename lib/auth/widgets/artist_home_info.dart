import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';

class ArtistHomeInfo extends ConsumerWidget {
  const ArtistHomeInfo(
    this.artist, {
    super.key,
    this.onSignOut,
  });

  final Artist artist;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Welcome, '),
            Text(
              '${artist.nickname} 🧑🏻‍🎨!',
              style: const TextStyle(color: AppColors.primary),
            ),
            IconButton(
              onPressed: onSignOut,
              tooltip: 'Exit',
              iconSize: 15,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        if (artist.createdCuboidsCount > 0)
          Text(
            'Crafted cuboids: ${artist.createdCuboidsCount}',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: AppColors.firebaseYellow,
                ),
          ),
      ],
    );
  }
}
