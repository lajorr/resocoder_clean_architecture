import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// this will call the http://numbersapi.com/{number} endpoint
  ///
  /// and throws [ServerExeption] on all error
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int? num);

  /// this will call the http://numbersapi.com/random endpoint
  ///
  /// and throws [ServerExeption] on all error
  Future<NumberTriviaModel>? getRandomNumberTrivia();
  
}
