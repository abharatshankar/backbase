import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
            ],
          ),
          child: Row(
            children: [
            SizedBox(
              height: 70,
              width: 50,
              child: Container(
              color: Colors.white.withOpacity(0.2),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                height: 20,
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                ),
                SizedBox(height: 6),
                Container(
                height: 15,
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                ),
              ],
              ),
            ),
            ],
          ),
          ),
        ),
        ),
      ),
      );
  }
}
