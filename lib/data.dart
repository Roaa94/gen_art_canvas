import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_data.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face_data.dart';

final cuboids = [
  CuboidData(
    id: '1',
    artistId: '1',
    createdAt: DateTime.now(),
    topFace: const CuboidFaceData(
      id: '0',
      cuboidId: '1',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red,
    ),
    rightFace: CuboidFaceData(
      id: '1',
      cuboidId: '1',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red.shade700,
    ),
    leftFace: CuboidFaceData(
      id: '2',
      cuboidId: '1',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red.shade800,
    ),
  ),
  CuboidData(
    id: '2',
    artistId: '1',
    createdAt: DateTime.now(),
    topFace: const CuboidFaceData(
      id: '0',
      cuboidId: '2',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue,
    ),
    rightFace: CuboidFaceData(
      id: '1',
      cuboidId: '2',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue.shade700,
    ),
    leftFace: CuboidFaceData(
      id: '2',
      cuboidId: '2',
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue.shade800,
    ),
  ),
];
