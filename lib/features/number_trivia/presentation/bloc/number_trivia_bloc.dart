// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';

import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_trivia_repository.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - the The number must be a positive number or zero';

// this is going to call the usecases from domain layer
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  //usecases
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold(
        (failure) => emit(
          const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ),
        (integer) => throw UnimplementedError(),
      );
    });
  }
  NumberTriviaState get initialState => Empty();
}
