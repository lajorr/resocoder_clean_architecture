import 'package:dartz/dartz.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  GetConcreteNumberTrivia(this.repository);
  final NumberTriviaRepository repository;

  Future<Either<Failure, NumberTrivia>>  execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number)!;
  }
}