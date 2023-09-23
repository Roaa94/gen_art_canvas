import 'package:gen_art_canvas/core/data/firestore_repository.dart';

class CuboidsRepository implements FirestoreRepository {
  @override
  String get collectionName => 'cuboids';
}
