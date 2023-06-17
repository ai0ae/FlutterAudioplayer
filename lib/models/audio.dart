import 'dart:convert';

class Audio {
  final String id;
  final String name;
  final String author;
  final String authorId;
  final String image;
  final String audioFile;
  final int views;
  final DateTime createdAt;
  Audio({
    required this.id,
    required this.name,
    required this.author,
    required this.authorId,
    required this.image,
    required this.audioFile,
    required this.views,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'author': author});
    result.addAll({'authorId': authorId});
    result.addAll({'image': image});
    result.addAll({'audioFile': audioFile});
    result.addAll({'views': views});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
  
    return result;
  }

  factory Audio.fromMap(Map<String, dynamic> map) {
    return Audio(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      author: map['author'] ?? '',
      authorId: map['authorId'] ?? '',
      image: map['image'] ?? '',
      audioFile: map['audioFile'] ?? '',
      views: map['views']?.toInt() ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Audio.fromJson(String source) => Audio.fromMap(json.decode(source));

  Audio copyWith({
    String? id,
    String? name,
    String? author,
    String? authorId,
    String? image,
    String? audioFile,
    int? views,
    DateTime? createdAt,
  }) {
    return Audio(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      image: image ?? this.image,
      audioFile: audioFile ?? this.audioFile,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
