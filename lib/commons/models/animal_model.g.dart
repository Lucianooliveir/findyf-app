// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimalModel _$AnimalModelFromJson(Map<String, dynamic> json) => AnimalModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome: json['nome'] as String? ?? '',
      data_nascimento: json['data_nascimento'] as String? ?? '',
      especie: json['especie'] as String? ?? '',
      raca: json['raca'] as String? ?? '',
      porte: json['porte'] as String? ?? '',
      imagem: json['imagem'] as String? ?? '',
      abrigo_infos: json['abrigo_infos'] == null
          ? null
          : AbrigoModel.fromJson(json['abrigo_infos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnimalModelToJson(AnimalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'data_nascimento': instance.data_nascimento,
      'especie': instance.especie,
      'raca': instance.raca,
      'porte': instance.porte,
      'imagem': instance.imagem,
      'abrigo_infos': instance.abrigo_infos,
    };
