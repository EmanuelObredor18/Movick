import 'package:app_peliculas/services/movie_provider.dart';
import 'package:app_peliculas/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:app_peliculas/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider(), lazy: false),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routes.getRoutes(),
      initialRoute: Routes.initialRoute,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
    );
  }
}
