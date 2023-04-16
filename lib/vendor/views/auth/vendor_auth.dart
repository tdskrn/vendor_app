import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:vendor_app/utils/keys.dart';

import 'package:vendor_app/vendor/views/auth/vendor_register_screen.dart';

class VendorAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KeysApp _key = KeysApp();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(providerConfigs: [
            EmailProviderConfiguration(),
            GoogleProviderConfiguration(clientId: _key.id),
            PhoneProviderConfiguration(),
          ]);
        }

        // Render your application if authenticated
        return VendorRegistrationScreen();
      },
    );
  }
}
