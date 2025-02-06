import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/presentation/bloc/task/task_bloc.dart';
import 'package:taskmanager/presentation/bloc/task/task_event.dart';
import 'package:taskmanager/presentation/bloc/task/task_state.dart';
import 'package:taskmanager/presentation/pages/add_edit_task_page.dart';
import 'package:taskmanager/presentation/pages/profile_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  String searchQuery = ''; // Default search query
  String selectedPriority = 'All'; // Default priority filter
  String selectedStatus = 'All'; // Default status filter (all tasks)

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF57018a),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          onChanged: (query) {
                            searchQuery = query;
                            context
                                .read<TaskBloc>()
                                .add(SearchTasksEvent(searchQuery));
                          },
                          decoration: InputDecoration(
                            hintText: "Search tasks...",
                            hintStyle: TextStyle(
                                fontFamily: 'Satoshi', color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white24,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () => _showPriorityStatusFilterDialog(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "My Tasks",
                  style: TextStyle(
                      fontFamily: 'Satoshi', color: Colors.white, fontSize: 24),
                ),
                Text(
                  "${DateFormat('MMMM dd, yyyy').format(DateTime.now())}",
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: Colors.white70,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TaskError) {
                    return Center(child: Text(state.message));
                  } else if (state is TaskLoaded) {
                    List<Task> tasks = state.tasks;

                    // Filter tasks based on priority, status, and search query
                    tasks = tasks.where((task) {
                      bool matchesPriority = selectedPriority == 'All' ||
                          task.priority == selectedPriority;
                      bool matchesStatus = selectedStatus == 'All' ||
                          (selectedStatus == 'completed' && task.isCompleted) ||
                          (selectedStatus == 'incomplete' && !task.isCompleted);
                      bool matchesSearch = task.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                      return matchesPriority && matchesStatus && matchesSearch;
                    }).toList();

                    if (tasks.isEmpty) {
                      return Center(child: Text("No tasks available"));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTaskSection(
                              "Today",
                              tasks
                                  .where((task) =>
                                      DateFormat('yyyy-MM-dd')
                                          .format(task.dueDate) ==
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now()))
                                  .toList()),
                          _buildTaskSection(
                              "Tomorrow",
                              tasks
                                  .where((task) =>
                                      DateFormat('yyyy-MM-dd')
                                          .format(task.dueDate) ==
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.now()
                                              .add(Duration(days: 1))))
                                  .toList()),
                          _buildTaskSection(
                              "This Week",
                              tasks
                                  .where((task) =>
                                      task.dueDate.isAfter(DateTime.now()) &&
                                      task.dueDate.isBefore(DateTime.now()
                                          .add(Duration(days: 7))))
                                  .toList()),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => null, // No action for first icon
                child: _buildBottomNavItem(
                    Icons.calendar_today, false), // Always unselected
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddEditTaskPage())),
                child: _buildBottomNavItem(Icons.add, true), // Always selected
              ),
              GestureDetector(
                onTap: () => _showPriorityStatusFilterDialog(context),
                child: _buildBottomNavItem(
                    Icons.filter_list, false), // Always unselected
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isSelected) {
    return CircleAvatar(
      radius: isSelected ? 34 : 24,
      backgroundColor: isSelected ? Color(0xFF57018a) : Colors.grey[300],
      child: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
    );
  }

  Widget _buildTaskSection(String sectionName, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionName,
            style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Slidable(
              key: Key(task.id.toString()),
              direction: Axis.horizontal, // Right to left sliding
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      context.read<TaskBloc>().add(EditTaskEvent(
                            task.copyWith(
                                isCompleted: !task
                                    .isCompleted), // Using copyWith if Task class allows that
                          ));
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check_circle,
                    label: 'Complete',
                  ),
                ],
              ),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    // Toggle task completion
                    context.read<TaskBloc>().add(EditTaskEvent(
                          task.copyWith(
                              isCompleted: !task
                                  .isCompleted), // Using copyWith if Task class allows that
                        ));
                  },
                  child: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
                title: Text(task.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}"),
                  ],
                ),
                trailing: _buildPriorityContainer(
                    task.priority), // Change to container with text
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditTaskPage(task: task),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPriorityContainer(String priority) {
    Color priorityColor;
    String priorityText;

    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        priorityText = 'High';
        break;
      case 'Medium':
        priorityColor = Colors.yellow;
        priorityText = 'Medium';
        break;
      case 'Low':
        priorityColor = Colors.green;
        priorityText = 'Low';
        break;
      default:
        priorityColor = Colors.grey;
        priorityText = 'No Priority';
    }

    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
        color: priorityColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        priorityText,
        style: TextStyle(
            fontFamily: 'Satoshi',
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showPriorityStatusFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter by Priority and Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Priority: All"),
                onTap: () {
                  selectedPriority = 'All';
                  selectedStatus = 'All';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Priority: High"),
                onTap: () {
                  selectedPriority = 'High';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Priority: Medium"),
                onTap: () {
                  selectedPriority = 'Medium';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Priority: Low"),
                onTap: () {
                  selectedPriority = 'Low';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Status: Completed"),
                onTap: () {
                  selectedStatus = 'completed';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Status: Incomplete"),
                onTap: () {
                  selectedStatus = 'incomplete';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
              ListTile(
                title: Text("Clear All Filters"),
                onTap: () {
                  selectedPriority = 'All';
                  selectedStatus = 'All';
                  searchQuery = '';
                  Navigator.pop(context);
                  context.read<TaskBloc>().add(FetchTasksEvent());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
