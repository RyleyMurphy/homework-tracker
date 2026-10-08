import '../models/assignment_models.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
    ..clear()
    ..addAll(fetched);
  }

  Future<void> addAssignment(String title) async {
    await Assignment.addAssignment(title);
    _assignments.add(Assignment(title: title));
  }

  Future<void> toggleCompleted(int index) async {
    await Assignment.updateCompletionStatus(index, _assignments);
    _assignments[index].isCompleted = !_assignments[index].isCompleted;
  }

  Future<void> filterAssignments(String query) async {
    final normalizedQuery = query.toLowerCase();
    final filtered = _assignments
      .where((assignment) =>
        assignment.title.toLowerCase().contains(normalizedQuery))
      .toList();
    _assignments
    ..clear()
    ..addAll(filtered);
  }

}