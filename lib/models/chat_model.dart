class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});

  // 싱글톤 패턴으로 새로운 인스턴트를 생성하지 않는 생성자를 구현
  // 하나의 클래스에서 하나의 인스턴스만 생성
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
      );
  static List<ChatModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => ChatModel.fromJson(e)).toList();
  }
}
