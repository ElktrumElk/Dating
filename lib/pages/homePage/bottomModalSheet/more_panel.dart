

import 'package:flutter/material.dart';

void showBottomPane (BuildContext context) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context, builder: (BuildContext context) {
      return  Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('More', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const Spacer(),
                TextButton.icon(onPressed: () {}, label: Text('Add to Intrest'), icon: Icon(Icons.favorite_outlined), style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFFE10087),
                  foregroundColor: Colors.white,

                ),)
              ],
            )
          ],
        ),
      );
    });
  }
