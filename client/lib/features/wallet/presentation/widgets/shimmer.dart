import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class PageShimmer extends StatelessWidget {
  const PageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black12,
          Colors.white10,
        ],
      ),
      child: Column(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(24.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      title: Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey,
                      ),
                      subtitle: Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
