import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_loading.dart';

import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final aadharController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    aadharController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.register(
        aadhar: aadharController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful! Please login."),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst("Exception: ", ""),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildRegisterForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text("Join WayGO and start your journey."),

          const SizedBox(height: 25),

          AuthTextField(
            controller: nameController,
            label: "Full Name",
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Name is required";
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          AuthTextField(
            controller: aadharController,
            label: "Aadhaar Number",
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Aadhaar number is required";
              }

              if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                return "Enter a valid 12-digit number";
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          AuthTextField(
            controller: phoneController,
            label: "Phone Number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Phone number is required";
              }

              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return "Enter a valid 10-digit number";
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          AuthTextField(
            controller: emailController,
            label: "Email (Optional)",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value)) {
                return "Enter a valid email address";
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          AuthTextField(
            controller: passwordController,
            label: "Password",
            icon: Icons.lock_outline,
            obscureText: !passwordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
              icon: Icon(
                passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              if (value.length < 8) {
                return "Password must contain at least 8 characters";
              }

              return null;
            },
          ),

          const SizedBox(height: 15),

          AuthTextField(
            controller: confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_reset_outlined,
            obscureText: !confirmPasswordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  confirmPasswordVisible = !confirmPasswordVisible;
                });
              },
              icon: Icon(
                confirmPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm your password";
              }

              if (value != passwordController.text) {
                return "Passwords do not match";
              }

              return null;
            },
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: isLoading ? null : register,
            child: const Text("Create Account"),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1000 : 450,
                  ),
                  child: isDesktop
                      ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 650,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.primary,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: const Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_bus_rounded,
                                size: 90,
                                color: Colors.white,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "WayGO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Travel smarter. Travel together.",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 55),

                      Expanded(
                        child: buildRegisterForm(),
                      ),
                    ],
                  )
                      : buildRegisterForm(),
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: WayGoLoadingOverlay(
                  isLoading: true,
                  message: "Creating your account...",
                  child: const SizedBox.expand(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}