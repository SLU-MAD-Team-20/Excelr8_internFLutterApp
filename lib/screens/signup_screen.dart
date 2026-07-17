import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'login_screen.dart';
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                "Welcome!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              const CustomTextField(
                label: "Username",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              const CustomTextField(
                label: "Email Address",
                 icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              const CustomTextField(
                label: "Password",
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 20),

              const CustomTextField(
                label: "Confirm Password",
                 icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: "Create Account",
                onPressed: () {
                  // Registration logic will come later
                },
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),

                  TextButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  },
  child: const Text("Sign In"),
),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}