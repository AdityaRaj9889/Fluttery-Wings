import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.code});
}

class AudioFailure extends Failure {
  const AudioFailure(super.message, {super.code});
}

class GameFailure extends Failure {
  const GameFailure(super.message, {super.code});
}

class Result<T> {
  final T? data;
  final Failure? failure;
  const Result._({this.data, this.failure});

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(Failure f) => Result._(failure: f);

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;
}
