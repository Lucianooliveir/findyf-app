// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postagem_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostagemModel _$PostagemModelFromJson(Map<String, dynamic> json) =>
    PostagemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      texto: json['texto'] as String? ?? '',
      data: json['data'] as String? ?? '',
      imagem_post: json['imagem_post'] as String? ?? '',
      user_infos:
          UserModel.fromJson(json['user_infos'] as Map<String, dynamic>),
      comentarios: (json['comentarios'] as List<dynamic>)
          .map((e) => ComentarioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      curtidas: (json['curtidas'] as List<dynamic>?)
              ?.map((e) => CurtidaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PostagemModelToJson(PostagemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'texto': instance.texto,
      'data': instance.data,
      'imagem_post': instance.imagem_post,
      'user_infos': instance.user_infos,
      'comentarios': instance.comentarios,
      'curtidas': instance.curtidas,
    };
