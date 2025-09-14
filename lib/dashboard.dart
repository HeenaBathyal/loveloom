import 'dart:io';
import 'package:flutter/material.dart';
import 'findthematch.dart';  // Import FindTheMatchPage
import 'editprofile.dart';
import 'message.dart';  // Import EditProfilePage

class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? profileImagePath;
  final String? userLocation;

  const DashboardPage({
    Key? key,
    this.userName,
    this.profileImagePath,
    this.userLocation,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? uploadedImagePath;
  String? userName;
  String? userLocation;

  @override
  void initState() {
    super.initState();
    uploadedImagePath = widget.profileImagePath;
    userName = widget.userName;
    userLocation = widget.userLocation;
  }

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: userName ?? 'User',
          initialImage: uploadedImagePath,
          initialLocation: userLocation,
          initialDob: '',
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        uploadedImagePath = result['image'] ?? uploadedImagePath;
        userName = result['name'] ?? userName;
        userLocation = result['location'] ?? userLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xFFF45B62);

    final topRightIcons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: pink,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.1),
            boxShadow: [
              BoxShadow(color: pink.withOpacity(0.17), spreadRadius: 8, blurRadius: 20),
            ],
          ),
          child: const Icon(Icons.add, size: 26, color: Colors.white),
        ),
        GestureDetector(
          onTap: _openEditProfile,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: pink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.1),
              boxShadow: [
                BoxShadow(color: pink.withOpacity(0.17), spreadRadius: 8, blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.person, size: 26, color: Colors.white),
          ),
        ),
      ],
    );

    final profileCircle = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 178,
          height: 178,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pink.withOpacity(0.12),
          ),
        ),
        CircleAvatar(
          radius: 87,
          backgroundColor: Colors.white,
          // Display network image if path is URL, else FileImage if local path, else default icon
          backgroundImage: (uploadedImagePath != null)
              ? (uploadedImagePath!.startsWith('http')
                  ? NetworkImage(uploadedImagePath!)
                  : FileImage(File(uploadedImagePath!))) as ImageProvider
              : null,
          child: (uploadedImagePath == null)
              ? Icon(Icons.person, size: 70, color: Colors.grey[400])
              : null,
        ),
        Positioned(
          bottom: 15,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: pink,
            child: const Icon(Icons.favorite, color: Colors.white, size: 27),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu, size: 28, color: Colors.black87),
                      const SizedBox(width: 12),
                      Text(
                        userLocation ?? "New Delhi",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  topRightIcons,
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.only(left: 23),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Hi, ",
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          fontFamily: 'Nunito',
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: userName ?? "User",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                profileCircle,
                const SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      "in this chaos let's find your",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontFamily: 'Nunito',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "cosmos!",
                      style: TextStyle(
                        color: pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 37),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 19),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const FindTheMatchPage()),
                            );
                          },
                          child: const Text(
                            'Find a match',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33),
                            ),
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 19),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Explore',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: pink,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(0.11),
              blurRadius: 18,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.home, size: 26, color: Colors.white),
                const Icon(Icons.explore, size: 26, color: Colors.white),
                const Icon(Icons.search, size: 30, color: Colors.white),

                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 26, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagePage()),
                    );
                  },
                ),
                const Icon(Icons.person, size: 26, color: Colors.white),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
