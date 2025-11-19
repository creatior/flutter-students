import 'package:flutter/material.dart';
import 'package:students_list/features/students/common/enums/field_state.dart';
import 'package:students_list/features/students/domain/entities/student_filter.dart';

class StudentFiltersDialog extends StatefulWidget {
  final StudentFilter currentFilter;
  final void Function(StudentFilter) onApply;

  const StudentFiltersDialog({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<StudentFiltersDialog> createState() => _StudentFiltersDialogState();
}

class _StudentFiltersDialogState extends State<StudentFiltersDialog> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController middleNameController;
  late final TextEditingController telegramController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController gitController;

  late FieldState firstNameState;
  late FieldState lastNameState;
  late FieldState middleNameState;
  late FieldState telegramState;
  late FieldState emailState;
  late FieldState phoneState;
  late FieldState gitState;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(
      text: widget.currentFilter.firstName,
    );
    lastNameController = TextEditingController(
      text: widget.currentFilter.lastName,
    );
    middleNameController = TextEditingController(
      text: widget.currentFilter.middleName,
    );
    telegramController = TextEditingController(
      text: widget.currentFilter.telegramValue,
    );
    emailController = TextEditingController(
      text: widget.currentFilter.emailValue,
    );
    phoneController = TextEditingController(
      text: widget.currentFilter.phoneNumberValue,
    );
    gitController = TextEditingController(text: widget.currentFilter.gitValue);

    firstNameState = widget.currentFilter.firstName != null
        ? FieldState.notNull
        : FieldState.any;
    lastNameState = widget.currentFilter.lastName != null
        ? FieldState.notNull
        : FieldState.any;
    middleNameState = widget.currentFilter.middleName != null
        ? FieldState.notNull
        : FieldState.any;
    telegramState = widget.currentFilter.telegramState ?? FieldState.any;
    emailState = widget.currentFilter.emailState ?? FieldState.any;
    phoneState = widget.currentFilter.phoneNumberState ?? FieldState.any;
    gitState = widget.currentFilter.gitState ?? FieldState.any;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    telegramController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gitController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required FieldState state,
    required void Function(FieldState?) onStateChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButton<FieldState>(
            value: state,
            isExpanded: true,
            onChanged: onStateChanged,
            items: FieldState.values.map((fs) {
              String text;
              switch (fs) {
                case FieldState.any:
                  text = 'Any';
                  break;
                case FieldState.nullValue:
                  text = 'Null';
                  break;
                case FieldState.notNull:
                  text = 'Not null';
                  break;
              }
              return DropdownMenuItem(value: fs, child: Text(text));
            }).toList(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            enabled: state == FieldState.notNull,
            decoration: InputDecoration(labelText: label),
          ),
        ),
      ],
    );
  }

  void _applyFilters() {
    final newFilter = StudentFilter(
      firstName: firstNameState == FieldState.notNull
          ? (firstNameController.text.isEmpty ? null : firstNameController.text)
          : null,
      lastName: lastNameState == FieldState.notNull
          ? (lastNameController.text.isEmpty ? null : lastNameController.text)
          : null,
      middleName: middleNameState == FieldState.notNull
          ? (middleNameController.text.isEmpty
                ? null
                : middleNameController.text)
          : null,
      telegramState: telegramState,
      telegramValue: telegramState == FieldState.notNull
          ? telegramController.text
          : null,
      emailState: emailState,
      emailValue: emailState == FieldState.notNull
          ? emailController.text
          : null,
      phoneNumberState: phoneState,
      phoneNumberValue: phoneState == FieldState.notNull
          ? phoneController.text
          : null,
      gitState: gitState,
      gitValue: gitState == FieldState.notNull ? gitController.text : null,
    );

    widget.onApply(newFilter);
    Navigator.pop(context);
  }

  void _clearFilters() {
    firstNameController.clear();
    lastNameController.clear();
    middleNameController.clear();
    telegramController.clear();
    emailController.clear();
    phoneController.clear();
    gitController.clear();

    firstNameState = FieldState.any;
    lastNameState = FieldState.any;
    middleNameState = FieldState.any;
    telegramState = FieldState.any;
    emailState = FieldState.any;
    phoneState = FieldState.any;
    gitState = FieldState.any;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'First Name',
              controller: firstNameController,
              state: firstNameState,
              onStateChanged: (v) =>
                  setState(() => firstNameState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Last Name',
              controller: lastNameController,
              state: lastNameState,
              onStateChanged: (v) =>
                  setState(() => lastNameState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Middle Name',
              controller: middleNameController,
              state: middleNameState,
              onStateChanged: (v) =>
                  setState(() => middleNameState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Telegram',
              controller: telegramController,
              state: telegramState,
              onStateChanged: (v) =>
                  setState(() => telegramState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Email',
              controller: emailController,
              state: emailState,
              onStateChanged: (v) =>
                  setState(() => emailState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Phone Number',
              controller: phoneController,
              state: phoneState,
              onStateChanged: (v) =>
                  setState(() => phoneState = v ?? FieldState.any),
            ),
            _buildField(
              label: 'Git',
              controller: gitController,
              state: gitState,
              onStateChanged: (v) =>
                  setState(() => gitState = v ?? FieldState.any),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
