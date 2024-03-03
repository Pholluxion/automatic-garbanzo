import 'package:flutter/material.dart';

import 'package:client/features/wallet/presentation/widgets/widgets.dart';

class AppScaffold extends StatelessWidget {

  const AppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.persistentFooterButtons,
    this.actions,
  });
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final List<Widget> persistentFooterButtons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: AppBar(title: Text(title), actions: actions),
      bottomNavigationBar: const BottomBar(),
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }
}
