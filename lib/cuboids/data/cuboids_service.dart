import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artists_repository.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/data/cuboids_repository.dart';

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
        topFace: CuboidFace.fromFormData(formData[CuboidFaceDirection.top]!),
        rightFace:
            CuboidFace.fromFormData(formData[CuboidFaceDirection.right]!),
        leftFace: CuboidFace.fromFormData(formData[CuboidFaceDirection.left]!),
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
}

final cuboidsServiceProvider = Provider<CuboidsService>((ref) {
  return CuboidsService(
    ref.watch(cuboidsRepositoryProvider),
    ref.watch(artistsRepositoryProvider),
  );
});
