class PropertyIntransfer {
  String id;
  String propertyId;
  String sellerId;
  String buyerId;
  String price;
  String sellerAction;
  String buyerAction;
  String status;
  String createdDate;
  String propertyName;
  String typeId;
  String subTypeId;
  String cityId;
  String townId;
  String societyId;
  String minimumOffer;
  String maximumOffer;
  String long;
  String lat;
  String address;
  String usersId;
  String propertyUnitId;
  String size;
  String contactNumber;
  String bedRooms;
  String bathRooms;
  String phoneNumber;
  String features;
  String name;
  String createdAt;
  String updatedAt;
  String userName;
  String firstName;
  String lastName;
  String socialId;
  String socialAccessToken;
  String roleId;
  String city;
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
  String town;
  String cdate;
  String sellerName;
  String sellerNumber;
  String buyerName;
  String buyerNumber;
  String actionId;
  String cityName;
  String historyId;
  int mints;
  int hours;
  String ticketId;

  PropertyIntransfer(
      {this.id,
        this.propertyId,
        this.sellerId,
        this.buyerId,
        this.price,
        this.sellerAction,
        this.buyerAction,
        this.status,
        this.createdDate,
        this.propertyName,
        this.typeId,
        this.subTypeId,
        this.cityId,
        this.townId,
        this.societyId,
        this.minimumOffer,
        this.maximumOffer,
        this.long,
        this.lat,
        this.address,
        this.usersId,
        this.propertyUnitId,
        this.size,
        this.contactNumber,
        this.bedRooms,
        this.bathRooms,
        this.phoneNumber,
        this.features,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.firstName,
        this.lastName,
        this.socialId,
        this.socialAccessToken,
        this.roleId,
        this.city,
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
        this.town,
        this.cdate,
        this.sellerName,
        this.sellerNumber,
        this.buyerName,
        this.buyerNumber,
        this.actionId,
        this.cityName,
        this.historyId,
        this.mints,
        this.hours});

  PropertyIntransfer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    propertyId = json['property_id'].toString();
    sellerId = json['seller_id'].toString();
    buyerId = json['buyer_id'].toString();
    price = json['price'].toString();
    sellerAction = json['seller_action'].toString();
    buyerAction = json['buyer_action'].toString();
    status = json['status'].toString();
    createdDate = json['created_date'].toString();
    propertyName = json['property_name'].toString();
    typeId = json['type_id'].toString();
    subTypeId = json['sub_type_id'].toString();
    cityId = json['city_id'].toString();
    townId = json['town_id'].toString();
    societyId = json['society_id'].toString();
    minimumOffer = json['minimum_offer'].toString();
    maximumOffer = json['maximum_offer'].toString();
    long = json['long'].toString();
    lat = json['lat'].toString();
    address = json['address'].toString();
    usersId = json['users_id'].toString();
    propertyUnitId = json['property_unit_id'].toString();
    size = json['size'].toString();
    contactNumber = json['contact_number'].toString();
    bedRooms = json['bed_rooms'].toString();
    bathRooms = json['bath_rooms'].toString();
    phoneNumber = json['phone_number'].toString();
    features = json['features'].toString();
    name = json['name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    userName = json['user_name'].toString();
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    socialId = json['social_id'].toString();
    socialAccessToken = json['social_access_token'].toString();
    roleId = json['role_id'].toString();
    city = json['city'].toString();
    profilePicture = json['profile_picture'].toString();
    socialProfilePictureUrl = json['social_profile_picture_url'].toString();
    activationCode = json['activation_code'].toString();
    isActivate = json['is_activate'].toString();
    isBlocked = json['is_blocked'].toString();
    loginType = json['login_type'].toString();
    biography = json['biography'].toString();
    phone = json['phone'].toString();
    password = json['password'].toString();
    role = json['role'].toString();
    authToken = json['auth_token'].toString();
    rememberToken = json['remember_token'].toString();
    recoveryCode = json['recovery_code'].toString();
    onesignalRegistratonid = json['onesignal_registratonid'].toString();
    onesignalPlayerid = json['onesignal_playerid'].toString();
    sessionId = json['session_id'].toString();
    town = json['town'].toString();
    cdate = json['cdate'].toString();
    sellerName = json['seller_name'].toString();
    sellerNumber = json['seller_number'].toString();
    buyerName = json['buyer_name'].toString();
    buyerNumber = json['buyer_number'].toString();
    actionId = json['action_id'].toString();
    cityName = json['city_name'].toString();
    historyId = json['history_id'].toString();
    mints = json['mints'];
    hours = json['hours'];
    ticketId = json['ticket_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['seller_id'] = this.sellerId;
    data['buyer_id'] = this.buyerId;
    data['price'] = this.price;
    data['seller_action'] = this.sellerAction;
    data['buyer_action'] = this.buyerAction;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['property_name'] = this.propertyName;
    data['type_id'] = this.typeId;
    data['sub_type_id'] = this.subTypeId;
    data['city_id'] = this.cityId;
    data['town_id'] = this.townId;
    data['society_id'] = this.societyId;
    data['minimum_offer'] = this.minimumOffer;
    data['maximum_offer'] = this.maximumOffer;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['address'] = this.address;
    data['users_id'] = this.usersId;
    data['property_unit_id'] = this.propertyUnitId;
    data['size'] = this.size;
    data['contact_number'] = this.contactNumber;
    data['bed_rooms'] = this.bedRooms;
    data['bath_rooms'] = this.bathRooms;
    data['phone_number'] = this.phoneNumber;
    data['features'] = this.features;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['social_id'] = this.socialId;
    data['social_access_token'] = this.socialAccessToken;
    data['role_id'] = this.roleId;
    data['city'] = this.city;
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
    data['town'] = this.town;
    data['cdate'] = this.cdate;
    data['seller_name'] = this.sellerName;
    data['seller_number'] = this.sellerNumber;
    data['buyer_name'] = this.buyerName;
    data['buyer_number'] = this.buyerNumber;
    data['action_id'] = this.actionId;
    data['city_name'] = this.cityName;
    data['history_id'] = this.historyId;
    data['mints'] = this.mints;
    data['hours'] = this.hours;
    return data;
  }
}