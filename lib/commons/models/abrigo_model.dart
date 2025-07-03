import 'package:json_annotation/json_annotation.dart';

part 'abrigo_model.g.dart';

@JsonSerializable()
class AbrigoModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String nome_responsavel;

  @JsonKey(defaultValue: "")
  final String crmv_responsavel;

  @JsonKey(defaultValue: "")
  final String telefone;

  AbrigoModel({
    required this.id,
    required this.nome_responsavel,
    required this.crmv_responsavel,
    required this.telefone,
  });

  factory AbrigoModel.fromJson(Map<String, dynamic> json) =>
      _$AbrigoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbrigoModelToJson(this);
}
