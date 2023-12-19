import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/core/network/network_info.dart';

class MockIntenetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockIntenetConnectionChecker mockIntenetConnectionChecker;
  setUp(() {
    mockIntenetConnectionChecker = MockIntenetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockIntenetConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to InternetConnectionChecker.isConnected',
        () async {
      //arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockIntenetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      //act
      final result = networkInfoImpl.isConnected;
      //assert
      verify(mockIntenetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
