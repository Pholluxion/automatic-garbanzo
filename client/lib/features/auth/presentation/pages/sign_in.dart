import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'package:client/features/wallet/presentation/pages/pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SupaEmailAuth(
                localization: _localizations,
                onSignInComplete: (response) {
                  log('onSignInComplete: $response');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const BudgetPage(),
                    ),
                    (route) => false,
                  );
                },
                onSignUpComplete: (response) {
                  log('onSignUpComplete: $response');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const BudgetPage(),
                    ),
                    (route) => false,
                  );
                },
                metadataFields: [
                  MetaDataField(
                    prefixIcon: const Icon(Icons.person),
                    label: 'auth.user_name'.tr(),
                    key: 'username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'auth.enter_username'.tr();
                      }
                      return null;
                    },
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

final _localizations = SupaEmailAuthLocalization(
  enterEmail: 'auth.enter_email'.tr(),
  validEmailError: 'auth.valid_email_error'.tr(),
  enterPassword: 'auth.enter_password'.tr(),
  passwordLengthError: 'auth.password_length_error'.tr(),
  signIn: 'auth.sign_in'.tr(),
  signUp: 'auth.sign_up'.tr(),
  forgotPassword: 'auth.forgot_password'.tr(),
  dontHaveAccount: 'auth.dont_have_account'.tr(),
  haveAccount: 'auth.have_account'.tr(),
  sendPasswordReset: 'auth.send_password_reset'.tr(),
  backToSignIn: 'auth.back_to_sign_in'.tr(),
  unexpectedError: 'auth.unexpected_error'.tr(),
);
