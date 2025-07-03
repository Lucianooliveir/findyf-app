// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abrigo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbrigoModel _$AbrigoModelFromJson(Map<String, dynamic> json) => AbrigoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome_responsavel: json['nome_responsavel'] as String? ?? '',
      crmv_responsavel: json['crmv_responsavel'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
    );

Map<String, dynamic> _$AbrigoModelToJson(AbrigoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome_responsavel': instance.nome_responsavel,
      'crmv_responsavel': instance.crmv_responsavel,
      'telefone': instance.telefone,
    };
