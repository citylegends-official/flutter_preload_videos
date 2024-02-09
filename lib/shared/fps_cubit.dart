import 'package:bloc/bloc.dart';

class FpsCubit extends Cubit<bool> {
  FpsCubit() : super(true);

  void toggleFps() => emit(!state);
}
