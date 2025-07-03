// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nome: json['nome'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      cep: json['cep'] as String? ?? '',
      imagem_perfil: json['imagem_perfil'] as String? ?? '',
      curtidos: json['curtidos'] == null
          ? []
          : UserModel._curtidosFromJson(json['curtidos']),
      postagens: (json['postagens'] as List<dynamic>?)
              ?.map((e) => PostUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'telefone': instance.telefone,
      'email': instance.email,
      'cep': instance.cep,
      'imagem_perfil': instance.imagem_perfil,
      'curtidos': instance.curtidos,
      'postagens': instance.postagens,
    };
