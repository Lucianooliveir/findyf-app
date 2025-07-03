import 'package:json_annotation/json_annotation.dart';
import 'package:findyf_app/commons/models/abrigo_model.dart';

part 'animal_model.g.dart';

@JsonSerializable()
class AnimalModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String nome;

  @JsonKey(defaultValue: "")
  final String data_nascimento;

  @JsonKey(defaultValue: "")
  final String especie;

  @JsonKey(defaultValue: "")
  final String raca;

  @JsonKey(defaultValue: "")
  final String porte;

  @JsonKey(defaultValue: "")
  final String imagem;

  @JsonKey(defaultValue: null)
  final AbrigoModel? abrigo_infos;

  AnimalModel({
    required this.id,
    required this.nome,
    required this.data_nascimento,
    required this.especie,
    required this.raca,
    required this.porte,
    required this.imagem,
    this.abrigo_infos,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalModelToJson(this);
}
