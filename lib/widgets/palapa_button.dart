import 'package:flutter/material.dart';

class PalapaButton extends StatelessWidget {
  const PalapaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return buttonGroup();
  }

  Widget buttonGroup() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 85,
                child: Container(
                  color: Colors.red.shade400,
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.feed,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "FEED",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 85,
                child: Container(
                  color: Colors.orange.shade400,
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "MATERI",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 85,
                child: Container(
                  color: Colors.teal.shade400,
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.bookmark_add_sharp,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "TEST",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 85,
                child: Container(
                  color: Colors.grey.shade600,
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "SEARCH",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
