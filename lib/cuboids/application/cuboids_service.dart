import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artists_repository.dart';
import 'package:gen_art_canvas/cuboids/data/cuboids_repository.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/presentation/cuboid_form_data.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings_provider.dart';

class CuboidsService {
  CuboidsService(
    this._cuboidsRepository,
    this._artistsRepository,
  );

  final CuboidsRepository _cuboidsRepository;
  final ArtistsRepository _artistsRepository;

  Future<void> addCuboid({
    required String artistId,
    required CuboidFormData formData,
  }) async {
    try {
      await _cuboidsRepository.addCuboid(
        artistId: artistId,
        topFace:
            CuboidFace.fromValidFormData(formData[CuboidFaceDirection.top]!),
        rightFace:
            CuboidFace.fromValidFormData(formData[CuboidFaceDirection.right]!),
        leftFace:
            CuboidFace.fromValidFormData(formData[CuboidFaceDirection.left]!),
      );
      final artist = await _artistsRepository.getArtist(artistId);
      if (artist != null) {
        await _artistsRepository.updateArtist(
          id: artist.id,
          createdCuboidsCount: artist.createdCuboidsCount + 1,
        );
      }
    } catch (e) {
      log('An error occurred while adding cuboid!');
      log(e.toString());
    }
  }

  Stream<List<Cuboid>> watchCuboids({int limit = 1}) {
    return _cuboidsRepository.watchCuboids(limit: limit).map(
          (cuboids) => cuboids.where((cuboid) => cuboid.isValid).toList(),
        );
  }
}

final cuboidsServiceProvider = Provider<CuboidsService>((ref) {
  return CuboidsService(
    ref.watch(cuboidsRepositoryProvider),
    ref.watch(artistsRepositoryProvider),
  );
});

final cuboidsProvider = StreamProvider<List<Cuboid>>((ref) {
  final settings = ref.watch(cuboidsCanvasSettingsProvider).value;
  return ref
      .watch(cuboidsServiceProvider)
      .watchCuboids(limit: settings?.cuboidsTotalCount ?? 1);
});
