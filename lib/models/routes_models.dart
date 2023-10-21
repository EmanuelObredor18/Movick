import 'package:flutter/material.dart';

//* RoutesModels is a simple class where routes are constructed.


class RoutesModel {
  
  // Atribute for route name
  final String routeName;

  // Widget to which the route is sent
  final Widget routeWidget;

  RoutesModel({required this.routeName, required this.routeWidget});

}