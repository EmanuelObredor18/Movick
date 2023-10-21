import 'package:app_peliculas/models/movie_geners.dart';
import 'package:app_peliculas/search/search.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MovieProvider moviesProvider = Provider.of<MovieProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => showSearch(context: context, delegate: Search()),
            ),
          )
        ],
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Center(child: Text("Peliculas App")),
        ),
      ),
      body: SafeArea(
        child: moviesProvider.popularMovies.isNotEmpty ? RefreshIndicator(
          onRefresh: () => moviesProvider.refresh(),
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CardSwiper(movies: moviesProvider.popularMovies),
                MovieSlider(
                  moviesProvider: moviesProvider.popularMoviesFull,
                  sectionName: "Populares",
                  onNextPage: () {
                    moviesProvider.getMovies(infinite: true, movieSection: MovieSection.popular);
                  },
                ),
              ]
            ),
          ),
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

