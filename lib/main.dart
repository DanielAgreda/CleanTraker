import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/local_tracker_repository.dart';
import 'features/auth/tracker_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CleanTrackerApp());
}

class CleanTrackerApp extends StatelessWidget {
  const CleanTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // PUNTO ÚNICO DE INYECCIÓN:
        // Cuando llegue Supabase, reemplaza LocalTrackerRepository() por SupabaseTrackerRepository()
        ChangeNotifierProvider(
          create: (_) => TrackerProvider(LocalTrackerRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final trackerProvider = context.read<TrackerProvider>();
          final router = AppRouter.createRouter(trackerProvider);

          return MaterialApp.router(
            title: 'CleanTracker',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
