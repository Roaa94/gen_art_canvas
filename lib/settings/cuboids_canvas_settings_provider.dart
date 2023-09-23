import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/settings/canvas_settings_repository.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

final cuboidsCanvasSettingsProvider =
    StreamProvider<CuboidsCanvasSettings>((ref) {
  final settingsRepository = ref.watch(canvasSettingsRepositoryProvider);
  return settingsRepository.watchCuboidsCanvasSettings();
});
