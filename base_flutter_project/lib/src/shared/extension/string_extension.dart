

extension StringExtension on String? {
  bool get isValid {
    if (this != null && this!.isNotEmpty) {
      return true;
    }
    return false;
  }
}
