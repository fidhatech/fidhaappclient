import 'package:flutter/material.dart';
import 'gradient_scaffold_styles.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const GradientScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final styles = GradientScaffoldStyles();

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      extendBody: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SizedBox.expand(
        child: Container(decoration: styles.gradientBackground(), child: body),
      ),
    );
  }
}
