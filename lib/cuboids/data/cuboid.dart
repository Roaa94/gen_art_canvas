import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

class Cuboid extends Equatable {
  const Cuboid({
    required this.id,
    required this.artistId,
    required this.createdAt,
    required this.topFace,
    required this.rightFace,
    required this.leftFace,
  });

  final String id;
  final String artistId;
  final DateTime createdAt;
  final CuboidFace topFace;
  final CuboidFace rightFace;
  final CuboidFace leftFace;

  factory Cuboid.fromMap(Map<String, dynamic> data, String id) {
    return Cuboid(
      id: id,
      artistId: data['artistId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      topFace: CuboidFace.fromMap(data['topFace']),
      rightFace: CuboidFace.fromMap(data['rightFace']),
      leftFace: CuboidFace.fromMap(data['leftFace']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artistId': artistId,
      'createdAt': Timestamp.fromDate(createdAt),
      'topFace': topFace.toMap(),
      'rightFace': rightFace.toMap(),
      'leftFace': leftFace.toMap(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        topFace,
        rightFace,
        leftFace,
      ];
}
