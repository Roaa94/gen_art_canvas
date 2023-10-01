import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/data/artists_repository.dart';
import 'package:gen_art_canvas/auth/data/auth_repository.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';

class AuthService {
  AuthService(
    this._authRepository,
    this._artistsRepository,
  );

  final AuthRepository _authRepository;
  final ArtistsRepository _artistsRepository;

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

final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).watchUser(),
);

final authArtistProvider = StreamProvider<Artist?>((ref) {
  final authUser = ref.watch(authUserProvider).value;
  if (authUser != null) {
    return ref.watch(artistsRepositoryProvider).watchArtist(authUser.uid);
  }
  return Stream.value(null);
});
