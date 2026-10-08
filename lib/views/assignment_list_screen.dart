import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();

}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  bool _isLoading = true;

  

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _presenter.loadAssignments();
    setState(() => _isLoading = false);
  }

  void _filterAssignmentsDialog() async {
    String query = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Assignments'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter search query'),
            onChanged: (value) {
              query = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel Button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _presenter.filterAssignments(query);
                setState(() {});
                Navigator.pop(context); // Close Dialog
              },
              child: const Text('Filter'),
            ),
          ],
        );
      },
    );
  }

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
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  await _presenter.addAssignment(newAssignmentTitle.trim());
                  setState(() {});
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

@override
Widget build(BuildContext context) {
  final assignments = _presenter.assignments;  
  return Scaffold(
    appBar: AppBar(title: const Text('Assignments')),
    body: 
        _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return CheckboxListTile(
              title: Text(assignment.title),
              value: assignment.isCompleted,
              onChanged: (_) async {
                await _presenter.toggleCompleted(index);
                setState(() {});
              },
            );
          },
        ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _filterAssignmentsDialog,
            child: const Icon(Icons.search),
          ),
          SizedBox(height: 10,),
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
      ),
  );
}
}