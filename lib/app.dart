import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/auth/application/auth_service.dart';
import 'package:gen_art_canvas/core/style/app_themes.dart';
import 'package:gen_art_canvas/home_page.dart';

class GenArtCanvasApp extends ConsumerWidget {
  const GenArtCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'GenArtCanvas',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.theme,
      themeMode: ThemeMode.dark,
      home: const HomePage(),
      // home: ref.watch(authArtistProvider).when(
      //       data: (Artist? authArtist) => HomePage(
      //         authArtist: authArtist,
      //       ),
      //       error: (e, _) {
      //         log('An error occurred while loading authenticated artist');
      //         log(e.toString());
      //
      //         return const Scaffold(
      //           body: Center(
      //             child: Text('An Error Occurred!'),
      //           ),
      //         );
      //       },
      //       loading: () => const Scaffold(),
      //     ),
    );
  }
}
