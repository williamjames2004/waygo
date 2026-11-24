import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_loading.dart';

import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final aadharController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    aadharController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService.login(
        aadhar: aadharController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      final passenger = Map<String, dynamic>.from(
        response["passenger"],
      );

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboard,
        arguments: passenger,
      );
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

  Widget buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text("Login to continue your journey."),

          const SizedBox(height: 30),

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

          const SizedBox(height: 18),

          AuthTextField(
            controller: passwordController,
            label: "Password",
            icon: Icons.lock_outline,
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              return null;
            },
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Password reset will be implemented later.
              },
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: isLoading ? null : login,
            child: const Text("Login"),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.register,
                  );
                },
                child: const Text("Register"),
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
                          height: 550,
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
                                "Your journey, simplified.",
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
                        child: buildLoginForm(),
                      ),
                    ],
                  )
                      : buildLoginForm(),
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: WayGoLoadingOverlay(
                  isLoading: true,
                  message: "Signing in...",
                  child: const SizedBox.expand(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}