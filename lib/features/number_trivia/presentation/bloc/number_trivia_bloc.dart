import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => throw UnimplementedError();
}
