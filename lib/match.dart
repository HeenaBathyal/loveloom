import 'package:flutter/material.dart';

class MatchPage extends StatelessWidget {
  final String yourImageUrl;
  final String matchImageUrl;
  final String matchName;

  const MatchPage({
    Key? key,
    required this.yourImageUrl,
    required this.matchImageUrl,
    required this.matchName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color darkPink = const Color(0xFFF43045);

    return Scaffold(
      backgroundColor: darkPink,
      body: Stack(
        children: [
          // Floating hearts background
          ...List.generate(7, (i) {
            final offsets = [
              const Offset(20, 80),
              const Offset(100, 180),
              const Offset(310, 180),
              const Offset(60, 380),
              const Offset(230, 70),
              const Offset(290, 350),
              const Offset(120, 570),
            ];
            final sizes = [32.0, 18.0, 22.0, 27.0, 24.0, 20.0, 14.0];
            return Positioned(
              left: offsets[i].dx,
              top: offsets[i].dy,
              child: Icon(Icons.favorite, color: Colors.white.withOpacity(0.14), size: sizes[i]),
            );
          }),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 84),
                const Text(
                  "It's a match🎉",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "You and $matchName have liked each other.",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 45),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 43,
                            backgroundImage: NetworkImage(yourImageUrl),
                          ),
                        ),
                        const SizedBox(width: 14),
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.yellow[200],
                          child: CircleAvatar(
                            radius: 43,
                            backgroundImage: NetworkImage(matchImageUrl),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: darkPink,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 7),
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white, size: 35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 66),
                SizedBox(
                  width: 270,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    onPressed: () {
                      // Your logic here
                    },
                    child: Text(
                      'Make your profile live',
                      style: TextStyle(
                        color: darkPink,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    // Handle delete here
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
