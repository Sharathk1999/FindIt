import 'package:flutter/material.dart';

class HomeBtn extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  const HomeBtn({super.key, required this.onTap, required this.name});

  @override
  State<HomeBtn> createState() => _HomeBtnState();
}

class _HomeBtnState extends State<HomeBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 65,
        width: MediaQuery.of(context).size.width * .42,
        margin:const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withAlpha(50),
        ),
        child: Center(
          child: Text(
            widget.name,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}