import 'dart:developer';

import 'package:app_peliculas/models/models.dart';
import 'package:app_peliculas/models/search_results.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class MovieProvider extends ChangeNotifier{

  //* Datos para conectarse a la API
  
  final String _apiKey                = '5fce8a72454cbc025879f138c2a85929';
  final String _baseUrl               = 'api.themoviedb.org';
  final String _language              = 'es-MX';
  final String _popularMoviesEndpoint = "/3/movie/popular";
  // final String _region                = "MX";

  //* Listas para las peliculas 
  
  List<PopularMoviesResponse> popularMovies = [];
  List<PopularMoviesResponse> popularMoviesFull = [];
  Map<String, List<Cast>> actors = {};
  List<Movie> movies = [];
  
  // Indicador de página para la petición de las peliculas populares

  int _popularMoviesPage = 0;
  int movieSearchPage = 1;

  String lastQuery = "";

  // Constructor para lanzar peticiones al levantar la aplicación

  MovieProvider() {
    getMovies(infinite: false, movieSection: MovieSection.popular);
    getMovies(infinite: true, movieSection: MovieSection.popular);
  }

  // Método encargado de traer los datos de la base de datos.
  // Este trae solamente la primera página de la petición (las peliculas mas populares).
  //* Retorna un Future<String> con los datos de la petición

  Future<String> getJsonDataMovies(String endpoint, [String page = "1"]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      "language" : _language,
      "page"     : page,
      "api_key"  : _apiKey,
    });

    var response = await http.get(url);
    return response.body;
  }

  // Método que hace una petición a la base de datos en busca de las peliculas populares.
  //* Retorna un future con todas las peliculas que el cliente pida.
  //* El atributo 'infinite' se utiliza para saber si 

  getMovies({required bool infinite, required Enum movieSection}) async {
    if (infinite) {
      if (movieSection == MovieSection.popular) {
        _popularMoviesPage++;
        final String response = await getJsonDataMovies(_popularMoviesEndpoint, _popularMoviesPage.toString());
        final popularMoviesResponse = PopularMovies.fromRawJson(response);
        popularMoviesFull = [...popularMoviesFull.toList(), ...popularMoviesResponse.results];
        notifyListeners();
      }
    
    } else if(popularMovies.isEmpty) {

      final response = await getJsonDataMovies(_popularMoviesEndpoint);
      final popularMoviesResponse = PopularMovies.fromRawJson(response);
      popularMovies = popularMoviesResponse.results.toList();
      notifyListeners();
    
    }
  }

  Future<Map<String, List<Cast>>> getCast(String movieId) async {
    if (!actors.containsKey(movieId)) {
      log("Se esta haciendo una petición");
      final url = Uri.https(_baseUrl, "/3/movie/$movieId/credits", {
      "language" : _language,
      "api_key"  : _apiKey,
      });

      final response = await http.get(url);
      final actorsResponse = ActorsResponse.fromRawJson(response.body);

      actors.addAll({
        movieId : actorsResponse.cast
      });
      
      return actors;   
    } else {
      return actors;   
    }

  }

  Future<List<Movie>> getSearchMovies(String query, {String page = "1"}) async {
      final url = Uri.https(_baseUrl, "/3/search/movie", {
        "language" : _language,
        "api_key"  : _apiKey,
        "query"    : query,
        "page"     : page
      });
      final response = await http.get(url);
      final searchResponse = SearchResults.fromRawJson(response.body);
      movies = searchResponse.results;
      notifyListeners();
      return movies;

  }


  Future<void> refresh() async{
    _popularMoviesPage = 0;
    popularMovies = [];
    popularMoviesFull = [];
    getMovies(infinite: false, movieSection: MovieSection.popular);
    getMovies(infinite: true, movieSection: MovieSection.popular);
    notifyListeners();
  }
}
