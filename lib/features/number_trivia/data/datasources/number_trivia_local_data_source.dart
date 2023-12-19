import 'dart:convert';

import 'package:resocoder_clean_architecture/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was cached the last time user had internet
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString == null) {
      throw CacheException();
    } else {
      return NumberTriviaModel.fromJson(json.decode(jsonString));
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel? triviaToCache) async {
    // debugPrint("asda$triviaToCache");

    sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(
        triviaToCache!.toJson(),
      ),
    );
  }
}
