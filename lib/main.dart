import 'package:flutter/material.dart';
import 'package:lear2/features/advice/data/datasources/advice_remote_datasource.dart';
import 'package:lear2/features/advice/data/repositories/advise_repo_imp.dart';
import 'package:lear2/features/advice/domain/usecases/get_advice_usecase.dart';
import 'package:lear2/features/advice/presentation/bloc/advice_bloc.dart';
import 'package:lear2/features/advice/presentation/bloc/advice_event.dart';
import 'package:lear2/features/advice/presentation/bloc/advice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_detector_android/shake_detector_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final adviceRemoteDatasource = AdviceRemoteDatasourceImpl();
    final adviseRepo =
        AdviseRepoImp(adviceRemoteDatasourceImpl: adviceRemoteDatasource);
    final getAdviceUsecase = GetAdviceUsecase(adviseRepo);

    return MaterialApp(
      title: 'Advice App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.orange,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            AdviceBloc(getAdviceUsecase: getAdviceUsecase)..add(FetchAdvice()),
        child: AdviceScreen(),
      ),
    );
  }
}

class AdviceScreen extends StatefulWidget {
  @override
  _AdviceScreenState createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    shake();

    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Changed duration to 3 seconds
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    shake();

    super.dispose();
  }

  void shake() {
    ShakeDetectorAndroid.startListening((e) {
      context.read<AdviceBloc>().add(FetchAdvice());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdviceBloc, AdviceState>(
        builder: (context, state) {
          if (state is AdviceLoading) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(0),
                  const SizedBox(width: 8),
                  _buildDot(0.5),
                  const SizedBox(width: 8),
                  _buildDot(1),
                ],
              ),
            );
          } else if (state is AdviceLoaded) {
            return FadeTransition(
              opacity: _animationController(context, 1.0),
              child: ScaleTransition(
                scale: _animationController(context, 1.1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(seconds: 1),
                              child: Text(
                                state.advice,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),                            const SizedBox(height: 150),

                        ElevatedButton(
                          onPressed: () async {
                            // Display thinking animation
                            context.read<AdviceBloc>().add(FetchAdvice());
                          },
                          child: const Text('Get New Advice'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is AdviceError) {
            return Center(
              child: FadeTransition(
                opacity: _animationController(context, 1.0),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Unknown state.'));
          }
        },
      ),
    );
  }

  Widget _buildDot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationValue = _animation.value;
        return Transform.translate(
          offset: Offset(0, 20 * (animationValue - 0.5)),
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Animation<double> _animationController(
      BuildContext context, double endValue) {
    final controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: Scaffold.of(context),
    );
    final animation =
        Tween<double>(begin: 0.0, end: endValue).animate(controller);
    controller.forward();
    return animation;
  }
}
