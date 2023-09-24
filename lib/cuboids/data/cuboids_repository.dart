import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/core/data/firestore_repository.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid.dart';

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

  Stream<List<Cuboid>> watchCuboids() {
    return collection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }
}

final cuboidsRepositoryProvider = Provider<CuboidsRepository>(
  (ref) => CuboidsRepository(FirebaseFirestore.instance),
);
