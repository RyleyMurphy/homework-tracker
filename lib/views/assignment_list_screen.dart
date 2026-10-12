import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/delete_fab.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();

}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();
  bool _isLoading = true;
  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];
  

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _presenter.loadAssignments();
    await _coursePresenter.loadCourses();
    
    setState(() {
      _isLoading = false;
    _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
    });
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
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    showDialog(
      context:context,
      builder:(context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter assignment title',
                ),
                onChanged: (value) => newAssignmentTitle = value,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: _newAssignmentCourse,
                items:
                  _courseNames.map((name) {
                    return DropdownMenuItem<String>(value: name, child: Text(name));
                  }).toList(),
                  onChanged:
                  (value) => setState(() => _newAssignmentCourse = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), //Cancel Button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty && _newAssignmentCourse != null) {
                  await _presenter.addAssignment(
                    newAssignmentTitle.trim(),
                    _newAssignmentCourse!
                  );
                  setState(() {});
                  Navigator.pop(context);
                }
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
  final displayedAssignments =
      _selectedCourseFilter == null
        ? assignments
        : assignments
          .where((a) => a.courseName == _selectedCourseFilter)
          .toList();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Assignments'),
    actions: [
      if (_courseNames.isNotEmpty)
        DropdownButton<String>(
          hint: const Text(
            'Filter by course',
            style: TextStyle(color: Colors.white),
          ),
          dropdownColor: Colors.blue[100],
          value: _selectedCourseFilter,
          onChanged: (value) {
            setState(() {
              _selectedCourseFilter = value;
            });
          },
          items: [
            const DropdownMenuItem<String> (
              value: null,
              child: Text('All Courses'),
            ),
            ..._courseNames.map(
              (name) => DropdownMenuItem(value: name, child: Text(name)),
            ),
          ],
        ),
      ],
    ),
    body: 
        _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: displayedAssignments.length,
          itemBuilder: (context, index) {
            final assignment = displayedAssignments[index];
            return CheckboxListTile(
              title: Text(assignment.title),
              subtitle: Text('Course: ${assignment.courseName}'),
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
          AddFab(
            onPressed: _showAddAssignmentDialog,
          ),
          SizedBox(height: 10,),
          DeleteFab(
            onPressed: _showDeleteAssignmentDialog,
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