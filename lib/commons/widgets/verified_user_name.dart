import 'package:flutter/material.dart';

class VerifiedUserName extends StatelessWidget {
  final String userName;
  final bool isVerified;
  final TextStyle? textStyle;
  final double? iconSize;

  const VerifiedUserName({
    super.key,
    required this.userName,
    required this.isVerified,
    this.textStyle,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          userName,
          style: textStyle,
        ),
        if (isVerified) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.verified,
            color: Colors.green,
            size: iconSize ?? 16,
          ),
        ],
      ],
    );
  }
}
