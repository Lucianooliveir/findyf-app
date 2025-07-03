import 'package:findyf_app/commons/models/comentario_model.dart';
import 'package:findyf_app/commons/models/curtida_model.dart';
import 'package:findyf_app/commons/models/user_model.dart';
import 'package:findyf_app/commons/models/animal_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postagem_model.g.dart';

@JsonSerializable()
class PostagemModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String texto;

  @JsonKey(defaultValue: "")
  final String data;

  @JsonKey(defaultValue: "")
  final String imagem_post;

  final UserModel user_infos;

  final List<ComentarioModel> comentarios;

  @JsonKey(defaultValue: [])
  final List<CurtidaModel> curtidas;

  @JsonKey(defaultValue: null)
  final AnimalModel? animal;

  PostagemModel({
    required this.id,
    required this.texto,
    required this.data,
    required this.imagem_post,
    required this.user_infos,
    required this.comentarios,
    this.curtidas = const [],
    this.animal,
  });

  factory PostagemModel.fromJson(Map<String, dynamic> json) =>
      _$PostagemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostagemModelToJson(this);
}
