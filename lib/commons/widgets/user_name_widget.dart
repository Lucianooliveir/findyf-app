import 'package:findyf_app/commons/models/user_model.dart';
import 'package:flutter/material.dart';

class UserNameWidget extends StatelessWidget {
  final UserModel user;
  final TextStyle? textStyle;
  final double? checkmarkSize;

  const UserNameWidget({
    super.key,
    required this.user,
    this.textStyle,
    this.checkmarkSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.nome,
          style: textStyle,
        ),
        if (user.isShelter) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.verified,
            color: Colors.green,
            size: checkmarkSize ?? 16,
          ),
        ],
      ],
    );
  }
}
