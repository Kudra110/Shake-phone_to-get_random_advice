import 'package:equatable/equatable.dart';

class Advice extends Equatable {
  final String advice;

  const Advice({required this.advice});

  @override
  List<Object?> get props => [advice];
}