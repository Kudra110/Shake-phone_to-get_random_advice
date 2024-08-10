import 'package:dartz/dartz.dart';
import 'package:lear2/features/advice/domain/entities/advice.dart';
import 'package:lear2/features/advice/domain/repositories/advise_repositiery.dart';
import 'package:lear2/features/core/failure.dart';


class GetAdviceUsecase {
  final AdviseRepositiery repository;

  GetAdviceUsecase(this.repository);

  Future<Either<Failure, Advice>> call() async {
    
    return await repository.getAdvice();
  }
}
