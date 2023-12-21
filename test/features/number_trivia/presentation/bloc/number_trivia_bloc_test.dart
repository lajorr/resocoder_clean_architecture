import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/constants/strings/string_constants.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_random_trivia_repository.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  late NumberTriviaBloc triviaBloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    triviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    //assert
    expect(triviaBloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;

    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger('1'))
            .thenReturn(const Right(tNumberParsed));

    test(
        'Should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(
          mockInputConverter.stringToUnsignedInteger(tNumberString));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('Should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger('1'))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        Empty(), // the first state/ initial state is always empty
        const Error(message: StringConstants.invalidInputFailureMessage),
      ];
      expectLater(triviaBloc.state, expected);
      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('Should get data from the concrete usecase ', () async {
      // arrange

      setUpMockInputConverterSuccess();
      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));

      await untilCalled(mockGetConcreteNumberTrivia(const Params(number: 1)));
      // assert

      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Loaded(numberTrivia: tNumberTrivia),
      ];
      expectLater(triviaBloc.state, emitsInOrder(expected));

      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('Should emit [Loading, Error] when getting data is failed', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: StringConstants.serverFailureMessage),
      ];
      expectLater(triviaBloc.state, emitsInOrder(expected));

      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('Should emit [Loading, Error] with proper message for the error when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Empty(),
        Loading(),
        const Error(message: StringConstants.cacheFailureMessage),
      ];
      expectLater(triviaBloc.state, emitsInOrder(expected));

      // act
      triviaBloc
          .add(const GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });



}
