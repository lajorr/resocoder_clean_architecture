import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => []; 
}

// yo failure ko thru respective exceptions haru call hunxa 
// failures and exceptions have one-to-one relationship.  

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
