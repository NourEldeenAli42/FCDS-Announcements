import 'package:cached_network_image/cached_network_image.dart';
import 'package:fcds_announcements/LoginFeature/repositories/auth_repository.dart';
import 'package:fcds_announcements/ProfileFeature/bloc/Profile%20Bloc/profile_bloc.dart';
import 'package:fcds_announcements/generated/assets.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final nameController = TextEditingController(
    text: FirebaseAuth.instance.currentUser?.displayName ?? '',
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: .end,
          children: [
            FloatingActionButton(
              heroTag: 'profile_linkedin_fab',
              backgroundColor: Colors.blue,
              onPressed: () {
                Uri url = Uri.parse(
                  'https://www.linkedin.com/in/noureldeenali',
                );
                launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: FaIcon(FontAwesomeIcons.linkedinIn, color: Colors.white),
            ),
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'profile_whatsapp_fab',
              backgroundColor: Colors.green,
              onPressed: () {
                Uri url = Uri.parse('https://wa.link/woouk0');
                launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(
            'Profile',
            style: MyTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color.fromARGB(255, 54, 125, 101),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(RefreshProfileEvent());
                nameController.text =
                    FirebaseAuth.instance.currentUser?.displayName ?? '';
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal.withAlpha(150),
                        child: CachedNetworkImage(
                          imageUrl:
                              FirebaseAuth.instance.currentUser?.photoURL ??
                              Assets.assetsLinks,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 48,
                              ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        FirebaseAuth.instance.currentUser?.displayName ??
                            'User',
                        style: MyTextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // Display email if available
                      if (FirebaseAuth.instance.currentUser?.email != null)
                        Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: MyTextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 24),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: FirebaseAuth.instance.currentUser?.uid ?? 'N/A',
                        ),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: nameController,
                      ),
                      SizedBox(height: 24),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoading) {
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is ProfileFailure) {
                            return Text(
                              'Error: ${state.error}',
                              style: MyTextStyle(color: Colors.red),
                            );
                          } else if (state is ProfileSuccess) {
                            return Text(
                              'Profile updated successfully!, please refresh the page.',
                              style: MyTextStyle(color: Colors.green),
                            );
                          } else if (state is ProfileInitial) {
                            return OutlinedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(
                                  UpdateProfile(nameController.text),
                                );
                              },
                              child: Text('Update Profile'),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 24),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text(
                                  'Logout',
                                  style: MyTextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to logout?\nAll your reminders and messages history will be cleared from this device.',
                                  style: MyTextStyle(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: MyTextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await AuthRepository().signOut();
                                      if (dialogContext.mounted) {
                                        Navigator.of(dialogContext).pop();
                                      }
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text(
                                      'Logout',
                                      style: MyTextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Logout'),
                      ),
                      SizedBox(height: 16),
                      Text.rich(
                        textAlign: .center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'FCDS Announcements App\n',
                              style: MyTextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Version 1.0.0\n',
                              style: MyTextStyle(),
                            ),
                            TextSpan(
                              text: 'Developed by',
                              style: MyTextStyle(),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Uri url = Uri.parse(
                                    'https://www.linkedin.com/in/noureldeenali',
                                  );
                                  launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              text: ' Nour "Eldeen" Ali',
                              style: MyTextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 54, 125, 101),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
