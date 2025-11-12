import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/di/di.dart';
import 'package:students_list/features/students/domain/usecases/student_get_usecase.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/presentation/blocs/student_bloc.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StudentBloc(studentGetUsecase: di<StudentGetUsecase>())
            ..add(const LoadStudentsEvent(filter: StudentFilter())),
      child: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.failure}')));
          }
        },
        builder: (context, state) {
          if (state is StudentLoading || state is StudentInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is StudentEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Students')),
              body: const Center(child: Text('No students found')),
            );
          }

          if (state is StudentSuccess) {
            final students = state.students;
            return Scaffold(
              appBar: AppBar(title: const Text('Students')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Full Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Telegram')),
                            DataColumn(label: Text('Git')),
                          ],
                          rows: students.map((student) {
                            return DataRow(
                              cells: [
                                DataCell(Text(student.fullName)),
                                DataCell(Text(student.email ?? '-')),
                                DataCell(Text(student.phoneNumber ?? '-')),
                                DataCell(Text(student.telegram ?? '-')),
                                DataCell(Text(student.git ?? '-')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: state.currentPage > 0
                              ? () => context.read<StudentBloc>().add(
                                  ChangePageEvent(state.currentPage - 1),
                                )
                              : null,
                          child: const Text('Previous'),
                        ),
                        const SizedBox(width: 16),
                        Text('Page: ${state.currentPage + 1}'),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: !state.isLastPage
                              ? () => context.read<StudentBloc>().add(
                                  ChangePageEvent(state.currentPage + 1),
                                )
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is StudentError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Students')),
              body: Center(
                child: ElevatedButton(
                  onPressed: () => context.read<StudentBloc>().add(
                    const RefreshStudentsEvent(),
                  ),
                  child: const Text('Retry'),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
