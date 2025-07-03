import 'package:json_annotation/json_annotation.dart';
import 'package:findyf_app/commons/models/abrigo_model.dart';

part 'evento_model.g.dart';

@JsonSerializable()
class EventoModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String nome;

  @JsonKey(defaultValue: "")
  final String descricao;

  @JsonKey(defaultValue: "")
  final String dataInicio;

  @JsonKey(defaultValue: "")
  final String dataFim;

  @JsonKey(defaultValue: "")
  final String preco;

  @JsonKey(defaultValue: "")
  final String horario;

  @JsonKey(defaultValue: null)
  final AbrigoModel? abrigo_infos;

  EventoModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.preco,
    required this.horario,
    this.abrigo_infos,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) =>
      _$EventoModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventoModelToJson(this);
}

// DTO for creating events
@JsonSerializable()
class CreateEventoDto {
  final String nome;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final String preco;
  final String horario;
  final int? abrigoId;

  CreateEventoDto({
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.preco,
    required this.horario,
    this.abrigoId,
  });

  factory CreateEventoDto.fromJson(Map<String, dynamic> json) =>
      _$CreateEventoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventoDtoToJson(this);
}
