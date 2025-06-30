import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String nome;

  @JsonKey(defaultValue: "")
  final String telefone;

  @JsonKey(defaultValue: "")
  final String email;

  @JsonKey(defaultValue: "")
  final String cep;

  @JsonKey(defaultValue: "")
  final String imagem_perfil;

  UserModel(
      {required this.id,
      required this.nome,
      required this.telefone,
      required this.email,
      required this.cep,
      required this.imagem_perfil});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
