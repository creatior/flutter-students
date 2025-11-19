import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_list/di/di.dart';
import 'package:students_list/features/students/domain/usecases/student_count_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_get_usecase.dart';
import 'package:students_list/features/students/domain/usecases/student_create_usecase.dart';
import 'package:students_list/features/students/domain/entities/student.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';
import 'package:students_list/features/students/presentation/blocs/student_bloc.dart';
import 'package:students_list/features/students/presentation/pages/student_filters_dialog.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentBloc(
        studentGetUsecase: di<StudentGetUsecase>(),
        studentCreateUsecase: di<StudentCreateUsecase>(),
        studentCountUsecase: di<StudentCountUsecase>(),
      )..add(const LoadStudentsEvent(filter: StudentFilter())),
      child: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.failure}')));
          } else if (state is StudentCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add student failed: ${state.message}')),
            );
          } else if (state is StudentCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Student added successfully')),
            );
          }
        },
        builder: (context, state) {
          Widget body;

          if (state is StudentLoading || state is StudentInitial) {
            body = const Center(child: CircularProgressIndicator());
          } else if (state is StudentEmpty) {
            body = const Center(child: Text('No students found'));
          } else if (state is StudentSuccess) {
            final students = state.students;
            final studentBloc = context.read<StudentBloc>();

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Students',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          _showAddStudentDialog(context, studentBloc),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            return StudentFiltersDialog(
                              currentFilter: state.filter,
                              onApply: (filter) {
                                studentBloc.add(
                                  LoadStudentsEvent(filter: filter),
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filters'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 32,
                          headingRowColor: MaterialStateProperty.all(
                            Colors.blueGrey.shade50,
                          ),
                          dataRowColor: MaterialStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.blueGrey.shade100;
                            }
                            return null;
                          }),
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
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: state.currentPage > 0
                          ? () => studentBloc.add(
                              ChangePageEvent(state.currentPage - 1),
                            )
                          : null,
                      child: const Text('Previous'),
                    ),
                    const SizedBox(width: 16),
                    Text('Page: ${state.currentPage + 1}'),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: !state.isLastPage
                          ? () => studentBloc.add(
                              ChangePageEvent(state.currentPage + 1),
                            )
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is StudentError) {
            body = Center(
              child: ElevatedButton(
                onPressed: () => context.read<StudentBloc>().add(
                  const RefreshStudentsEvent(),
                ),
                child: const Text('Retry'),
              ),
            );
          } else {
            body = const SizedBox.shrink();
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SafeArea(
              child: Padding(padding: const EdgeInsets.all(16.0), child: body),
            ),
          );
        },
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context, StudentBloc studentBloc) {
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _middleNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _telegramController = TextEditingController();
    final _gitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Добавить студента'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_firstNameController, 'First Name'),
                _buildTextField(_lastNameController, 'Last Name'),
                _buildTextField(_middleNameController, 'Middle Name'),
                _buildTextField(_emailController, 'Email'),
                _buildTextField(_phoneController, 'Phone'),
                _buildTextField(_telegramController, 'Telegram'),
                _buildTextField(_gitController, 'Git'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final student = Student(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  middleName: _middleNameController.text.trim().isEmpty
                      ? null
                      : _middleNameController.text.trim(),
                  email: _emailController.text.trim().isEmpty
                      ? null
                      : _emailController.text.trim(),
                  phoneNumber: _phoneController.text.trim().isEmpty
                      ? null
                      : _phoneController.text.trim(),
                  telegram: _telegramController.text.trim().isEmpty
                      ? null
                      : _telegramController.text.trim(),
                  git: _gitController.text.trim().isEmpty
                      ? null
                      : _gitController.text.trim(),
                  fullName:
                      '${_lastNameController.text.trim()} ${_firstNameController.text.trim().substring(0, 1)}. ${_middleNameController.text.trim().isEmpty ? '' : _middleNameController.text.trim().substring(0, 1) + '.'}',
                );

                studentBloc.add(StudentAddEvent(student));
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
