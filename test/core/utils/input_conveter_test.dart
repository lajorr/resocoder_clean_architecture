import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'Should return an integer when the string represents an Unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, const Right(123));
    });

    test('Should return a failure when the String is not integer', () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('Should return a failure when the String is negative integer', () async {
      // arrange
      const str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
