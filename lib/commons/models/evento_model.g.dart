// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventoModel _$EventoModelFromJson(Map<String, dynamic> json) => EventoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome: json['nome'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      dataInicio: json['dataInicio'] as String? ?? '',
      dataFim: json['dataFim'] as String? ?? '',
      preco: json['preco'] as String? ?? '',
      horario: json['horario'] as String? ?? '',
      abrigo_infos: json['abrigo_infos'] == null
          ? null
          : AbrigoModel.fromJson(json['abrigo_infos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventoModelToJson(EventoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'dataInicio': instance.dataInicio,
      'dataFim': instance.dataFim,
      'preco': instance.preco,
      'horario': instance.horario,
      'abrigo_infos': instance.abrigo_infos,
    };

CreateEventoDto _$CreateEventoDtoFromJson(Map<String, dynamic> json) =>
    CreateEventoDto(
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      dataInicio: json['dataInicio'] as String,
      dataFim: json['dataFim'] as String,
      preco: json['preco'] as String,
      horario: json['horario'] as String,
      abrigoId: (json['abrigoId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateEventoDtoToJson(CreateEventoDto instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'descricao': instance.descricao,
      'dataInicio': instance.dataInicio,
      'dataFim': instance.dataFim,
      'preco': instance.preco,
      'horario': instance.horario,
      'abrigoId': instance.abrigoId,
    };
