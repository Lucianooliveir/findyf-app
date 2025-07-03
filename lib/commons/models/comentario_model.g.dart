// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comentario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComentarioModel _$ComentarioModelFromJson(Map<String, dynamic> json) =>
    ComentarioModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      texto: json['texto'] as String? ?? '',
      autor: UserModel.fromJson(json['autor'] as Map<String, dynamic>),
      responde: json['responde'] == null
          ? null
          : ComentarioModel.fromJson(json['responde'] as Map<String, dynamic>),
      respostas: (json['respostas'] as List<dynamic>?)
              ?.map((e) => ComentarioModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ComentarioModelToJson(ComentarioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'texto': instance.texto,
      'autor': instance.autor,
      'responde': instance.responde,
      'respostas': instance.respostas,
    };
