import 'package:bloc/bloc.dart';

class FpsCubit extends Cubit<bool> {
  FpsCubit() : super(false);

  void toggleFps() => emit(!state);
}
