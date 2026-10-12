import 'package:flutter/material.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/delete_fab.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter _coursePresenter = CoursePresenter();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    await _coursePresenter.loadCourses();
    setState(() => _isLoading = false);
  }

  void _showDeleteCourseDialog(String courseName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: Text('Input the name of the course to delete.\nClick Enter to confirm.'),
          actions: [
            TextField(
              decoration: const InputDecoration(labelText: 'Course Name'),
              onSubmitted: (value) async {
                if (value.trim() == courseName) {
                  await _coursePresenter.deleteCourse(courseName);
                  setState(() {});
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course name does not match')),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      }
    );
  }

  void _showAddCourseDialog() {
    String name = '';
    String? description;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Course Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                if (name.trim().isNotEmpty) {
                  await _coursePresenter.addCourse(name.trim(), description);
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
  final courses = _coursePresenter.courses;

  return Scaffold(
    appBar: AppBar(title: const Text('Courses')),
    body: 
      _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return ListTile(
              title: Text(course.name),
              subtitle:
                course.description != null
                ? Text(course.description!)
                : null,
            );
          },
        ),
    floatingActionButton: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddFab(
          onPressed: _showAddCourseDialog,
        ),
        const SizedBox(width: 16),
        DeleteFab(
          onPressed: () {
            if (courses.isNotEmpty) {
              _showDeleteCourseDialog(courses.last.name);
            }
          },
        ),
      ],
    ),
  );
}
}