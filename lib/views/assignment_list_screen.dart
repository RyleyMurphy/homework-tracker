import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();

}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();


  void _updateAssignmentTitle() {
    String updatedTitle = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Assignment Title'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new assignment title'),
            onChanged: (value) {
              updatedTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel Button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (updatedTitle.trim().isNotEmpty) {
                  setState(() {
                    // Update the title of the first assignment for demonstration purposes
                    if (_presenter.assignments.isNotEmpty) {
                      _presenter.updateAssignmentTitle(0, updatedTitle.trim());
                    }
                  });
                }
                Navigator.pop(context); // Close Dialog
              },
              child: const Text('Update'),
            ),
          ],
        );
      }
    );
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';

    showDialog(
      context:context,
      builder:(context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter assignment title'),
            onChanged: (value) {
              newAssignmentTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), //Cancel Button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  setState(() {
                    _presenter.addAssignment(newAssignmentTitle.trim());
                  });
                }
                Navigator.pop(context); // Close Dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

void _toggleCompleted(int index, bool? value) {
  setState(() {
    _presenter.toggleCompleted(index);
  });
}

@override
Widget build(BuildContext context) {
  final assignments = _presenter.assignments;  
  return Scaffold(
    appBar: AppBar(title: const Text('Assignments')),
    body: ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return Card(
          color:Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CheckboxListTile(
              value: assignments[index].isCompleted,
              onChanged: (value) => _toggleCompleted(index, value),
              title: Text(
                assignments[index].title,
                style: TextStyle(
                  decoration: assignments[index].isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: Colors.white,
                ),
              ),
            )
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddAssignmentDialog,
            child: const Icon(Icons.add),
            heroTag: null,
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                assignments.removeWhere((assignment) => assignment.isCompleted);
              });
            },
            child: const Icon(Icons.delete),
            heroTag: null,
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: _updateAssignmentTitle,
            child: const Icon(Icons.edit),
            heroTag:null,
          )
        ],
      )
  );
}
}