class Subject {
  final int id;
  final String name;
  double progress;
  final List<Topic> topics;

  Subject({
    required this.id,
    required this.name,
    required this.progress,
    required this.topics,
  });

  void updateProgress() {
    final completedCount = topics.where((t) => t.isCompleted).length;
    progress = topics.isEmpty ? 0.0 : completedCount / topics.length;
  }
}

class Topic {
  final String name;
  bool isCompleted;

  Topic({
    required this.name,
    this.isCompleted = false,
  });
}
