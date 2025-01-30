class UserResult {
  final String token;
  final String username;
  final String userID;
  final int expired;
  final int empresaId;
  final int deviceID;

  UserResult({
    required this.token,
    required this.username,
    required this.userID,
    required this.expired,
    required this.empresaId,
    required this.deviceID,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      token: json['token'],
      username: json['username'],
      userID: json['userID'],
      expired: json['expired'],
      empresaId: json['empresas'][0]["empresaID"],
      deviceID: json['deviceID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'userID': userID,
      'expired': expired,
      'empresaId': empresaId,
      'deviceID': deviceID
    };
  }
}
