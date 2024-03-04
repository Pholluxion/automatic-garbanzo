import 'dart:developer';

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
                    label: 'Username',
                    key: 'username',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter something';
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
