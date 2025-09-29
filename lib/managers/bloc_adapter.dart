// Адаптер для менеджеру Bloc
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state_manager_base.dart';

/// Проста подія
class UpdateEvent {}

/// Стейт BLoC
class CounterState {
  final int value;
  CounterState(this.value);
}

/// BLoC
class TestBloc extends Bloc<UpdateEvent, CounterState> {
  TestBloc() : super(CounterState(0)) {
    on<UpdateEvent>((event, emit) => emit(CounterState(state.value + 1)));
  }

  void trigger() => add(UpdateEvent());
}

/// Адаптер
class BlocAdapter extends StatelessWidget implements StateManagerAdapter {
  final Widget Function(BuildContext, int) builder;
  late final TestBloc bloc;

  BlocAdapter({Key? key, required this.builder}) : super(key: key) {
    bloc = TestBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<TestBloc, CounterState>(
        builder: (context, state) => builder(context, state.value),
      ),
    );
  }

  @override
  String get name => "BLoC";

  @override
  void bindScenario(dynamic scenario) {
    scenario.onAction = bloc.trigger;
  }

  @override
  void dispose() {
    bloc.close();
  }
}
