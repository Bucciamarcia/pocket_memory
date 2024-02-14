import "package:json_annotation/json_annotation.dart";
part "dbmodels.g.dart";

@JsonSerializable()
class Memory {

  final String content;
  final DateTime date;
  final bool isTemporary;
  final DateTime? expiration;
  final List<num> embeddings;

  Memory({
    this.content = "",
    required this.date,
    this.isTemporary = false,
    this.expiration,
    this.embeddings = const [0],
  });

  factory Memory.fromJson(Map<String, dynamic> json) => _$MemoryFromJson(json);
  Map<String, dynamic> toJson() => _$MemoryToJson(this);

}