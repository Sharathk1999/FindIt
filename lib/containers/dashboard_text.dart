import 'package:flutter/material.dart';

class DashboardText extends StatefulWidget {
  final String keyword, value;
  const DashboardText({super.key, required this.keyword, required this.value});

  @override
  State<DashboardText> createState() => _DashboardTextState();
}

class _DashboardTextState extends State<DashboardText> {
  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(5),
       margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade200,
           
            borderRadius: BorderRadius.circular(5)
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
                    "${widget.keyword}:",
                    style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
                    ),
                  ),
          Text(
            widget.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
