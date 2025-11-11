class RefreshRequestModel {
  final String refreshToken;

  const RefreshRequestModel({required this.refreshToken});

  factory RefreshRequestModel.fromJson(Map<String, dynamic> json) {
    return RefreshRequestModel(refreshToken: 'refresh_token');
  }

  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};
}
