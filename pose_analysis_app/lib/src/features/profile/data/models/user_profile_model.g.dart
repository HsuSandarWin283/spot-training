part of 'user_profile_model.dart';

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) => UserProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      favoriteSports: (json['favoriteSports'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'favoriteSports': instance.favoriteSports,
    };