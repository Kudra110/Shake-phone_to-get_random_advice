import 'package:bloc/bloc.dart';
import 'package:lear2/features/advice/domain/usecases/get_advice_usecase.dart';
import 'package:lear2/features/advice/presentation/bloc/advice_event.dart';
import 'package:lear2/features/advice/presentation/bloc/advice_state.dart';


class AdviceBloc extends Bloc<AdviceEvent, AdviceState> {
  final GetAdviceUsecase getAdviceUsecase;

  AdviceBloc({required this.getAdviceUsecase}) : super(AdviceInitial()) {
    
    on<FetchAdvice>((event, emit) async {
      emit(AdviceLoading());
      final result = await getAdviceUsecase.call();
      
      result.fold(
        (failure) => emit(AdviceError(failure.message)),
        (advice) => emit(AdviceLoaded(advice.advice)),
      );
    });
  }
}
