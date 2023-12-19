import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/core/error/exceptions.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/network/network_info.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repositoryImpl;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    //* this should be able to take all of the above vars
    repositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource!,
      remoteDataSource: mockRemoteDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTriva', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test triva', number: tNumber);
    const NumberTrivia tNumberTriva = tNumberTriviaModel;

    test('Should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);

      //act
      repositoryImpl!.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestOnline(() {
      //* should [action/what should happen] when [circumstances]
      test(
          'Should return data when the call to remote data source is succesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(
          mockRemoteDataSource!.getConcreteNumberTrivia(tNumber),
        );
        expect(
            result,
            equals(
              const Right(tNumberTriva),
            ));
      });

      test(
          'Should cache data locally when the call to remote data source is succesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(
          mockRemoteDataSource!.getConcreteNumberTrivia(tNumber),
        );
        // verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'Should return server failure when the call to remote data source is unsuccesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        //act
        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(const Left(ServerFailure)));
      });
    });
    runTestOffline(() {
      test(
          'should return last locally cached data when the cach data is present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource!);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, const Right(tNumberTriva));
      });

      test('should return cache failire when their is no cahe data present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repositoryImpl!.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
  group('getRandomNumberTriva', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test triva', number: 123);
    const NumberTrivia tNumberTriva = tNumberTriviaModel;

    test('Should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);

      //act
      repositoryImpl!.getRandomNumberTrivia();

      //assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestOnline(() {
      //* should [action/what should happen] when [circumstances]
      test(
          'Should return data when the call to remote data source is succesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repositoryImpl!.getRandomNumberTrivia();

        //assert
        verify(
          mockRemoteDataSource!.getRandomNumberTrivia(),
        );
        expect(
            result,
            equals(
              const Right(tNumberTriva),
            ));
      });

      test(
          'Should cache data locally when the call to remote data source is succesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repositoryImpl!.getRandomNumberTrivia();

        //assert
        verify(
          mockRemoteDataSource!.getRandomNumberTrivia(),
        );
        // verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'Should return server failure when the call to remote data source is unsuccesfull',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());

        //act
        final result = await repositoryImpl!.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(const Left(ServerFailure)));
      });
    });
    runTestOffline(() {
      test(
          'should return last locally cached data when the cach data is present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repositoryImpl!.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource!);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, const Right(tNumberTriva));
      });

      test('should return cache failire when their is no cahe data present',
          () async {
        //arrange
        when(mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repositoryImpl!.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
