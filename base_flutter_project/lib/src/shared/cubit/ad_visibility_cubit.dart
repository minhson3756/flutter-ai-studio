import 'value_cubit.dart';

class AdVisibilityCubit extends ValueCubit<bool> {
  AdVisibilityCubit() : super(true);

  void show() {
    emit(true);
  }

  void hide() {
    emit(false);
  }
}
