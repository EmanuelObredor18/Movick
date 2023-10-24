import 'package:app_peliculas/models/actors_response.dart';
import 'package:app_peliculas/services/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    final dynamic movie = args['movies'] as dynamic;

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
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Elenco", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 120,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
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
                      const SizedBox(height: 10),
                      Text(actors![index].originalName, overflow: TextOverflow.clip),
                    ],
                  ),
                ),
              ),
              itemCount: actors?.length,
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
