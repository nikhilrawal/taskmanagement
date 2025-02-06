import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/widgets/buildsociallogin.dart';
import 'package:taskmanager/core/widgets/image_widget.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_event.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_state.dart';
import 'package:taskmanager/presentation/pages/home_page.dart';
import 'package:taskmanager/presentation/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(size: 200),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's get started!",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      emailController, "Email Address", Icons.email),
                  const SizedBox(height: 10),
                  _buildTextField(passwordController, "Password", Icons.lock,
                      obscureText: true),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthAuthenticated) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthRegisterEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff57018a),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("or sign up with"),
                  const SizedBox(height: 10),
                  Buildsociallogin(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                            fontFamily: 'Satoshi', color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              fontFamily: 'Satoshi',
                              color: Color(0xff57018a),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
