// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/usecase/usecase.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';

import '../../../../constants/strings/string_constants.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_trivia_repository.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// important to all possible types of failures in bloc

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
    on<GetTriviaForConcreteNumber>(getConcreteTrivia);

    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        // random;
        emit(Loading());
        final failureOrTrivia = await random.call(NoParams());
        failureOrTrivia.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Loaded(numberTrivia: trivia)),
        );
      },
    );
  }
  FutureOr<void> getConcreteTrivia(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    if (inputEither.isLeft()) {
      inputEither.leftMap(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))));
    } else {
      emit(Loading());
      final failureOrTrivia =
          await concrete.call(Params(number: int.parse(event.numberString)));
      failureOrTrivia.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) {
        emit(Loaded(numberTrivia: trivia));
      });
    }
  }

  NumberTriviaState get initialState => Empty();

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return StringConstants.serverFailureMessage;
      case CacheFailure:
        return StringConstants.cacheFailureMessage;
      case InvalidInputFailure:
        return StringConstants.invalidInputFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}






