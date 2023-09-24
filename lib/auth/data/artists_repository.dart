import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/auth/domain/artist.dart';
import 'package:gen_art_canvas/core/data/firestore_repository.dart';

class ArtistsRepository extends FirestoreRepository<Artist> {
  ArtistsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  String get collectionName => 'artists';

  CollectionReference<Artist> get collection =>
      _firestore.collection(collectionName).withConverter(
            fromFirestore: (snapshot, _) =>
                Artist.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (artist, _) => artist.toMap(),
          );

  Future<void> addArtist({
    required String uid,
    required String nickname,
  }) async {
    await collection.doc(uid).set(
          Artist(
            id: uid,
            nickname: nickname,
            joinedAt: DateTime.now(),
          ),
        );
  }

  Future<void> updateArtist({
    required String id,
    String? nickname,
    int? createdCuboidsCount,
  }) async {
    await collection.doc(id).update(
      {
        if (nickname != null) 'nickname': nickname,
        if (createdCuboidsCount != null)
          'createdCuboidsCount': createdCuboidsCount,
      },
    );
  }

  Stream<List<Artist>> watchArtists() {
    return collection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Artist?> getArtist(String uid) async {
    final artistDoc = await collection.doc(uid).get();
    return artistDoc.data();
  }

  Future<void> deleteArtist(String uid) {
    return collection.doc(uid).delete();
  }

  Stream<Artist?> watchArtist(String uid) {
    return collection.doc(uid).snapshots().map((event) => event.data());
  }
}

final artistsRepositoryProvider = Provider<ArtistsRepository>(
  (ref) => ArtistsRepository(FirebaseFirestore.instance),
);
