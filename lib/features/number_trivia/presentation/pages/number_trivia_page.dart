import '../cubit/number_trivia_cubit.dart';
import '../widgets/widgets_import.dart';
import '../../../../injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaCubit> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaCubit>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              // Top half
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: BlocBuilder<NumberTriviaCubit, NumberTriviaState>(
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case Empty:
                        return MessageDisplay(
                          message: 'Start Searching!',
                        );
                      case Error:
                        return MessageDisplay(
                          message: (state as Error).message,
                        );
                      case Loading:
                        return LoadingWidget();
                      case Loaded:
                        return TriviaDisplay(
                          numberTrivia: (state as Loaded).trivia,
                        );
                      default:
                        return MessageDisplay(
                          message: 'Start Searching!',
                        );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              // Bottom half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
