import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loveloom/services/api_service.dart'; // Use your correct import path

class EditProfilePage extends StatefulWidget {
  final String? name;
  final String? dob;
  final String? initialImage;
  final String? initialLocation;
  final List<String>? initialGalleryImages;
  final List<String>? initialNotes;

  const EditProfilePage({
    Key? key,
    this.name,
    this.dob,
    this.initialImage,
    this.initialLocation,
    this.initialGalleryImages,
    this.initialNotes,
    required String initialDob,
    String? initialName,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color pink = const Color(0xFFF43045);
  String? imagePath;
  List<String> galleryImages = [];
  List<String> notes = [];

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _locationController;

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    imagePath = widget.initialImage;
    _nameController = TextEditingController(text: widget.name ?? '');
    _dobController = TextEditingController(text: widget.dob ?? '');
    _locationController = TextEditingController(text: widget.initialLocation ?? '');
    galleryImages = List<String>.from(widget.initialGalleryImages ?? []);
    notes = List<String>.from(widget.initialNotes ?? []);
  }

  Future<void> _pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  Future<void> _pickGalleryImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        galleryImages.add(picked.path);
      });
    }
  }

  void _navigateToNotePage() {
    Navigator.pushNamed(context, '/note');
  }

  void _addNote() {
    String note = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Note", style: TextStyle(color: pink)),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Write your note here"),
            onChanged: (value) => note = value,
          ),
          actions: [
            TextButton(
              child: Text("Add", style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (note.trim().isNotEmpty) {
                  setState(() {
                    notes.add(note.trim());
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _profileAvatar() {
    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: pink, width: 4),
        color: pink.withOpacity(0.13),
      ),
      child: GestureDetector(
        onTap: _pickImageFromGallery,
        child: CircleAvatar(
          radius: 56,
          backgroundColor: Colors.white,
          backgroundImage: (imagePath != null) ? FileImage(File(imagePath!)) : null,
          child: (imagePath == null)
              ? Icon(Icons.person, size: 72, color: Colors.grey[400])
              : null,
        ),
      ),
    );
  }

  Widget _inputSection({required String label, required TextEditingController controller, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500)),
          TextField(
            controller: controller,
            style: TextStyle(fontSize: 17.5, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: Colors.black87),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 3),
            ),
          ),
          const Divider(thickness: 1.05),
        ],
      ),
    );
  }

  Widget _gallerySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gallery", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15)),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: galleryImages.length + 1,
              itemBuilder: (context, index) {
                if (index < galleryImages.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.file(
                        File(galleryImages[index]),
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: _navigateToNotePage,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: pink, width: 2),
                      color: pink.withOpacity(0.09),
                    ),
                    child: Icon(Icons.add, color: pink, size: 30),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Notes", style: TextStyle(fontSize: 15.5, color: Colors.black87)),
              IconButton(icon: Icon(Icons.add_circle_outline, color: pink, size: 22), onPressed: _addNote),
            ],
          ),
          ...notes.map((note) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(note, style: TextStyle(fontSize: 14, color: Colors.black87)),
          )),
        ],
      ),
    );
  }

  Widget _editPhotoText() {
    return GestureDetector(
      onTap: _pickImageFromGallery,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          "Edit profile photo",
          style: TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: pink,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
        boxShadow: [BoxShadow(color: pink.withOpacity(0.09), blurRadius: 18, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.home, color: Colors.white), onPressed: () => Navigator.pop(context)),
          IconButton(icon: Icon(Icons.explore, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.add_circle_outline, color: Colors.white), onPressed: _pickGalleryImage),
          IconButton(icon: Icon(Icons.chat_bubble_outline, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return; // Prevent multiple taps
    setState(() => _isSaving = true);

    try {
      String? uploadedImageUrl;

      if (imagePath != null && !imagePath!.startsWith('http')) {
        // Upload image file only if locally picked (not already URL)
        uploadedImageUrl = await _apiService.uploadProfileImage(File(imagePath!));
      } else {
        uploadedImageUrl = imagePath; // Already uploaded image URL or null
      }

      final success = await _apiService.updateProfile(
        name: _nameController.text.trim(),
        dob: _dobController.text.trim(),
        location: _locationController.text.trim(),
        profileImagePath: uploadedImageUrl,
        galleryImages: galleryImages,
        notes: notes,
      );

      if (success) {
        Navigator.pop(context, {
          'image': uploadedImageUrl,
          'name': _nameController.text.trim(),
          'dob': _dobController.text.trim(),
          'location': _locationController.text.trim(),
          'galleryImages': galleryImages,
          'notes': notes,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: pink, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            "Edit profile",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: Text(
                _isSaving ? 'Saving...' : "Save",
                style: TextStyle(color: pink, fontWeight: FontWeight.bold, fontSize: 16.5),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  _profileAvatar(),
                  _editPhotoText(),
                ],
              ),
            ),
            _inputSection(label: "Name", controller: _nameController, bold: true),
            _inputSection(label: "Date of birth", controller: _dobController, bold: true),
            _inputSection(label: "Location", controller: _locationController),
            _gallerySection(),
            _notesSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
