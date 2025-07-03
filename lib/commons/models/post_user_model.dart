import 'package:json_annotation/json_annotation.dart';

part 'post_user_model.g.dart';

@JsonSerializable()
class PostUserModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String texto;

  @JsonKey(defaultValue: "")
  final String data;

  @JsonKey(defaultValue: "")
  final String imagem_post;

  PostUserModel({
    required this.id,
    required this.texto,
    required this.data,
    required this.imagem_post,
  });

  factory PostUserModel.fromJson(Map<String, dynamic> json) =>
      _$PostUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostUserModelToJson(this);
}
