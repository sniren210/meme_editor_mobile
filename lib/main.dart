import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_mobile/core/theme/app_theme_extensions.dart';
import 'package:meme_editor_mobile/core/theme/theme_bloc.dart';
import 'package:meme_editor_mobile/features/presentation/pages/meme_home_page.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/splash_screen.dart';

import 'package:meme_editor_mobile/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ThemeBloc>()..add(LoadThemeEvent()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Meme Editor',
            theme: lightTheme,
            darkTheme: darkTheme,
            home: _showSplash
                ? SplashScreen(
                    onAnimationComplete: () {
                      setState(() {
                        _showSplash = false;
                      });
                    },
                  )
                : const MemeHomePage(),
            debugShowCheckedModeBanner: false,

            // Enhanced Material app configuration
            builder: (context, child) {
              return child!;
            },

            // Theme mode will be handled by our BLoC
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
