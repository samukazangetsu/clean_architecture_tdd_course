import 'dart:async';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/presentantion/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

import 'package:clean_architecture_tdd_course/core/presentantion/string_errors.dart';

part 'number_trivia_state.dart';

class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaCubit({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty());

  @override
  void onChange(Change<NumberTriviaState> change) {
    super.onChange(change);
  }

  Future<void> getTriviaForConcreteNumber(String str) async {
    final inputEither = inputConverter.stringToUnsignedInteger(str);

    inputEither.fold(
      (l) async* {
        emit(Error(message: STRING_INVALID_INPUT_FAILURE_MESSAGE));
      },
      (r) async* {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: r));

        _eitherOrLoadedorErrorState(failureOrTrivia);
      },
    );
  }

  Future<void> getTriviaForRandomNumber() async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());

    _eitherOrLoadedorErrorState(failureOrTrivia);
  }

  Stream<NumberTriviaState> _eitherOrLoadedorErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    failureOrTrivia.fold(
      (l) => emit(Error(message: _mapFailureToMessage(l))),
      (r) => emit(Loaded(trivia: r)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
