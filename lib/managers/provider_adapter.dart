// Адаптер для менеджеру Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state_manager_base.dart';

class ProviderNotifier extends ChangeNotifier {
  void trigger() {
    notifyListeners();
  }
}

class ProviderAdapter extends StatelessWidget implements StateManagerAdapter {
  final Widget Function() builder;
  final ProviderNotifier notifier = ProviderNotifier();

  ProviderAdapter({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: notifier,
      child: Consumer<ProviderNotifier>(
        builder: (_, __, ___) => builder(),
      ),
    );
  }

  @override
  String get name => "Provider";

  @override
  void bindScenario(dynamic scenario) {
    scenario.onAction = notifier.trigger;
  }

  @override
  void dispose() {
    notifier.dispose();
  }
}
