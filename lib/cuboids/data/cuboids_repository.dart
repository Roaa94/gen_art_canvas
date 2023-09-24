import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/core/data/firestore_repository.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

class CuboidsRepository implements FirestoreRepository {
  CuboidsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  String get collectionName => 'cuboids';

  CollectionReference<Cuboid> get collection =>
      _firestore.collection(collectionName).withConverter(
            fromFirestore: (snapshot, _) =>
                Cuboid.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (cuboid, _) => cuboid.toMap(),
          );

  Future<void> addCuboid({
    required String artistId,
    required CuboidFace topFace,
    required CuboidFace rightFace,
    required CuboidFace leftFace,
  }) async {
    final docRef = collection.doc();
    await collection.doc(docRef.id).set(
          Cuboid(
            id: docRef.id,
            artistId: artistId,
            createdAt: DateTime.now(),
            topFace: topFace,
            rightFace: rightFace,
            leftFace: leftFace,
          ),
        );
  }

  Stream<List<Cuboid>> watchCuboids() {
    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((e) => e.data())
        .where((Cuboid cuboid) => cuboid.isValid)
        .toList());
  }
}

final cuboidsRepositoryProvider = Provider<CuboidsRepository>(
  (ref) => CuboidsRepository(FirebaseFirestore.instance),
);
