import 'value_cubit.dart';

class StoragePermissionCubit extends ValueCubit<bool> {
  StoragePermissionCubit() : super(false);
}

class CameraPermissionCubit extends ValueCubit<bool> {
  CameraPermissionCubit() : super(false);
}

class NotificationPermissionCubit extends ValueCubit<bool> {
  NotificationPermissionCubit() : super(false);
}
