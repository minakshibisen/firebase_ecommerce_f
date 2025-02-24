class UserModel{
  final String uId;
  final String userName;
  final String userCity;
  final String email;
  final String phone;
  final String userImg;
  final String userDeviceToken;
  final String country;
  final String userAddress;
  final String street;
  final bool isAdmin;
  final bool isActive;
  final dynamic createdOn;

  UserModel({
    required this.uId,
    required this.userName,
    required this.userCity,
    required this.email,
    required this.phone,
    required this.userImg,
    required this.userDeviceToken,
    required this.country,
    required this.userAddress,
    required this.street,
    required this.isAdmin,
    required this.isActive,
    required this.createdOn,
});

  Map<String,dynamic>toMap(){
    return{
      'uId':uId,
      'userName':userName,
      'userCity':userCity,
      'email':email,
      'phone':phone,
      'userImg':userImg,
      'userDeviceToken':userDeviceToken,
      'country':country,
      'userAddress':userAddress,
      'street':street,
      'isAdmin':isAdmin,
      'isActive':isActive,
      'createdOn':createdOn,
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] ?? '',
      userName: map['userName'] ?? '',
      userCity: map['userCity'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userImg: map['userImg'] ?? '',
      userDeviceToken: map['userDeviceToken'] ?? '',
      country: map['country'] ?? '',
      userAddress: map['userAddress'] ?? '',
      street: map['street'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      isActive: map['isActive'] ?? false,
      createdOn: DateTime.tryParse(map['createdOn'] ?? '') ?? DateTime.now(),
    );
  }
}