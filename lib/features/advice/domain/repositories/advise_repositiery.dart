import 'package:dartz/dartz.dart';
import 'package:lear2/features/advice/domain/entities/advice.dart';
import 'package:lear2/features/core/failure.dart';



abstract class AdviseRepositiery {
  Future<Either<Failure, Advice>> getAdvice();
}