import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/screens/home/components/profile_text_widget.dart';
import 'package:pepoll/screens/home/components/top_banner_widget.dart';


class ProfileTab extends StatelessWidget {
  final User user;
  const ProfileTab({Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String firstName = user.displayName.split((' '))[0];
    return Expanded(
      child: Column(
        children: [
          TopBannerWidget(firstName: firstName, email: user.email),
          const SizedBox(height: 20,),
          CircleAvatar(
            backgroundColor: kDarkMatteViolet,
            radius: 150,
            child: Image.network(user.photoURL, fit: BoxFit.fill,),
          ),
          const SizedBox(height: 50,),
          ProfileTextWidget(text: user.displayName),
          const SizedBox(height: 20,),
          ProfileTextWidget(text: user.email),
        ],
      ),
    );
  }
}
