// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginationState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) then) =
      _$PaginationStateCopyWithImpl<T, $Res, PaginationState<T>>;
}

/// @nodoc
class _$PaginationStateCopyWithImpl<T, $Res, $Val extends PaginationState<T>>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PaginationInitialImplCopyWith<T, $Res> {
  factory _$$PaginationInitialImplCopyWith(_$PaginationInitialImpl<T> value,
          $Res Function(_$PaginationInitialImpl<T>) then) =
      __$$PaginationInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$PaginationInitialImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationInitialImpl<T>>
    implements _$$PaginationInitialImplCopyWith<T, $Res> {
  __$$PaginationInitialImplCopyWithImpl(_$PaginationInitialImpl<T> _value,
      $Res Function(_$PaginationInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaginationInitialImpl<T> extends _PaginationInitial<T> {
  const _$PaginationInitialImpl() : super._();

  @override
  String toString() {
    return 'PaginationState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _PaginationInitial<T> extends PaginationState<T> {
  const factory _PaginationInitial() = _$PaginationInitialImpl<T>;
  const _PaginationInitial._() : super._();
}

/// @nodoc
abstract class _$$PaginationLoadingImplCopyWith<T, $Res> {
  factory _$$PaginationLoadingImplCopyWith(_$PaginationLoadingImpl<T> value,
          $Res Function(_$PaginationLoadingImpl<T>) then) =
      __$$PaginationLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$PaginationLoadingImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationLoadingImpl<T>>
    implements _$$PaginationLoadingImplCopyWith<T, $Res> {
  __$$PaginationLoadingImplCopyWithImpl(_$PaginationLoadingImpl<T> _value,
      $Res Function(_$PaginationLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaginationLoadingImpl<T> extends _PaginationLoading<T> {
  const _$PaginationLoadingImpl() : super._();

  @override
  String toString() {
    return 'PaginationState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _PaginationLoading<T> extends PaginationState<T> {
  const factory _PaginationLoading() = _$PaginationLoadingImpl<T>;
  const _PaginationLoading._() : super._();
}

/// @nodoc
abstract class _$$PaginationLoadingMoreImplCopyWith<T, $Res> {
  factory _$$PaginationLoadingMoreImplCopyWith(
          _$PaginationLoadingMoreImpl<T> value,
          $Res Function(_$PaginationLoadingMoreImpl<T>) then) =
      __$$PaginationLoadingMoreImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items, int currentPage, bool hasReachedMax});
}

/// @nodoc
class __$$PaginationLoadingMoreImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res,
        _$PaginationLoadingMoreImpl<T>>
    implements _$$PaginationLoadingMoreImplCopyWith<T, $Res> {
  __$$PaginationLoadingMoreImplCopyWithImpl(
      _$PaginationLoadingMoreImpl<T> _value,
      $Res Function(_$PaginationLoadingMoreImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentPage = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$PaginationLoadingMoreImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginationLoadingMoreImpl<T> extends _PaginationLoadingMore<T> {
  const _$PaginationLoadingMoreImpl(
      {required final List<T> items,
      required this.currentPage,
      required this.hasReachedMax})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int currentPage;
  @override
  final bool hasReachedMax;

  @override
  String toString() {
    return 'PaginationState<$T>.loadingMore(items: $items, currentPage: $currentPage, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationLoadingMoreImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), currentPage, hasReachedMax);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationLoadingMoreImplCopyWith<T, _$PaginationLoadingMoreImpl<T>>
      get copyWith => __$$PaginationLoadingMoreImplCopyWithImpl<T,
          _$PaginationLoadingMoreImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) {
    return loadingMore(items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) {
    return loadingMore?.call(items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(items, currentPage, hasReachedMax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class _PaginationLoadingMore<T> extends PaginationState<T> {
  const factory _PaginationLoadingMore(
      {required final List<T> items,
      required final int currentPage,
      required final bool hasReachedMax}) = _$PaginationLoadingMoreImpl<T>;
  const _PaginationLoadingMore._() : super._();

  List<T> get items;
  int get currentPage;
  bool get hasReachedMax;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationLoadingMoreImplCopyWith<T, _$PaginationLoadingMoreImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaginationSuccessImplCopyWith<T, $Res> {
  factory _$$PaginationSuccessImplCopyWith(_$PaginationSuccessImpl<T> value,
          $Res Function(_$PaginationSuccessImpl<T>) then) =
      __$$PaginationSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items, int currentPage, bool hasReachedMax});
}

/// @nodoc
class __$$PaginationSuccessImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationSuccessImpl<T>>
    implements _$$PaginationSuccessImplCopyWith<T, $Res> {
  __$$PaginationSuccessImplCopyWithImpl(_$PaginationSuccessImpl<T> _value,
      $Res Function(_$PaginationSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? currentPage = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$PaginationSuccessImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginationSuccessImpl<T> extends _PaginationSuccess<T> {
  const _$PaginationSuccessImpl(
      {required final List<T> items,
      required this.currentPage,
      required this.hasReachedMax})
      : _items = items,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int currentPage;
  @override
  final bool hasReachedMax;

  @override
  String toString() {
    return 'PaginationState<$T>.success(items: $items, currentPage: $currentPage, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), currentPage, hasReachedMax);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationSuccessImplCopyWith<T, _$PaginationSuccessImpl<T>>
      get copyWith =>
          __$$PaginationSuccessImplCopyWithImpl<T, _$PaginationSuccessImpl<T>>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) {
    return success(items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) {
    return success?.call(items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(items, currentPage, hasReachedMax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _PaginationSuccess<T> extends PaginationState<T> {
  const factory _PaginationSuccess(
      {required final List<T> items,
      required final int currentPage,
      required final bool hasReachedMax}) = _$PaginationSuccessImpl<T>;
  const _PaginationSuccess._() : super._();

  List<T> get items;
  int get currentPage;
  bool get hasReachedMax;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationSuccessImplCopyWith<T, _$PaginationSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaginationErrorImplCopyWith<T, $Res> {
  factory _$$PaginationErrorImplCopyWith(_$PaginationErrorImpl<T> value,
          $Res Function(_$PaginationErrorImpl<T>) then) =
      __$$PaginationErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call(
      {String message,
      Object? error,
      StackTrace? stackTrace,
      List<T>? items,
      int currentPage,
      bool hasReachedMax});
}

/// @nodoc
class __$$PaginationErrorImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationErrorImpl<T>>
    implements _$$PaginationErrorImplCopyWith<T, $Res> {
  __$$PaginationErrorImplCopyWithImpl(_$PaginationErrorImpl<T> _value,
      $Res Function(_$PaginationErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
    Object? items = freezed,
    Object? currentPage = null,
    Object? hasReachedMax = null,
  }) {
    return _then(_$PaginationErrorImpl<T>(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error ? _value.error : error,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginationErrorImpl<T> extends _PaginationError<T> {
  const _$PaginationErrorImpl(
      {required this.message,
      this.error,
      this.stackTrace,
      final List<T>? items,
      this.currentPage = 0,
      this.hasReachedMax = false})
      : _items = items,
        super._();

  @override
  final String message;
  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;
  final List<T>? _items;
  @override
  List<T>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasReachedMax;

  @override
  String toString() {
    return 'PaginationState<$T>.error(message: $message, error: $error, stackTrace: $stackTrace, items: $items, currentPage: $currentPage, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationErrorImpl<T> &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      const DeepCollectionEquality().hash(error),
      stackTrace,
      const DeepCollectionEquality().hash(_items),
      currentPage,
      hasReachedMax);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationErrorImplCopyWith<T, _$PaginationErrorImpl<T>> get copyWith =>
      __$$PaginationErrorImplCopyWithImpl<T, _$PaginationErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        loadingMore,
    required TResult Function(
            List<T> items, int currentPage, bool hasReachedMax)
        success,
    required TResult Function(
            String message,
            Object? error,
            StackTrace? stackTrace,
            List<T>? items,
            int currentPage,
            bool hasReachedMax)
        error,
  }) {
    return error(
        message, this.error, stackTrace, items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult? Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult? Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
  }) {
    return error?.call(
        message, this.error, stackTrace, items, currentPage, hasReachedMax);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        loadingMore,
    TResult Function(List<T> items, int currentPage, bool hasReachedMax)?
        success,
    TResult Function(String message, Object? error, StackTrace? stackTrace,
            List<T>? items, int currentPage, bool hasReachedMax)?
        error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(
          message, this.error, stackTrace, items, currentPage, hasReachedMax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PaginationInitial<T> value) initial,
    required TResult Function(_PaginationLoading<T> value) loading,
    required TResult Function(_PaginationLoadingMore<T> value) loadingMore,
    required TResult Function(_PaginationSuccess<T> value) success,
    required TResult Function(_PaginationError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PaginationInitial<T> value)? initial,
    TResult? Function(_PaginationLoading<T> value)? loading,
    TResult? Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult? Function(_PaginationSuccess<T> value)? success,
    TResult? Function(_PaginationError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PaginationInitial<T> value)? initial,
    TResult Function(_PaginationLoading<T> value)? loading,
    TResult Function(_PaginationLoadingMore<T> value)? loadingMore,
    TResult Function(_PaginationSuccess<T> value)? success,
    TResult Function(_PaginationError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PaginationError<T> extends PaginationState<T> {
  const factory _PaginationError(
      {required final String message,
      final Object? error,
      final StackTrace? stackTrace,
      final List<T>? items,
      final int currentPage,
      final bool hasReachedMax}) = _$PaginationErrorImpl<T>;
  const _PaginationError._() : super._();

  String get message;
  Object? get error;
  StackTrace? get stackTrace;
  List<T>? get items;
  int get currentPage;
  bool get hasReachedMax;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationErrorImplCopyWith<T, _$PaginationErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
