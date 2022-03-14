import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/cubit/number_trivia_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                key: Key('search_button'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: dispatchConcrete,
                child: Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                key: Key('get_random_button'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).buttonTheme.colorScheme.primary,
                ),
                onPressed: dispatchRandom,
                child: Text(
                  'Get random trivia',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaCubit>(context)
        .getTriviaForConcreteNumber(inputStr);
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaCubit>(context).getTriviaForRandomNumber();
  }
}
