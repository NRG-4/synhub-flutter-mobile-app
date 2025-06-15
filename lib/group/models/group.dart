class Group {
  final int id;
  final String name;
  final String imgUrl;
  final String description;
  final String code;
  final int memberCount;

  Group({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.code,
    required this.memberCount,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      imgUrl: json['imgUrl'] ?? '',
      description: json['description'],
      code: json['code'],
      memberCount: json['memberCount'],
    );
  }

  // Opcional: método para convertir a Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imgUrl': imgUrl,
    'description': description,
    'code': code,
    'memberCount': memberCount,
  };
}