import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  // so that we dont have to use error exception anywhere else????

  //these two are use cases????
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(int? num);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
