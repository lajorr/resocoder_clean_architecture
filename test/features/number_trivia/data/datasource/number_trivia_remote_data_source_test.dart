import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/core/error/exceptions.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();

    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(Uri.parse('any'), headers: anyNamed('headers')))
        .thenAnswer((_) async =>
            http.Response(FixtureReader.fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(Uri.parse('any'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something Went Wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(
      FixtureReader.fixture('trivia.json'),
    ));

    test(
        'Should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });
    test('Should return Numbertrivia when the response code is 200 ( success )',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      // assert

      expect(result, tNumberTriviaModel);
    });

    test('Should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSourceImpl.getConcreteNumberTrivia;

      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(
      FixtureReader.fixture('trivia.json'),
    ));

    test(
        'Should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSourceImpl.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });
    test('Should return Numbertrivia when the response code is 200 ( success )',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSourceImpl.getRandomNumberTrivia();
      // assert

      expect(result, tNumberTriviaModel);
    });

    test('Should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSourceImpl.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
