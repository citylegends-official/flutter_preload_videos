import 'package:bloc/bloc.dart';

class FPSCubit extends Cubit<bool> {
  FPSCubit() : super(false);

  void toggleFps() => emit(!state);
}
