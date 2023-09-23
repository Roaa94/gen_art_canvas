import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artist.dart';
import 'package:gen_art_canvas/auth/data/artists_repository.dart';
import 'package:gen_art_canvas/auth/data/auth_repository.dart';

class AuthService {
  AuthService(
    this._authRepository,
    this._artistsRepository,
  );

  final AuthRepository _authRepository;
  final ArtistsRepository _artistsRepository;

  Stream<Artist?> watchAuthArtist() {
    return _authRepository.watchUser().asyncMap((user) async {
      if (user == null) return null;
      return await _artistsRepository.getArtist(user.uid);
    });
  }

  Future<Artist?> signArtistInAnonymously({
    required String nickname,
  }) async {
    final user = await _authRepository.signInAnonymously();
    if (user != null) {
      await _artistsRepository.addArtist(uid: user.uid, nickname: nickname);
    }
    return null;
  }

  Future<void> signArtistOut() async {
    final user = _authRepository.currentUser;
    if (user != null) {
      await _artistsRepository.deleteArtist(user.uid);
      await _authRepository.signOut();
    }
  }
}

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    ref.watch(authRepositoryProvider),
    ref.watch(artistsRepositoryProvider),
  ),
);

final authArtistProvider = StreamProvider<Artist?>((ref) {
  return ref.watch(authServiceProvider).watchAuthArtist();
});
