import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state_manager_base.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class RiverpodAdapter extends ConsumerStatefulWidget {
  final Widget Function(WidgetRef, int) builder;

  const RiverpodAdapter({Key? key, required this.builder}) : super(key: key);

  @override
  ConsumerState<RiverpodAdapter> createState() => _RiverpodAdapterState();
}

class _RiverpodAdapterState extends ConsumerState<RiverpodAdapter>
    implements StateManagerAdapter {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(counterProvider);
    return widget.builder(ref, value);
  }

  @override
  String get name => "Riverpod";

  @override
  void bindScenario(dynamic scenario) {
    scenario.onAction = () {
      ref.read(counterProvider.notifier).state++;
    };
  }

  @override
  void dispose() {
    super.dispose();
  }
}
