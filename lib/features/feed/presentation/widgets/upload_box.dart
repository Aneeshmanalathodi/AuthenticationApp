import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UploadBox({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}