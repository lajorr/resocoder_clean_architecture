import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/core/error/exceptions.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    //* all of these test passes

    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        FixtureReader.fixture('trivia_cached.json'),
      ),
    );
    test(
        'Should return NumberTrivia from SharedPreferences when there is data in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(FixtureReader.fixture('trivia_cached.json'));
      // act
      final result = await dataSourceImpl.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
    test('Should throw a CacheException when there is not a cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString('a')).thenReturn(null);
      // act
      final call = dataSourceImpl.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);



        // kasaru Future<bool> ayo??? whereee is thisss?????
    test('Should call SharedPreferences to cache the data'
    , () async {
      // we can only controll if the correct data is being stored into the SP
      // we cannot test if the data is actually present inside the SP

      // act
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
