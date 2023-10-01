import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/core/style/app_themes.dart';
import 'package:gen_art_canvas/cuboids/presentation/pages/cuboids_canvas_artist_page.dart';
import 'package:gen_art_canvas/cuboids/presentation/pages/cuboids_canvas_home_page.dart';

class GenArtCanvasApp extends ConsumerWidget {
  const GenArtCanvasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 1200;

    return MaterialApp(
      title: 'GenArtCanvas',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.theme,
      themeMode: ThemeMode.dark,
      home: isSmallScreen
          ? const CuboidsCanvasArtistPage()
          : const CuboidsCanvasHomePage(),
    );
  }
}
