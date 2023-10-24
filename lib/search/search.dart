
import 'package:app_peliculas/models/search_results.dart';
import 'package:app_peliculas/search/list_view_results.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {

  @override
  Animation<double> get transitionAnimation => CurvedAnimation(parent: transitionAnimation, curve: Curves.easeIn);

  @override
  String? get searchFieldLabel => "Buscar películas";
  
  
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        foregroundColor: Colors.white,
        color: Colors.blueGrey
      )
    );
  }


  @override
  TextStyle? get searchFieldStyle {
    return const TextStyle(
      color: Colors.white,
    );
  }

  @override
  InputDecorationTheme? get searchFieldDecorationTheme {
    return InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.white
      )
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
        onPressed: () => query = "", 
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.chevron_left_outlined, size: 35,)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    } 
    final movieProvider = Provider.of<MovieProvider>(context);
    
    if (movieProvider.movies.isEmpty || query != movieProvider.lastQuery) {
      return FutureBuilder(
        future: movieProvider.getSearchMovies(query), 
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          movieProvider.lastQuery = query;
          return ListViewResults(movieProvider: movieProvider, query: query);
        },
      );
    } else {
      return ListViewResults(movieProvider: movieProvider, query: query);
    }
  }

  Widget _emptyContainer() {
    return const SizedBox(
        child: Center(
          child: Icon(
            Icons.movie_creation_sharp, 
            color: Colors.grey,
            size: 100,
          ),
        ),
      );
  }
}

