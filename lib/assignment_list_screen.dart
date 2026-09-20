import 'package:flutter/material.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();

}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final List<Map<String, dynamic>> _assignments = [];

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
                    _assignments.add({
                      'title': newAssignmentTitle.trim(),
                      'completed': false,
                    });
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
    _assignments[index]['completed'] = value ?? false;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Assignments')),
    body: ListView.builder(
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        return Card(
          color:Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CheckboxListTile(
              value: _assignments[index]['completed'],
              onChanged: (value) => _toggleCompleted(index,value),
              title: Text(
                _assignments[index]['title'],
                style: TextStyle(
                  decoration: _assignments[index]['completed']
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
                _assignments.removeWhere((assignment) => assignment['completed']);
              });
            },
            child: const Icon(Icons.delete),
            heroTag: null,
          )
        ],
      )
  );
}
}

//return CheckboxListTile(
          //title: Text(_assignments[index]['title']),
          //value: _assignments[index]['completed'],
          //onChanged: (value) => _toggleCompleted(index, value),
        //);