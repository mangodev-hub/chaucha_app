import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'marca.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Espacios.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Marca.vertical(grande: true, sobreOscuro: true),
              SizedBox(height: Espacios.xl),
              SizedBox(width: 120, child: LinearProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
