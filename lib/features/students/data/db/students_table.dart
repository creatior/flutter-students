part of 'app_database.dart';

class StudentsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get firstName => text()();

  TextColumn get lastName => text().nullable()();
  TextColumn get middleName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get telegram => text().nullable()();
  TextColumn get git => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
