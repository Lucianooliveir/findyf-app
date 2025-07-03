// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostUserModel _$PostUserModelFromJson(Map<String, dynamic> json) =>
    PostUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      texto: json['texto'] as String? ?? '',
      data: json['data'] as String? ?? '',
      imagem_post: json['imagem_post'] as String? ?? '',
    );

Map<String, dynamic> _$PostUserModelToJson(PostUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'texto': instance.texto,
      'data': instance.data,
      'imagem_post': instance.imagem_post,
    };
