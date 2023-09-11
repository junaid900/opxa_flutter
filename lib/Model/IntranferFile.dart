class IntransferFile {
  String id;
  String qkpFileSymbolId;
  String qkpFileActionId;
  String qkpFileId;
  String sellerId;
  String buyerId;
  String quantity;
  String price;
  String status;
  String createdDate;
  String updatedDate;
  String symbol;
  String name;
  String detail;
  String fileType;
  String fileSubType;
  String town;
  String city;
  String unitType;
  String unit;
  String createdAt;
  String updatedAt;
  String userName;
  String firstName;
  String lastName;
  String socialId;
  String socialAccessToken;
  String roleId;
  String address;
  String profilePicture;
  String socialProfilePictureUrl;
  String activationCode;
  String isActivate;
  String isBlocked;
  String loginType;
  String biography;
  String phone;
  String password;
  String role;
  String authToken;
  String rememberToken;
  String recoveryCode;
  String onesignalRegistratonid;
  String onesignalPlayerid;
  String sessionId;
  String cdate;
  String sellerName;
  String sellerNumber;
  String buyerName;
  String buyerNumber;
  String actionId;
  String cityName;
  String fileName;
  String historyId;
  String minuts;
  String hours;
  String sellerAction;
  String buyerAction;
  String ticketId;

  IntransferFile(
      {this.id,
        this.qkpFileSymbolId,
        this.qkpFileActionId,
        this.qkpFileId,
        this.sellerId,
        this.buyerId,
        this.quantity,
        this.price,
        this.status,
        this.createdDate,
        this.updatedDate,
        this.symbol,
        this.name,
        this.detail,
        this.fileType,
        this.fileSubType,
        this.town,
        this.city,
        this.unitType,
        this.unit,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.firstName,
        this.lastName,
        this.socialId,
        this.socialAccessToken,
        this.roleId,
        this.address,
        this.profilePicture,
        this.socialProfilePictureUrl,
        this.activationCode,
        this.isActivate,
        this.isBlocked,
        this.loginType,
        this.biography,
        this.phone,
        this.password,
        this.role,
        this.authToken,
        this.rememberToken,
        this.recoveryCode,
        this.onesignalRegistratonid,
        this.onesignalPlayerid,
        this.sessionId,
        this.cdate,
        this.sellerName,
        this.sellerNumber,
        this.buyerName,
        this.buyerNumber,
        this.actionId,
        this.cityName,
        this.fileName,
        this.historyId,
        this.minuts,
        this.hours,
        this.sellerAction,
        this.buyerAction,});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    qkpFileActionId = json['qkp_file_action_id'].toString();
    qkpFileId = json['qkp_file_id'].toString();
    sellerId = json['seller_id'].toString();
    buyerId = json['buyer_id'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    status = json['status'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    symbol = json['symbol'].toString();
    name = json['name'];
    detail = json['detail'];
    fileType = json['file_type'];
    fileSubType = json['file_sub_type'];
    town = json['town'].toString();
    city = json['city'].toString();
    unitType = json['unit_type'].toString();
    unit = json['unit'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    socialId = json['society_id'].toString();
    socialAccessToken = json['social_access_token'];
    roleId = json['role_id'].toString();
    address = json['address'];
    profilePicture = json['profile_picture'];
    socialProfilePictureUrl = json['social_profile_picture_url'];
    activationCode = json['activation_code'].toString();
    isActivate = json['is_activate'].toString();
    isBlocked = json['is_blocked'].toString();
    loginType = json['login_type'].toString();
    biography = json['biography'].toString();
    phone = json['phone'].toString();
    password = json['password'];
    role = json['role'].toString();
    authToken = json['auth_token'];
    rememberToken = json['remember_token'];
    recoveryCode = json['recovery_code'].toString();
    onesignalRegistratonid = json['onesignal_registratonid'];
    onesignalPlayerid = json['onesignal_playerid'];
    sessionId = json['session_id'].toString();
    cdate = json['cdate'];
    sellerName = json['seller_name'].toString();
    sellerNumber = json['seller_number'].toString();
    buyerName = json['buyer_name'].toString();
    buyerNumber = json['buyer_number'].toString();
    actionId = json['action_id'].toString();
    cityName = json['city_name'];
    fileName = json['file_name'];
    historyId = json['history_id'].toString();
    minuts = json['mints'].toString();
    hours = json['hours'].toString();
    sellerAction = json['seller_action'];
    buyerAction = json['buyer_action'];
    ticketId = json['ticket_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['qkp_file_action_id'] = this.qkpFileActionId;
    data['qkp_file_id'] = this.qkpFileId;
    data['seller_id'] = this.sellerId;
    data['buyer_id'] = this.buyerId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['file_type'] = this.fileType;
    data['file_sub_type'] = this.fileSubType;
    data['town'] = this.town;
    data['city'] = this.city;
    data['unit_type'] = this.unitType;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['social_id'] = this.socialId;
    data['social_access_token'] = this.socialAccessToken;
    data['role_id'] = this.roleId;
    data['address'] = this.address;
    data['profile_picture'] = this.profilePicture;
    data['social_profile_picture_url'] = this.socialProfilePictureUrl;
    data['activation_code'] = this.activationCode;
    data['is_activate'] = this.isActivate;
    data['is_blocked'] = this.isBlocked;
    data['login_type'] = this.loginType;
    data['biography'] = this.biography;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['role'] = this.role;
    data['auth_token'] = this.authToken;
    data['remember_token'] = this.rememberToken;
    data['recovery_code'] = this.recoveryCode;
    data['onesignal_registratonid'] = this.onesignalRegistratonid;
    data['onesignal_playerid'] = this.onesignalPlayerid;
    data['session_id'] = this.sessionId;
    data['cdate'] = this.cdate;
    data['seller_name'] = this.sellerName;
    data['seller_number'] = this.sellerNumber;
    data['buyer_name'] = this.buyerName;
    data['buyer_number'] = this.buyerNumber;
    data['action_id'] = this.actionId;
    data['city_name'] = this.cityName;
    data['file_name'] = this.fileName;
    data['history_id'] = this.historyId;
    data['mints'] = this.minuts;
    data['hours'] = this.hours;
    data['seller_action'] = this.sellerAction;
    data['buyer_action'] = this.buyerAction;

    return data;
  }
}