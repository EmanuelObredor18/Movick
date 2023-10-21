import 'package:app_peliculas/models/search_results.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {

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
  // TODO: implement searchFieldDecorationTheme
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
    
    return FutureBuilder(
      future: movieProvider.getSearchMovies(query), 
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/loading-bar.gif"), 
                  image: NetworkImage(snapshot.data![index].fullPosterImg),
                  fit: BoxFit.fill,
                  width: 40,
                  height: 100,
                ),
              ),
              title: Text(snapshot.data![index].title),
            ), 
            separatorBuilder: (__, ___) => const SizedBox(height: 10), 
            itemCount: snapshot.data!.length
          );
        }
        return _emptyContainer();
      } ,
    );
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