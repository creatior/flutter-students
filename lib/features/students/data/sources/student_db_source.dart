import 'package:students_list/features/students/common/enums/field_state.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';

import '../db/app_database.dart';
import '../../domain/entities/student.dart';
import 'package:drift/drift.dart';

class StudentDbSource {
  final AppDatabase db;

  StudentDbSource(this.db);

  Future<List<Student>> getStudents({StudentFilter? filter}) async {
    final query = db.select(db.studentsTable);

    if (filter != null) {
      void applyFilter(TextColumn column, FieldState? state, String? value) {
        if (state == null || state == FieldState.any) return;

        switch (state) {
          case FieldState.notNull:
            if (value?.isNotEmpty ?? false) {
              query.where((tbl) => column.like('%$value%'));
            }
            break;
          case FieldState.nullValue:
            query.where((tbl) => column.isNull());
            break;
          case FieldState.any:
            break;
        }
      }

      applyFilter(
        db.studentsTable.telegram,
        filter.telegramState,
        filter.telegramValue,
      );
      applyFilter(db.studentsTable.email, filter.emailState, filter.emailValue);
      applyFilter(
        db.studentsTable.phoneNumber,
        filter.phoneNumberState,
        filter.phoneNumberValue,
      );
      applyFilter(db.studentsTable.git, filter.gitState, filter.gitValue);

      if (filter.firstName?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.firstName.like('%${filter.firstName}%'));
      }
      if (filter.lastName?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.lastName.like('%${filter.lastName}%'));
      }
      if (filter.middleName?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.middleName.like('%${filter.middleName}%'));
      }

      if (filter.telegramValue?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.telegram.like('%${filter.telegramValue}%'));
      }
      if (filter.emailValue?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.email.like('%${filter.emailValue}%'));
      }
      if (filter.phoneNumberValue?.isNotEmpty ?? false) {
        query.where(
          (tbl) => tbl.phoneNumber.like('%${filter.phoneNumberValue}%'),
        );
      }
      if (filter.gitValue?.isNotEmpty ?? false) {
        query.where((tbl) => tbl.git.like('%${filter.gitValue}%'));
      }

      if (filter.offset != null) {
        query.limit(filter.limit ?? 15, offset: filter.offset);
      } else if (filter.limit != null) {
        query.limit(filter.limit ?? 15);
      }
    }

    final rows = await query.get();

    return rows.map((row) {
      final fullName =
          '${row.lastName} ${row.firstName}${row.middleName != null ? ' ${row.middleName}' : ''}';
      return Student(
        id: row.id,
        firstName: row.firstName,
        lastName: row.lastName ?? '',
        middleName: row.middleName,
        email: row.email,
        phoneNumber: row.phoneNumber,
        telegram: row.telegram,
        git: row.git,
        fullName: fullName,
      );
    }).toList();
  }

  Future<void> saveStudents(List<Student> students) async {
    await db.delete(db.studentsTable).go();

    await db.batch((batch) {
      batch.insertAll(
        db.studentsTable,
        students
            .map(
              (s) => StudentsTableCompanion(
                id: Value(s.id),
                firstName: Value(s.firstName),
                lastName: Value(s.lastName),
                middleName: Value(s.middleName),
                email: Value(s.email),
                phoneNumber: Value(s.phoneNumber),
                telegram: Value(s.telegram),
                git: Value(s.git),
              ),
            )
            .toList(),
      );
    });
  }
}
