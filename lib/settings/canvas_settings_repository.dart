import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_art_canvas/core/data/firestore_repository.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CanvasSettingsRepository implements FirestoreRepository<dynamic> {
  CanvasSettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  String get collectionName => 'canvas_settings';

  static const String canvasSettingsDocumentId = 'cuboids_canvas_settings';

  Stream<CuboidsCanvasSettings> watchCuboidsCanvasSettings() {
    return _firestore
        .collection(collectionName)
        .doc(canvasSettingsDocumentId)
        .withConverter<CuboidsCanvasSettings>(
          fromFirestore: (snapshot, _) =>
              CuboidsCanvasSettings.fromMap(snapshot.data()!),
          toFirestore: (settings, _) => settings.toMap(),
        )
        .snapshots()
        .map((event) => event.data() ?? const CuboidsCanvasSettings());
  }
}

final canvasSettingsRepositoryProvider = Provider<CanvasSettingsRepository>(
  (ref) => CanvasSettingsRepository(FirebaseFirestore.instance),
);
