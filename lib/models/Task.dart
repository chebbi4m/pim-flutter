class Task {
  final String id;
  final String childUsername;
  final String parentUsername;
  final String title;
  final String? description;
  final int? amount;
  final DateTime? deadline;
  final bool status;
  final String? validationType;
  final String qcmQuestion;
  final String? qcmOptions;
  final String? answer;
  final bool? score;
  final String? imageAnswer;

  Task({
    required this.id,
    required this.childUsername,
    required this.parentUsername,
    required this.title,
    this.description,
    this.amount,
    this.deadline,
    required this.status,
    this.validationType,
    required this.qcmQuestion,
    this.qcmOptions,
    this.answer,
    this.score,
    this.imageAnswer,
  });
 Map<String, dynamic> getQcmOptionsAndCorrectAnswer() {
    List<String> options = [];
    String? correctAnswer;

    if (qcmOptions != null && qcmOptions!.isNotEmpty) {
      List<String> parts = qcmOptions!.split('_');
      for (String part in parts) {
        if (part.startsWith('[') && part.endsWith(']')) {
          // Extracting the correct answer
          correctAnswer = part.substring(1, part.length - 1);
          options.add(part.substring(1, part.length - 1));
        } else {
          // Regular option
          options.add(part);
        }
      }
    }

    // If the correct answer is not found, we could return null or handle it accordingly
    return {
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      childUsername: json['childUsername'],
      parentUsername: json['parentUsername'],
      title: json['title'],
      description: json['description'],
      amount: json['amount'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'],
      validationType: json['validationType'],
      qcmQuestion: json['qcmQuestion'],
      qcmOptions: json['qcmOptions'],
      answer: json['answer'],
      score: json['score'],
      imageAnswer: json['imageAnswer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childUsername': childUsername,
      'parentUsername': parentUsername,
      'title': title,
      'description': description,
      'amount': amount,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'validationType': validationType,
      'qcmQuestion': qcmQuestion,
      'qcmOptions': qcmOptions,
      'answer': answer,
      'score': score,
      'imageAnswer': imageAnswer,
    };
  }

  
}
