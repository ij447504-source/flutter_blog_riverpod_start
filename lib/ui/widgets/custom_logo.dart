import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLogo extends StatelessWidget {
  final String title;
  final String? trailingText;

  const CustomLogo(
    this.title, {
    super.key,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/logo.svg",
          height: 70,
          width: 70,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            if (trailingText != null && trailingText!.trim().isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
