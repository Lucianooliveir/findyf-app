import 'package:findyf_app/commons/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comentario_model.g.dart';

@JsonSerializable()
class ComentarioModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String texto;

  @JsonKey()
  final UserModel autor;

  @JsonKey()
  final ComentarioModel? responde;

  @JsonKey(defaultValue: [])
  final List<ComentarioModel> respostas;

  ComentarioModel(
      {required this.id,
      required this.texto,
      required this.autor,
      this.responde,
      this.respostas = const []});

  factory ComentarioModel.fromJson(Map<String, dynamic> json) =>
      _$ComentarioModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComentarioModelToJson(this);
}
