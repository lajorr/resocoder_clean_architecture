import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test text");

  test("Should be a subclass of NumberTrivia entity", () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group(
    'FromJson',
    () {
      test(
        'Should return a valid model When the JSON number is an integer',
        () async {
          //arrange
          // jsonMap mimics the actual data comming from api
          final Map<String, dynamic> jsonMap = json.decode(
            FixtureReader.fixture('trivia.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
      test(
        'Should return a valid model When the JSON number is regarded as a double',
        () async {
          //arrange
          // jsonMap mimics the actual data comming from api
          final Map<String, dynamic> jsonMap = json.decode(
            FixtureReader.fixture('trivia_double.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a json map containing the proper data',
        () {
          //arrange
          //act
          final result = tNumberTriviaModel.toJson();
          //assert

          final expectedMap = {
            "text": "test text",
            "number": 1,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
