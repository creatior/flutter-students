enum FieldState { any, nullValue, notNull }

extension FieldStateExtension on FieldState {
  String get apiValue {
    switch (this) {
      case FieldState.any:
        return 'any';
      case FieldState.nullValue:
        return 'null';
      case FieldState.notNull:
        return 'not_null';
    }
  }
}
