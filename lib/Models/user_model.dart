import 'firebase_response_model.dart';

class UserModel {
  String? id, name, email;
  String? userName;
  String? profileImage;
  bool? status;
  DateTime? inactiveTime;
  List<String>? chatRoomIds;
  String? token;
  UserModel({
    this.id,
    this.name,
    this.email,
    this.status,
    this.profileImage,
    this.userName,
    this.inactiveTime,
    this.chatRoomIds,
    this.token,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? userName,
    String? profileImage,
    bool? status,
    DateTime? inactiveTime,
    List<String>? chatRoomIds,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
      inactiveTime: inactiveTime ?? this.inactiveTime,
      userName: userName ?? this.userName,
      chatRoomIds: chatRoomIds ?? this.chatRoomIds,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> tomap() {
    return {
      "email": email ?? "",
      "name": name ?? "",
      "userName": userName ?? "",
      "profileImage": profileImage ?? "",
      "status": status ?? true,
      "inactiveTime": inactiveTime.toString(),
      "chatRoomIds": chatRoomIds ?? [],
      "token": token ?? "",
    };
  }

  UserModel.fromjson(FirebaseResponseModel json)
      : id = json.docId,
        name = json.data["name"] ?? "",
        userName = json.data["userName"] ?? "",
        email = json.data["email"] ?? "",
        profileImage = json.data["profileImage"] ?? "",
        status = json.data["status"] ?? false,
        inactiveTime = DateTime.parse(
            (json.data["inactiveTime"]) ?? "2024-11-09 21:12:11.927887"),
        chatRoomIds = ((json.data["chatRoomIds"] ?? []) as List)
            .map((e) => e.toString())
            .toList(),
        token = json.data["token"] ?? "";
}
