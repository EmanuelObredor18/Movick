import 'dart:async';
import 'dart:developer';

import 'package:app_peliculas/helpers/debouncer_bloc.dart';
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

  Debouncer _debouncer = Debouncer(milliseconds: 600);

  // Indicador de página para la petición de las peliculas populares

  int _popularMoviesPage = 0;
  int movieSearchPage = 1;

  // Ultimo query ingresado en la busqueda de peliculas
  String lastQuery = "";

  // Boleano para saber si hay mas resultados en la lista de peliculas de la base de datos
  bool hasMoreResults = true;
  bool isLoading = false;

  // Constructor para lanzar peticiones al levantar la aplicación
  MovieProvider() {
    getMovies(infinite: false, movieSection: MovieSection.popular);
    getMovies(infinite: true, movieSection: MovieSection.popular);
  }

  // Método encargado de traer los datos de la base de datos.
  // Este trae solamente la primera página de la petición (las peliculas mas populares).
  //* Retorna un Future<String> con los datos de la petición
  //* Se utiliza el paquete 'http' para las peticiones

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
  /* 
    * El atributo 'infinite' se utiliza para saber si la lista de peliculas se va a extender hasta el final
    * de la lista de peliculas de la base de datos
  */ 
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

  // Método para traer los actores

  Future<Map<String, List<Cast>>> getCast(String movieId) async {
    if (!actors.containsKey(movieId)) {
      log("Se esta haciendo una petición"); // Simple log de depuración
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

  getSearchResults(String query, {String page = "1"}) async{
      final url = Uri.https(_baseUrl, "/3/search/movie", {
        "language" : _language,
        "api_key"  : _apiKey,
        "query"    : query,
        "page"     : page
    });

    
    try {
    final response = await http.get(url);
      final searchResponse = SearchResults.fromRawJson(response.body);
      return searchResponse;
    } catch (e, stackTrace) {
      log('Error en la solicitud HTTP: $e');
      log('StackTrace: $stackTrace');
    }
  }


  Future<List<Movie>> getSearchMovies(String query, {String page = "1"}) async {
    if (query == lastQuery) {
      isLoading = true;
      notifyListeners();
      _debouncer.run(() async {
        print("Petición");
        final searchResponse = await getSearchResults(query, page: page); 
        if (searchResponse.results.isEmpty) {
          hasMoreResults = false;
        } else {
          movies = [...movies, ...searchResponse.results];
        }
        isLoading = false;
        notifyListeners();
      });
      return movies;
    } else {
      movies.clear();
      _debouncer.run(() async {
        print("Petición");
        final searchResponse = await getSearchResults(query, page: page);
        query = lastQuery;
        movieSearchPage = 1;
        movies = searchResponse.results;
        hasMoreResults = true;
        notifyListeners();
      });
      return movies;
    }
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
