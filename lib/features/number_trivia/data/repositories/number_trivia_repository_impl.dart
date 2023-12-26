import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  //? yeta chai sabai datasources ( remote and local ) bata data auxa ani manipulate garinxa ?? hola
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num) async {
    
    // }
    return _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(num);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getRandomOrConcrete) async {
    // gets the data and cheches it.
    // gets cached data when no internet.

    if (await networkInfo.isConnected) {
      //* if internet xa vane
      try {
        final remoteData = await getRandomOrConcrete();

        //? data retrive vayepxi data lai cache gareko
        localDataSource.cacheNumberTrivia(remoteData);

        //? if successful returns the data as NumberTriviaModel
        return Right(remoteData);
      } on ServerException {
        //! On Exeption returns Failure object
        return Left(ServerFailure());
      }
    } else {
      //* internet xaina!!!
      try {
        //? cache ma vako data retrieve garxa
        final localTrivia = await localDataSource.getLastNumberTrivia();

        //? if successful returns data as NumberTriviaModel
        return Right(localTrivia);
      } on CacheException {
        //! if there is no data in cache returns Failure Object
        return Left(CacheFailure());
      }
    }
  }
}
