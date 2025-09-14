import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword = false;
  bool rememberMe = false;

  String name = '';
  String username = '';
  String password = '';
  String email = '';
  String day = '16';
  String month = '04';
  String year = '1998';

  final Map<String, bool> genders = {
    'Male': false,
    'Female': false,
    'Others': false,
  };

  final List<String> days =
      List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> months =
      List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> years =
      List.generate(100, (i) => (DateTime.now().year - i).toString());

  final Color pink = const Color(0xFFF45B5B);
  final Color gray = const Color(0xFF444444);
  final Color backgroundGray = const Color(0xFFF9F9F9);

  String? nameError;
  String? usernameError;
  String? passwordError;
  String? emailError;
  String? genderError;

  bool _isLoading = false;
  String? _registerError;

  // Backend URL configured for Android emulator: 10.0.2.2 points to localhost on PC
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<bool> register({
    required String name,
    required String username,
    required String password,
    required String email,
    required String gender,
    required String dob,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'email': email,
        'gender': gender,
        'dob': dob,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Container(
            width: 290,
            height: 270,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: pink.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.person, size: 64, color: pink),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "Registered\nSuccessfully",
                  style: TextStyle(
                      color: Color(0xFFF45D6B),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 1.17),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context, rootNavigator: true).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/editprofile', arguments: {
          'name': name,
          'dob': "$day/$month/$year",
        });
      });
    });
  }

  bool _validateEmail(String em) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(em);
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
      _registerError = null;
    });

    try {
      bool success = await register(
        name: name.trim(),
        username: username.trim(),
        password: password,
        email: email.trim(),
        gender: genders.entries.firstWhere((e) => e.value).key,
        dob: "$year-$month-$day",
      );

      if (success) {
        _showSuccessDialog();
      } else {
        setState(() {
          _registerError = "Registration failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _registerError = "Error: ${e.toString()}";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onRegister() {
    setState(() {
      nameError = usernameError = passwordError = emailError = genderError = null;
      _registerError = null;

      if (name.trim().isEmpty) {
        nameError = "Please fill this";
      }
      if (username.trim().isEmpty) {
        usernameError = "Please fill this";
      }
      if (password.trim().isEmpty) {
        passwordError = "Please fill this";
      } else if (password.length < 6) {
        passwordError = "Password must be at least 6 characters";
      }
      if (email.trim().isEmpty) {
        emailError = "Please fill this";
      } else if (!_validateEmail(email.trim())) {
        emailError = "Invalid email";
      }
      if (!genders.containsValue(true)) {
        genderError = "Select at least one";
      }
    });

    if ([nameError, usernameError, passwordError, emailError, genderError]
        .any((e) => e != null)) {
      return;
    }
    _registerUser();
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: pink, size: 22),
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle:
                TextStyle(color: pink.withOpacity(0.4), fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black12, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black12, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: pink, width: 1.8),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(height: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDateDropdown(
      String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      width: 90,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1.5),
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGenderCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: genders.keys.map((gender) {
            return Expanded(
              child: Row(
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    activeColor: pink,
                    value: genders[gender],
                    onChanged: (val) {
                      setState(() {
                        genders.updateAll((key, _) => false);
                        genders[gender] = val ?? false;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    gender,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (genderError != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 2),
            child: Text(
              genderError ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildLoveLoomHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('♡', style: TextStyle(fontSize: 26, color: pink.withOpacity(0.5))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 20, color: pink.withOpacity(0.3))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 14, color: pink.withOpacity(0.15))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 30, color: pink.withOpacity(0.7))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 14, color: pink.withOpacity(0.15))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 20, color: pink.withOpacity(0.3))),
            const SizedBox(width: 4),
            Text('♡', style: TextStyle(fontSize: 26, color: pink.withOpacity(0.5))),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "LOVE LOOM",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: pink,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFFF45B5B)),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
              const SizedBox(height: 14),
              buildLoveLoomHeader(),
              const SizedBox(height: 22),
              _buildGenderCheckboxes(),
              const SizedBox(height: 18),
              _buildInputField(
                label: 'Name',
                hintText: 'enter your name',
                icon: Icons.person,
                onChanged: (val) => name = val,
                errorText: nameError,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Username',
                hintText: 'enter your username',
                icon: Icons.person,
                onChanged: (val) => username = val,
                errorText: usernameError,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Password',
                hintText: 'password here',
                icon: Icons.lock,
                obscureText: !showPassword,
                onChanged: (val) => password = val,
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () =>
                      setState(() => showPassword = !showPassword),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Email',
                hintText: 'enter your email here',
                icon: Icons.mail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => email = val,
                errorText: emailError,
              ),
              const SizedBox(height: 30),
              const Text(
                "Date of birth",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDateDropdown(day, days, (val) {
                    if (val != null) setState(() => day = val);
                  }),
                  _buildDateDropdown(month, months, (val) {
                    if (val != null) setState(() => month = val);
                  }),
                  _buildDateDropdown(year, years, (val) {
                    if (val != null) setState(() => year = val);
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: gray,
                    onChanged: (val) =>
                        setState(() => rememberMe = val ?? false),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (_registerError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _registerError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 6,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: gray, fontSize: 15),
                    children: [
                      TextSpan(
                        text: "Log in.",
                        style: TextStyle(
                            color: pink,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed('/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
