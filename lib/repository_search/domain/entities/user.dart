import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String name,
    required String avatarUrl,
  }) = _User;
  const User._();

  String get avatarUrlSmall => '$avatarUrl&s=64';
}
