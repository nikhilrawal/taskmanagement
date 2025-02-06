// import 'package:flutter/material.dart';
// import 'package:taskmanager/domain/entities/task.dart';

// class TaskItem extends StatelessWidget {
//   final Task task;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onToggleCompletion;

//   const TaskItem({
//     required this.task,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onToggleCompletion,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         title: Text(task.title),
//         subtitle: Text(task.description),
//         leading: Checkbox(
//           value: task.isCompleted,
//           onChanged: (value) => onToggleCompletion(),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: onEdit,
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: onDelete,
//             ),
//           ],
//         ),
//         onTap: onEdit,
//       ),
//     );
//   }
// }
