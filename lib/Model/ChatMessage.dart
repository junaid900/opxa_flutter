class ChatMessages {
  String id;
  String chatId;
  String senderId;
  String message;
  String sendDate;
  String fileType;
  String fileId;
  String supportStatus;
  String otherStatus;
  String createdAt;
  String updatedAt;
  String userName;
  String type;
  String fileUrl;
  String lenght;
  bool isLoading;
  String profileImage;

  ChatMessages(
      {this.id,
        this.chatId,
        this.senderId,
        this.message,
        this.sendDate,
        this.fileType,
        this.fileId,
        this.supportStatus,
        this.otherStatus,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.type,this.fileUrl,this.profileImage});

  ChatMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    chatId = json['chat_id'].toString();
    senderId = json['sender_id'].toString();
    message = json['message'].toString();
    sendDate = json['send_date'].toString();
    fileType = json['file_type'].toString();
    fileId = json['file_id'].toString();
    supportStatus = json['support_status'].toString();
    otherStatus = json['other_status'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    userName = json['user_name'].toString();
    type = json['type'].toString();
    fileUrl = json['file_url'];
    profileImage = json['profile_image'] != null ? json['profile_image']:"";
    lenght = json['audio_length_mil'].toString();
    isLoading = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_id'] = this.chatId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['send_date'] = this.sendDate;
    data['file_type'] = this.fileType;
    data['file_id'] = this.fileId;
    data['support_status'] = this.supportStatus;
    data['other_status'] = this.otherStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['type'] = this.type;
    return data;
  }
}