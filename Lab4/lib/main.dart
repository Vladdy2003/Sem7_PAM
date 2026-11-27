import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/repositories/health_repository.dart';
import 'domain/usecases/get_appointment_details.dart';
import 'domain/usecases/get_home_feed.dart';
import 'injection_container.dart';
import 'presentation/cubits/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_colors.dart';

void main() {
  runApp(MyApp(repository: createHealthRepository()));
}

class MyApp extends StatelessWidget {
  final HealthRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Use case-urile (Domain) sunt disponibile in toata aplicatia.
    // HomeCubit e global, astfel favoritele raman sincronizate intre ecrane.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GetHomeFeed(repository)),
        RepositoryProvider(create: (_) => GetAppointmentDetails(repository)),
      ],
      child: BlocProvider(
        create: (context) => HomeCubit(context.read<GetHomeFeed>())..loadData(),
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
