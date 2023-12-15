import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

// a use case should always have a call method??

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  GetConcreteNumberTrivia(this.repository);
  final NumberTriviaRepository repository;

  // call method chai afai call hunxa without needing to mention the name

  // getConcreteNumberTrivia(8);  // this calls tge call function

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number)!;
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
