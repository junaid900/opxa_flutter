class User {
  String id;
  String createdAt;
  String updatedAt;
  String userName;
  String firstName;
  String lastName;
  String socialId;
  String socialAccessToken;
  String roleId;
  String address;
  String city;
  String profilePicture;
  String socialProfilePictureUrl;
  String activationCode;
  String isActivate;
  String isBlocked;
  String loginType;
  String biography;
  String phone;
  String role;
  String authToken;
  String recoveryCode;
  String onesignalRegistratonid;
  String onesignalPlayerid;
  String sessionId;
  int isVerified;

  User(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.firstName,
        this.lastName,
        this.socialId,
        this.socialAccessToken,
        this.roleId,
        this.address,
        this.city,
        this.profilePicture,
        this.socialProfilePictureUrl,
        this.activationCode,
        this.isActivate,
        this.isBlocked,
        this.loginType,
        this.biography,
        this.phone,
        this.role,
        this.authToken,
        this.recoveryCode,
        this.onesignalRegistratonid,
        this.onesignalPlayerid,
        this.sessionId,
        this.isVerified});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    socialId = json['social_id'].toString();
    socialAccessToken = json['social_access_token'];
    roleId = json['role_id'].toString();
    address = json['address'];
    city = json['city'];
    profilePicture = json['profile_picture'];
    socialProfilePictureUrl = json['social_profile_picture_url'];
    activationCode = json['activation_code'].toString();
    isActivate = json['is_activate'].toString();
    isBlocked = json['is_blocked'].toString();
    loginType = json['login_type'].toString();
    biography = json['biography'].toString();
    phone = json['phone'].toString();
    role = json['role'].toString();
    authToken = json['auth_token'];
    recoveryCode = json['recovery_code'].toString();
    onesignalRegistratonid = json['onesignal_registratonid'];
    onesignalPlayerid = json['onesignal_playerid'.toString()];
    sessionId = json['session_id'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['social_id'] = this.socialId;
    data['social_access_token'] = this.socialAccessToken;
    data['role_id'] = this.roleId;
    data['address'] = this.address;
    data['city'] = this.city;
    data['profile_picture'] = this.profilePicture;
    data['social_profile_picture_url'] = this.socialProfilePictureUrl;
    data['activation_code'] = this.activationCode;
    data['is_activate'] = this.isActivate;
    data['is_blocked'] = this.isBlocked;
    data['login_type'] = this.loginType;
    data['biography'] = this.biography;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['auth_token'] = this.authToken;
    data['recovery_code'] = this.recoveryCode;
    data['onesignal_registratonid'] = this.onesignalRegistratonid;
    data['onesignal_playerid'] = this.onesignalPlayerid;
    data['session_id'] = this.sessionId;
    data['is_verified'] = this.isVerified;
    return data;
  }
}