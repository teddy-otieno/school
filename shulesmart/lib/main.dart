// ignore_for_file: non_constant_identifier_names

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shulesmart/repository/conn_client.dart';

import 'package:shulesmart/screens/splash_screen.dart';
import 'package:shulesmart/utils/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: AppStateSerializer(),
  );

  final initial_state = await persistor.load();

  if (initial_state != null) {
    ApiClient.get_instance().init(initial_state.session?.token);
  }

  final store = Store<AppState>(
    reducer,
    initialState: initial_state ?? AppState(),
    middleware: [persistor.createMiddleware()],
  );

  runApp(MyApp(store: store));
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  final brand_blue = const Color(0xff7400b8);

  const MyApp({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CustomColors lightCustomColors =
        const CustomColors(danger: Color(0xFFE53935));
    CustomColors darkCustomColors =
        const CustomColors(danger: Color(0xFFEF9A9A));

    return StoreProvider<AppState>(
      store: store,
      child: DynamicColorBuilder(
        builder: (light_dynamic, dark_dynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (light_dynamic != null && dark_dynamic != null) {
            lightColorScheme = light_dynamic.harmonized();
            lightColorScheme = lightColorScheme.copyWith();
            lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

            darkColorScheme = dark_dynamic.harmonized();
            darkColorScheme = darkColorScheme.copyWith();
            darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

            // _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
          } else {
            // Otherwise, use fallback schemes.
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: brand_blue,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: brand_blue,
              brightness: Brightness.dark,
            );
          }

          return MaterialApp(
            title: 'Shule Smart',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: brand_blue),
              useMaterial3: true,
              extensions: [lightCustomColors],
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              extensions: [darkCustomColors],
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
