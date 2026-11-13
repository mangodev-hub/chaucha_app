// Cambia entre vista de teléfono y vista de escritorio.
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.mobile, this.desktop});

  static const double desktopBreakpoint = 900;

  final Widget mobile;

  final Widget? desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useDesktop =
            constraints.maxWidth >= desktopBreakpoint && desktop != null;
        return useDesktop ? desktop! : mobile;
      },
    );
  }
}
