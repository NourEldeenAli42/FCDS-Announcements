import 'package:fcds_announcements/LoginFeature/bloc/google_login_bloc.dart';
import 'package:fcds_announcements/LoginFeature/repositories/auth_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => GoogleLoginBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: .center,
            children: [
              const Center(
                child: Image(
                  image: AssetImage('assets/hat.png'),
                  height: 50,
                  color: Color.fromARGB(255, 54, 125, 101),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'FCDS Announcements',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: .bold,
                  fontSize: 24,
                ),
              ),
              Text(
                'Student Portal Login',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: .w500,
                  color: Color(0xFF608579),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: .w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please sign in to continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: .w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    BlocConsumer<GoogleLoginBloc, GoogleLoginState>(
                      listener: (context, state) {
                        if (state is GoogleLoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is GoogleLoginInProgress
                              ? null
                              : () {
                                  context.read<GoogleLoginBloc>().add(
                                    GoogleLoginRequested(),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF367D65),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is GoogleLoginInProgress
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Image(
                                  image: AssetImage(
                                    'assets/google_sign_in.png',
                                  ),
                                  height: 50,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'By signing in, you agree to our ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Color(0xFF608579),
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Color(0xFF608579),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle tap if needed
                        },
                    ),
                    TextSpan(
                      text: ' and ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Color(0xFF608579),
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Color(0xFF608579),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle tap if needed
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
