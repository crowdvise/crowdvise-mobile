/// Lenient JSON readers for `@JsonKey(fromJson: ...)`.
///
/// The simulation payload is LLM-generated upstream; fields occasionally come
/// back as `null`, the string "null", an int where a double is expected, or
/// a number encoded as a string. A strict cast on any one of them used to
/// fail the entire parse and surface as "an error occurred" after a
/// successful run.
library;

String jsonString(Object? v) {
  if (v == null) return '';
  final s = v.toString();
  return s == 'null' ? '' : s;
}

String? jsonStringOrNull(Object? v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty || s == 'null' ? null : s;
}

double jsonDouble(Object? v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0;
  return 0;
}

int jsonInt(Object? v) {
  if (v is num) return v.round();
  if (v is String) return int.tryParse(v) ?? (double.tryParse(v)?.round() ?? 0);
  return 0;
}

List<String> jsonStringList(Object? v) {
  if (v is! List) return const [];
  return v.map(jsonString).where((s) => s.isNotEmpty).toList();
}

List<Map<String, dynamic>> jsonMapList(Object? v) {
  if (v is! List) return const [];
  return v.whereType<Map<String, dynamic>>().toList();
}
