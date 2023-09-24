import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';

final cuboids = [
  Cuboid(
    id: '1',
    artistId: '1',
    createdAt: DateTime.now(),
    topFace: const CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red,
    ),
    rightFace: CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red.shade700,
    ),
    leftFace: CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.red.shade800,
    ),
  ),
  Cuboid(
    id: '2',
    artistId: '1',
    createdAt: DateTime.now(),
    topFace: const CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue,
    ),
    rightFace: CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue.shade700,
    ),
    leftFace: CuboidFace(
      fillType: CuboidFaceFillType.fill,
      fillColor: Colors.blue.shade800,
    ),
  ),
];
