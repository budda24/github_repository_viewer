import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/core/models/data/user_dto.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String name,
    required String avatarUrl,
  }) = _User;

  const User._();

  UserDTO toDomain() => UserDTO(name: name, avatarUrl: avatarUrl);

  String get avatarUrlSmall => '$avatarUrl&s=64';
}
