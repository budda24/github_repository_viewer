// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/core/models/data/user_dto.dart';

part 'issue_dto.freezed.dart';

part 'issue_dto.g.dart';

String _preventNull(Object? json) {
  return (json as String?) ?? '';
}

@freezed
class IssueDTO with _$IssueDTO {
  const factory IssueDTO({
    @JsonKey(fromJson: _preventNull) required String title,
    required UserDTO user,
    @JsonKey(name: 'html_url') required String htmlUrl,
  }) = _IssueDTO;

  const IssueDTO._();

  factory IssueDTO.fromJson(Map<String, dynamic> json) => _$IssueDTOFromJson(json);
}
