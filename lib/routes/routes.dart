import 'package:app_peliculas/models/routes_models.dart';
import 'package:app_peliculas/screens/screens.dart';
import 'package:flutter/material.dart';

class Routes {
  static final initialRoute = _routes[0].routeName;

  static final _routes = <RoutesModel>[
    RoutesModel(routeName: "/HomeScreen", routeWidget: const HomeScreen()),
    RoutesModel(routeName: "/DetailsScreen", routeWidget: const DetailsScreen())
  ];

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};

    for (var item in _routes) {
      routes.addAll({item.routeName: (p0) => item.routeWidget});
    }

    return routes;
  }
}
