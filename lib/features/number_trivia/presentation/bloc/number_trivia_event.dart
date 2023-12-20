part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  const GetTriviaForConcreteNumber({required this.numberString});

  final String numberString;
  // yo chai direct UI bata leko re string banako
  // we couldve converted it to int
  // but since this is presentation logic,, we dont do that here
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
