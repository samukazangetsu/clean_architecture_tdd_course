import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/presentantion/string_errors.dart';
import 'package:clean_architecture_tdd_course/core/presentantion/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/cubit/number_trivia_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaCubit cubit;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    cubit = NumberTriviaCubit(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'initialState should be Empty',
    () async {
      // assert
      expect(cubit.state, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSucess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

        // act
        untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        await cubit.getTriviaForConcreteNumber(tNumberString);

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        cubit.close();
      },
    );

    test(
      'should emit a [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // assert
        final expected = [
          // Empty(),
          Error(message: STRING_INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForConcreteNumber(tNumberString);
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        await cubit.getTriviaForConcreteNumber(tNumberString);
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForConcreteNumber(tNumberString);
        cubit.close();
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForConcreteNumber(tNumberString);
        cubit.close();
      },
    );

    test(
      'should emit [Loading, Error] whit a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSucess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForConcreteNumber(tNumberString);
        cubit.close();
      },
    );
  });

  group('GetTriviaForRandomeNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        await cubit.getTriviaForRandomNumber();
        await untilCalled(mockGetRandomNumberTrivia(any));

        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForRandomNumber();
        // cubit.close();
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForRandomNumber();
        cubit.close();
      },
    );

    test(
      'should emit [Loading, Error] whit a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          // Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(cubit, emitsInOrder(expected));

        // act
        await cubit.getTriviaForRandomNumber();
        cubit.close();
      },
    );
  });
}
