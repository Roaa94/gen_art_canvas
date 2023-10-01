import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  const Artist({
    required this.id,
    required this.nickname,
    required this.joinedAt,
    this.signedUpAt,
    this.createdCuboidsCount = 0,
  });

  factory Artist.fromMap(Map<String, dynamic> data, String id) {
    final joinedAtTimestamp = data['joinedAt'] as Timestamp;
    final signedUpAtTimestamp = data['signedUpAt'] as Timestamp?;
    final createdCuboidsCount = data['createdCuboidsCount'] as int?;
    final nickname = data['nickname'] as String?;

    return Artist(
      id: id,
      nickname: nickname ?? '',
      joinedAt: joinedAtTimestamp.toDate(),
      signedUpAt: signedUpAtTimestamp?.toDate(),
      createdCuboidsCount: createdCuboidsCount ?? 0,
    );
  }

  final String id;
  final String nickname;
  final DateTime joinedAt;
  final DateTime? signedUpAt;
  final int createdCuboidsCount;

  Map<String, dynamic> toMap() => {
        'nickname': nickname,
        'joinedAt': Timestamp.fromDate(joinedAt),
        'signedUpAt':
            signedUpAt == null ? null : Timestamp.fromDate(signedUpAt!),
        'createdCuboidsCount': createdCuboidsCount,
      };

  @override
  List<Object?> get props => [
        id,
        joinedAt,
        createdCuboidsCount,
      ];
}
