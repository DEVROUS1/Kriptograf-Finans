import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

void main() {
  runApp(const KriptoGrafApp());
}

class KriptoGrafApp extends StatelessWidget {
  const KriptoGrafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // Riverpod observer: debug modda tüm state değişikliklerini loglar
      observers: [if (true) _DebugObserver()],
      child: MaterialApp.router(
        title: 'KriptoGraf Finans',
        theme: AppTheme.dark(), // Material 3 dark theme
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _DebugObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Sadece development'ta aktif — production build'de tree-shake edilir
    assert(() {
      debugPrint('[Riverpod] ${provider.name ?? provider.runtimeType} updated');
      return true;
    }());
  }
}