

import 'dart:developer';

import 'package:app_peliculas/models/popular_movies_response.dart';
import 'package:flutter/material.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({
    super.key, 
    required this.moviesProvider,
    required this.sectionName, 
    required this.onNextPage,
  });
  
  final String sectionName;
  final List<PopularMoviesResponse> moviesProvider;
  final Function onNextPage;
  

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {

    super.initState();

    double? maxScrollTemp;

    scrollController.addListener(() {

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 800) {
        if(maxScrollTemp == scrollController.position.maxScrollExtent) {
          return;
        } else {
          widget.onNextPage();
          maxScrollTemp = scrollController.position.maxScrollExtent;
          log("Se realizo una petición de peliculas populares");
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    final double heightOfScreen = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: heightOfScreen * 0.42,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
            child: Text(
              widget.sectionName,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.moviesProvider.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    children: [
                      Hero(
                        tag: widget.moviesProvider[index],
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.pushNamed(
                                context, 
                                "/DetailsScreen", 
                                arguments: {
                                  'movies' : widget.moviesProvider[index],
                                },
                              ),
                            },
                            child: FadeInImage(
                              fit: BoxFit.fill,
                              height: 220,
                              width: 140,
                              placeholder: const AssetImage("assets/loading-bar.gif"),
                              image: NetworkImage(
                                widget.moviesProvider[index].fullUrlImage
                              )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.moviesProvider[index].title,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}
