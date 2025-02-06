import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/presentation/bloc/task/task_bloc.dart';
import 'package:taskmanager/presentation/bloc/task/task_event.dart';
import 'package:intl/intl.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  AddEditTaskPage({Key? key, this.task}) : super(key: key);

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  String? _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _dueDateController = TextEditingController(
      text: widget.task != null
          ? DateFormat('yyyy-MM-dd').format(widget.task!.dueDate)
          : '',
    );
    _priority = widget.task?.priority ?? 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
        backgroundColor: Color(0xFF57018a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_titleController, "Title"),
              SizedBox(height: 12),
              _buildTextField(_descriptionController, "Description"),
              SizedBox(height: 12),
              _buildDatePickerField(),
              SizedBox(height: 12),
              _buildPriorityDropdown(),
              SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a $label";
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: _dueDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Due Date",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF57018a)),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            _dueDateController.text =
                DateFormat('yyyy-MM-dd').format(selectedDate);
          });
        }
      },
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _priority,
      items: ['Low', 'Medium', 'High']
          .map((priority) =>
              DropdownMenuItem(value: priority, child: Text(priority)))
          .toList(),
      onChanged: (value) => setState(() => _priority = value),
      decoration: InputDecoration(
        labelText: "Priority",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF57018a),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text("Save",
            style: TextStyle(
                fontFamily: 'Satoshi', fontSize: 18, color: Colors.white)),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: DateFormat('yyyy-MM-dd').parse(_dueDateController.text),
        priority: _priority!,
      );

      if (widget.task == null) {
        BlocProvider.of<TaskBloc>(context).add(CreateTaskEvent(task));
      } else {
        BlocProvider.of<TaskBloc>(context).add(EditTaskEvent(task));
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}
