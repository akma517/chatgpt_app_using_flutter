class ModelsModel {
  final String id;
  final int created;
  final String root;
  ModelsModel({
    required this.id,
    required this.created,
    required this.root,
  });

  // 싱글톤 패턴으로 새로운 인스턴트를 생성하지 않는 생성자를 구현
  // 하나의 클래스에서 하나의 인스턴스만 생성
  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
        id: json["id"],
        root: json["root"],
        created: json["created"],
      );
  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => ModelsModel.fromJson(e)).toList();
  }
}
