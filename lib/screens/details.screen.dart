import 'package:app_peliculas/models/actors_response.dart';
import 'package:app_peliculas/models/trailers.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:app_peliculas/services/trailer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TrailerProvider trailerProvider = Provider.of<TrailerProvider>(context);

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    final dynamic movie = args['movies'] as dynamic;

    YoutubePlayerController playerController = YoutubePlayerController(
      initialVideoId: "KecoCV_L1OU",
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      )
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                  clipBehavior: Clip.antiAlias,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.7),
                      BlendMode.saturation
                    ),
                    child: Hero(
                      tag: movie.title,
                      child: FadeInImage(
                        placeholder: const AssetImage("assets/loading-bar.gif"),
                        image: NetworkImage(movie.fullUrlImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Header(movie: movie),
                      Overview(movie: movie),
                      ActorsSwiper(movie: movie),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          color: Colors.green,
                          height: 500,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Trailer")
                                ],
                              ),
                              FutureBuilder(
                                future: trailerProvider.getTrailerResponse(movie.id.toString()),
                                builder: (BuildContext context, AsyncSnapshot<TrailersResponse> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.trailerInfo != null) {
                                      return YoutubePlayer(
                                        controller: YoutubePlayerController(
                                          initialVideoId: snapshot.data!.trailerInfo![0].key,
                                          flags: YoutubePlayerFlags(
                                            autoPlay: true,
                                            mute: false
                                          )
                                        ),
                                      );
                                    } else {
                                      return Icon(Icons.movie_outlined);
                                    }
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActorsSwiper extends StatelessWidget {
  const ActorsSwiper({
    required this.movie,
    super.key,
  });

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()), 
      builder: (_, AsyncSnapshot<Map<String, List<Cast>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return ActorsSlider(actors: snapshot.data![movie.id.toString()]);
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 100),
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}

class ActorsSlider extends StatelessWidget {
  const ActorsSlider({
    super.key,
    required this.actors,
  });

  final List<Cast>? actors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: const Text("Elenco", style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 10,
                child: SizedBox(
                  width: 120,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: FadeInImage(
                          placeholder: const AssetImage("assets/loading-bar.gif"),
                          image: actors?[index].fullPosterPath != "" 
                            ? NetworkImage(actors?[index].fullPosterPath!)
                            : const AssetImage("assets/person_placeholder.png") as ImageProvider<Object>,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(actors![index].originalName, overflow: TextOverflow.clip, textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),
              itemCount: actors!.length,
              separatorBuilder: (_, __) => SizedBox(width: 20),
            ),
          ),
        ],
      ),
    );
  }
}
    
class Header extends StatelessWidget {
  const Header({
    required this.movie,
    super.key,
  });

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: movie,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: FadeInImage(
                height: 150,
                width: 100,
                fit: BoxFit.cover,
                placeholder: const AssetImage("assets/loading-bar.gif"),
                image: NetworkImage(
                    movie.fullUrlImage)),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movie.title, style: const TextStyle(fontSize: 25), overflow: TextOverflow.clip,),
              const SizedBox(height: 5),
              Text(movie.originalTitle, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.yellow, size: 30),
                  Text(movie.voteAverage.toString())
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class Overview extends StatelessWidget {
  const Overview({
    required this.movie,
    super.key,
  });

  final dynamic movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        child: Text(
          movie.overview,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
