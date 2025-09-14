import 'package:flutter/material.dart';

class AcceptRejectPage extends StatelessWidget {
  final String avatarUrl;      // User avatar at top bar
  final String userNameMain;   // Username at top (e.g., "@sabbz")
  final String inviteUserName; // Username in popup (e.g., "@shikhu")
  final String inviteMessage;  // Message in popup

  const AcceptRejectPage({
    Key? key,
    required this.avatarUrl,
    required this.userNameMain,
    required this.inviteUserName,
    required this.inviteMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color pink = const Color(0xFFF43045);
    final Color pinkLight = pink.withOpacity(0.14);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top: profile section
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: pink, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(avatarUrl),
                          backgroundColor: pinkLight,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          userNameMain,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // For symmetry
                ],
              ),
            ),
          ),

          // Centered blurred message background behind modal
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [pinkLight, Colors.white],
                center: Alignment.topLeft,
                radius: 1.1,
              ),
            ),
          ),

          // Center modal card
          Center(
            child: Container(
              width: 290,
              padding: const EdgeInsets.symmetric(vertical: 39, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: pink.withOpacity(0.09),
                    blurRadius: 38,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: pinkLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        Icons.person,
                        size: 63,
                        color: pink,
                      ),
                      ...List.generate(
                        6,
                            (i) => Positioned(
                          left: (i == 0)
                              ? 6
                              : (i == 1)
                              ? 74
                              : (i == 2)
                              ? 25
                              : (i == 3)
                              ? 60
                              : (i == 4) ? 15 : 44,
                          top: (i == 0)
                              ? 14
                              : (i == 1)
                              ? 20
                              : (i == 2)
                              ? 74
                              : (i == 3)
                              ? 69
                              : (i == 4) ? 42 : 9,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: pink.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    inviteUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    inviteMessage,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle accept action
                          Navigator.pop(context, "accepted");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              color: pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 19),
                      Container(
                        width: 1.5,
                        height: 18,
                        color: Colors.black12,
                      ),
                      const SizedBox(width: 19),
                      GestureDetector(
                        onTap: () {
                          // Handle remove action
                          Navigator.pop(context, "removed");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Message Bar (for context, as shown in screenshot)
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(color: pink, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Message...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file, color: pink, size: 23),
                      onPressed: () {
                        // File/image picker action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.mic, color: pink, size: 23),
                      onPressed: () {
                        // Voice record action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: pink, size: 23),
                      onPressed: () {
                        // Send action
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
