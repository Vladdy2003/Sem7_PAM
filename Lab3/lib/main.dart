import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/home/home_cubit.dart';
import 'data/health_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(MyApp(repository: JsonHealthRepository()));
}

class MyApp extends StatelessWidget {
  final HealthRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Repository-ul si HomeCubit sunt disponibile in toata aplicatia,
    // astfel favoritele raman sincronizate intre ecrane.
    return RepositoryProvider<HealthRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => HomeCubit(repository)..loadData(),
        child: MaterialApp(
          title: 'Health App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
