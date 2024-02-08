import 'package:flutter/material.dart';

class Tips {
  Widget title_({Color? color}) {
    return Text(
      'Card title',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
    );
  }

  Widget content_({Color? color}) {
    return Text(
      'This a card description',
      style: TextStyle(color: color),
    );
  }

  Widget footer_({Color? color}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            'assets/avatar.png',
          ),
          radius: 12,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: Text(
          'Super user',
          style: TextStyle(color: color),
        )),
        IconButton(onPressed: () {}, icon: Icon(Icons.share))
      ],
    );
  }

  Widget tag_(String tag, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), color: Colors.green),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          tag,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
