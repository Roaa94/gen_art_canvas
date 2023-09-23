import 'package:equatable/equatable.dart';
import 'package:gen_art_canvas/cuboids/models/cuboid_face_data.dart';

class CuboidData extends Equatable {
  const CuboidData({
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
  final CuboidFaceData topFace;
  final CuboidFaceData rightFace;
  final CuboidFaceData leftFace;

  @override
  List<Object?> get props => [
        id,
        topFace,
        rightFace,
        leftFace,
      ];
}
