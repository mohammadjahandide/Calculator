class History {
  final int? id;
  String expression;
  String result;

  History({
    this.id,
    required this.expression,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
    };
  }

  @override
  String toString() {
    return 'History{id:$id, expression:$expression, result:$result}';
  }
}
