import 'package:app_peliculas/models/popular_movies_response.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';


class CardSwiper extends StatefulWidget {
  const CardSwiper({
    super.key, 
    required this.movies,
  });

  final List<PopularMoviesResponse> movies;

  @override
  State<CardSwiper> createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  @override
  Widget build(BuildContext context) {

    final double heightOfScreen = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: heightOfScreen * 0.50,
      child: Center(
        child: Swiper(
          itemBuilder: (_, index) => GestureDetector(
            onTap: () => {
              Navigator.pushNamed(
                context, 
                "/DetailsScreen", 
                arguments: {
                  'movies' : widget.movies[index],
                },
              ),
            },
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: widget.movies[index],
                child: FadeInImage(
                  image: NetworkImage(widget.movies[index].fullUrlImage),
                  placeholder: const AssetImage("assets/camera_placeholder.jpg"),
                  fit: BoxFit.fill,
                  fadeInDuration: const Duration(seconds: 1),
                        
                ),
              ),
            ),
          ),
          onTap: (int number){

          },
          itemWidth: 200,
          itemHeight: 350,
          itemCount: widget.movies.length,
          autoplayDisableOnInteraction: true,
          curve: decelerateEasing,
          scrollDirection: Axis.horizontal,
          layout: SwiperLayout.STACK,
        ),
      ),
    );
  }
}
