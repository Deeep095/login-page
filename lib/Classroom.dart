class Classroom {
  final String id;
  final String className;
  final String ownerId;
  final DateTime createdAt;

  Classroom({required this.id, required this.className, required this.ownerId, required this.createdAt});

  factory Classroom.fromFirestore(Map<String, dynamic> data) {
    return Classroom(
      id: data['id'],
      className: data['className'],
      ownerId: data['ownerId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
