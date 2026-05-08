import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionGVM gvm = ref.read(sessionProvider.notifier);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomAuthTextFormField(
            text: "Username",
            obscureText: false,
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
              text: "로그인",
              funPageRoute: () async {
                await gvm.login(_username.text.trim(), _password.text.trim());
                Navigator.popAndPushNamed(context, Move.postListPage);
              }),
        ],
      ),
    );
  }
}
