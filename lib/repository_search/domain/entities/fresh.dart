import 'package:freezed_annotation/freezed_annotation.dart';

part 'fresh.freezed.dart';

@freezed
class Fresh<T> with _$Fresh<T> {
  const factory Fresh({
    required T entity,
    bool? isNextPageAvailable,
  }) = _Fresh<T>;

  const Fresh._();

  factory Fresh.yes(
    T entity, {
    bool? isNextPageAvailable,
  }) =>
      Fresh(
        entity: entity,
        isNextPageAvailable: isNextPageAvailable,
      );

  factory Fresh.no(
    T entity, {
    bool? isNextPageAvailable,
  }) =>
      Fresh(
        entity: entity,
        isNextPageAvailable: isNextPageAvailable,
      );
}
