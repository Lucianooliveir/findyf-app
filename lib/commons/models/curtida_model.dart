import 'package:findyf_app/commons/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'curtida_model.g.dart';

@JsonSerializable()
class CurtidaModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey()
  final UserModel user_infos;

  CurtidaModel({
    required this.id,
    required this.user_infos,
  });

  factory CurtidaModel.fromJson(Map<String, dynamic> json) =>
      _$CurtidaModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurtidaModelToJson(this);
}
