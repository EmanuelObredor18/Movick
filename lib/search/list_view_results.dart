import 'package:app_peliculas/models/search_results.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:flutter/material.dart';

class ListViewResults extends StatefulWidget {
  const ListViewResults({super.key, required this.movieProvider, required this.query});

  final MovieProvider movieProvider;
  final String query;


  @override
  State<ListViewResults> createState() => _ListViewResultsState();
  
}

class _ListViewResultsState extends State<ListViewResults> {

  bool isLoading = false;
  List<Movie> movies = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {

      double maxScroll = _scrollController.position.maxScrollExtent;
      double scrollPosition = _scrollController.position.pixels;
      double? maxScrollTemp;

      if (scrollPosition >= maxScroll - 100) {
        if (maxScrollTemp == maxScroll) {
          return;
        } else {
          if (widget.movieProvider.hasMoreResults) {
            widget.movieProvider.getSearchMovies(widget.query, page: widget.movieProvider.movieSearchPage.toString());
            widget.movieProvider.movieSearchPage++;
            maxScrollTemp = maxScroll;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    movies = widget.movieProvider.movies;

    return widget.movieProvider.movies.isNotEmpty ? Stack(
      children: [
        ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => GestureDetector(
              onTap: () => Navigator.pushNamed(
                context, 
                '/DetailsScreen',
                arguments: {'movies' : movies[index]}
              ),
              child: ListTile(
                leading: Hero(
                  tag: movies[index ],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/loading-bar.gif"), 
                      image: movies[index].fullUrlImage != "" ? NetworkImage(movies[index].fullUrlImage)
                      : AssetImage("assets/camera_placeholder.jpg") as ImageProvider,
                      fit: BoxFit.fill,
                      width: 40,
                      height: 100,
                    ),
                  ),
                ),
                title: Text(movies[index].title),
              ),
            ), 
            separatorBuilder: (__, ___) => const SizedBox(height: 10), 
            itemCount: movies.length,
          ),
          Positioned(
            child: widget.movieProvider.isLoading ? CircularProgressIndicator() : SizedBox(),
            top: MediaQuery.sizeOf(context).height - 120,
            right: MediaQuery.sizeOf(context).width * 0.50 - 10,
            
          )
      ],
    ) 
      : Center(
        child: CircularProgressIndicator(),
      );
  }
    
}
