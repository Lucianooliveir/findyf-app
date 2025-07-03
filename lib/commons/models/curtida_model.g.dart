// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curtida_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurtidaModel _$CurtidaModelFromJson(Map<String, dynamic> json) => CurtidaModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      user_infos:
          UserModel.fromJson(json['user_infos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurtidaModelToJson(CurtidaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_infos': instance.user_infos,
    };
