import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/widgets/buildsociallogin.dart';
import 'package:taskmanager/core/widgets/image_widget.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_event.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_state.dart';
import 'package:taskmanager/presentation/pages/home_page.dart';
import 'package:taskmanager/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            // Wrap with SingleChildScrollView
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
                    "Welcome back!",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          color: Color(0xff57018a),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthAuthenticated) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false, // ✅ Clears previous screens
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
                            context.read<AuthBloc>().add(AuthLoginEvent(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff57018a),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Log in",
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
                  const Text("or log in with"),
                  const SizedBox(height: 10),
                  Buildsociallogin(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    ),
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                            fontFamily: 'Satoshi', color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Get started!",
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
}
