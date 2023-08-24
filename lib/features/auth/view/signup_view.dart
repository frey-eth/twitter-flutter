import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/common/loading_page.dart';
import 'package:twitter/constants/ui_constants.dart';
import 'package:twitter/features/auth/controller/auth_controller.dart';
import 'package:twitter/common/rounded_small_button.dart';
import 'package:twitter/features/auth/view/login_view.dart';
import 'package:twitter/features/auth/widgets/auth_field.dart';
import 'package:twitter/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    AuthField(
                      controller: emailController,
                      hintText: 'Email',
                      obscure: false,
                    ),
                    const SizedBox(height: 25),
                    AuthField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: RoundedSmallButton(
                        ontap: onSignUp,
                        label: 'Done',
                        backgroundColor: Pallete.whiteColor,
                        textColor: Pallete.backgroundColor,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Already have an account?",
                          style: const TextStyle(
                              color: Pallete.whiteColor, fontSize: 16),
                          children: [
                            TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                    color: Pallete.blueColor, fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, LoginView.route());
                                  })
                          ]),
                    )
                  ]),
                ),
              ),
            ),
    );
  }
}
