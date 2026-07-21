import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:submission/controller/home_controller.dart';
import 'package:submission/core/app_theme.dart';
import 'package:submission/services/food_classifier_service.dart';
import 'package:submission/services/gemini_service.dart';
import 'package:submission/services/image_source_service.dart';
import 'package:submission/services/mealdb_service.dart';
import 'package:submission/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Service jangka panjang (satu instance dipakai di seluruh app).
        Provider<FoodClassifierService>(
          create: (_) => FoodClassifierService(),
          dispose: (_, service) => service.close(),
        ),
        Provider<ImageSourceService>(create: (_) => ImageSourceService()),
        Provider<MealDbService>(
          create: (_) => MealDbService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<GeminiService>(create: (_) => GeminiService()),

        // Controller Home dibuat sekali di root karena memuat model ML saat
        // aplikasi start dan dipakai selama HomePage aktif.
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(
            classifierService: context.read<FoodClassifierService>(),
            imageSourceService: context.read<ImageSourceService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Food Recognizer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomePage(),
      ),
    );
  }
}
