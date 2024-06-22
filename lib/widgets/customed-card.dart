import 'dart:math';

import 'package:flutter/material.dart';

import '../constant/colors.dart';

class FlipCard extends StatefulWidget {
  final String frontTitle;
  final String frontSubtitle;
  final String backTitle;
  final String backSubtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FlipCard({
    Key? key,
    required this.frontTitle,
    required this.frontSubtitle,
    required this.backTitle,
    required this.backSubtitle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (BuildContext context, Widget? child) {
              final isUnder = ValueKey(_isFlipped) != child?.key;
              final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                child: child,
                alignment: Alignment.center,
              );
            },
          );
        },
        child: _isFlipped
            ? CardContent(
                key: ValueKey(true),
                title: widget.backTitle,
                subtitle: widget.backSubtitle,
                color: constantColors.SoftBlue,
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              )
            : CardContent(
                key: ValueKey(false),
                title: widget.frontTitle,
                subtitle: widget.frontSubtitle,
                color: constantColors.LightGray,
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const CardContent({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(color: constantColors.White, fontSize: 20),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: constantColors.White, fontSize: 16),
            ),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: constantColors.White),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
