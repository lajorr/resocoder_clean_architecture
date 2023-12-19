// ignore_for_file: public_member_api_docs, sort_constructors_first
//we are just creating a contract here....what is a contract? idkkk ( just yo kura xa hai vanera vaneko hola)
// that is why this is an abstract class

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {

  //* All this class does is call a function from InternetConnectioChecker Package
  //? euta function call ko lai xutta class kina chaiyp?
  // kinavane in case u wanna use a different package for checking the connection, u can do so by only changing this class..!!
  final InternetConnectionChecker connectionChecker;
  NetworkInfoImpl(
    this.connectionChecker,
  );
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
