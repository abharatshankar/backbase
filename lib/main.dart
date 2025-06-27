import 'package:backbase/data/datasources/bool_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'data/datasources/book_remote_datasource.dart';
import 'data/datasources/book_local_datasource.dart';
import 'data/repositories/book_repository_impl.dart';
import 'domain/repositories/book_repository.dart';
import 'presentation/providers/book_provider.dart';
import 'presentation/screens/search_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  final remote = BookRemoteDatasource(http.Client());
  final local = BookLocalDatasource();
  final repo = BookRepositoryImpl(remote, local);

  runApp(MyApp(repository: repo));
}

class MyApp extends StatelessWidget {
  final BookRepository repository;
  const MyApp({required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider(repository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Finder',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: SearchScreen(),
      ),
    );
  }
}
