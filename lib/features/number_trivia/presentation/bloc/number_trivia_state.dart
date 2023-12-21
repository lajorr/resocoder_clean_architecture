part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

final class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

final class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  @override
  List<Object> get props => [numberTrivia];

  const Loaded({required this.numberTrivia});
}

final class Error extends NumberTriviaState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
