import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(
    number: tNumber,
    text: 'test',
  );

  test(
    'Should get trivia for the number from the repository',
    () async {
      //arrange

      // this is sort of like defining??
      // not exactly defining but we have not actually created/ defined/ implemented this "getConcreteNumberTrivia()" function but
      // yo lines of code le chai tyo function call vayo vane "Right(tNumberTrivia)" return gara vandai xa hola ????
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
        (realInvocation) async => const Right(
            tNumberTrivia), // right le NumberTrivia ko instance return garxa????
      );

      //act
      final result = await usecase(
        const Params(
          number: tNumber,
        ),
      );

      //assert
      expect(result, const Right(tNumberTrivia));

      //this i dont know
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
