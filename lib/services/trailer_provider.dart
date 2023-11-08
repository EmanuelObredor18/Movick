
import 'dart:developer';

import 'package:app_peliculas/models/trailers.dart';
import 'package:app_peliculas/services/connection/connection_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TrailerProvider extends ChangeNotifier {
  
  TrailerProvider() {
    getTrailerResponse("2661");
  }

  Future<TrailersResponse> getTrailerResponse(String movieId) async{
    final url = Uri.https(ConnectionData.baseUrl, "/3/movie/$movieId/videos",
      {
        "api_key"  : ConnectionData.apiKey,
        "language" : ConnectionData.languageTrailer,
        "movie_id" : movieId
      }
    );

    final response = await http.get(url);
    final trailerResponse = TrailersResponse.fromRawJson(response.body);
    return trailerResponse;
  }


}