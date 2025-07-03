import 'package:json_annotation/json_annotation.dart';
import 'package:findyf_app/commons/models/post_user_model.dart';
import 'package:findyf_app/commons/models/abrigo_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: "")
  final String nome;

  @JsonKey(defaultValue: "")
  final String telefone;

  @JsonKey(defaultValue: "")
  final String email;

  @JsonKey(defaultValue: "")
  final String cep;

  @JsonKey(defaultValue: "")
  final String imagem_perfil;

  @JsonKey(defaultValue: <int>[], fromJson: _curtidosFromJson)
  final List<int> curtidos;

  @JsonKey(defaultValue: <PostUserModel>[])
  final List<PostUserModel> postagens;

  @JsonKey(defaultValue: false)
  final bool isShelter;

  @JsonKey(defaultValue: null)
  final AbrigoModel? abrigo;

  UserModel(
      {required this.id,
      required this.nome,
      required this.telefone,
      required this.email,
      required this.cep,
      required this.imagem_perfil,
      required this.curtidos,
      required this.postagens,
      required this.isShelter,
      this.abrigo});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static List<int> _curtidosFromJson(dynamic json) {
    if (json == null) return <int>[];
    if (json is List) {
      return json
          .map((item) {
            if (item is Map<String, dynamic> && item['post_infos'] != null) {
              return (item['post_infos']['id'] as num).toInt();
            } else if (item is num) {
              return item.toInt();
            }
            return 0;
          })
          .where((id) => id != 0)
          .toList();
    }
    return <int>[];
  }
}
