import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'app_database.g.dart';
part 'students_table.dart';

@DriftDatabase(tables: [StudentsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}
