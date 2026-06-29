part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel userModel) => <String, dynamic>{
      'id': userModel.id,
      'email': userModel.email,
      'displayName': userModel.displayName,
      'photoUrl': userModel.photoUrl,
    };