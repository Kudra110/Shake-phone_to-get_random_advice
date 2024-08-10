import 'package:dartz/dartz.dart';
import 'package:lear2/features/advice/data/datasources/advice_remote_datasource.dart';
import 'package:lear2/features/advice/domain/entities/advice.dart';
import 'package:lear2/features/advice/domain/repositories/advise_repositiery.dart';
import 'package:lear2/features/core/failure.dart';


class AdviseRepoImp extends AdviseRepositiery {
  final AdviseRemoteDataSource adviceRemoteDatasourceImpl;

  AdviseRepoImp({required this.adviceRemoteDatasourceImpl});

 @override
Future<Either<Failure, Advice>> getAdvice() async {
  try {
    final advice = await adviceRemoteDatasourceImpl.getAdvice();
    
    return Right(advice);
  } catch (e) {
    print("Error in repository: $e");
    return Left(Failure(message: "An error occurred: $e"));
  }
}

}
