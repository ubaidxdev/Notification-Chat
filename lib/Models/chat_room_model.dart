class ChatRoomModel {
  String? id;
  bool? isgroup;
  String? groupname;
  String? chatsgroupId;
  List<String>? memberIds;
  ChatRoomModel({
    this.id,
    this.isgroup,
    this.groupname,
    this.memberIds,
    this.chatsgroupId,
  });

  ChatRoomModel copyWith({
    String? id,
    bool? isgroup,
    String? groupname,
    List<String>? memberIds,
    String? chatsgroupId,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      isgroup: isgroup ?? this.isgroup,
      groupname: groupname ?? this.groupname,
      memberIds: memberIds ?? this.memberIds,
      chatsgroupId: chatsgroupId ?? this.chatsgroupId,
    );
  }

  Map<String, dynamic> tomap() {
    return {
      "isgroup": isgroup ?? false,
      "groupname": groupname ?? "",
      "memberIds": memberIds!.map((e) => e.toString()).toList(),
      "chatsgroupId": chatsgroupId ?? ""
    };
  }

  ChatRoomModel.fromejson(Map<Object?, Object?> json)
      : id = json["id"].toString(),
        isgroup = (json["id"] ?? false) as bool,
        groupname = json["groupname"].toString(),
        memberIds =
            ((json["id"] ?? []) as List).map((e) => e.toString()).toList(),
        chatsgroupId = json["chatsgroupId"].toString();
}
