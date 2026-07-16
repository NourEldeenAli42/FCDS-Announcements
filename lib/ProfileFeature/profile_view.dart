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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fcds_announcements/utils/theme/theme_cubit.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final bool isUpdaterAvailable = ShorebirdUpdater().isAvailable;

  final nameController = TextEditingController(
    text:
        Supabase.instance.client.auth.currentUser?.userMetadata?['full_name'] ??
        '',
  );

  String? _avatarUrlFromMetadata(Object? avatarUrl) {
    if (avatarUrl is! String) return null;

    final match = RegExp(r'https?://[^\s\]\)]+').firstMatch(avatarUrl);
    return match?.group(0);
  }

  Future<String> getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final patch = await ShorebirdUpdater().readCurrentPatch();
    return 'Version: ${packageInfo.version}(${patch?.number ?? '0'})\n\n';
  }

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
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'profile_update_fab',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                final updater = ShorebirdUpdater();
                final status = await updater.checkForUpdate();
                if (status == UpdateStatus.outdated) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Update available, downloading...'),
                      ),
                    );
                  }
                  await updater.update();

                  if (context.mounted) {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Update Downloaded'),
                          content: Text(
                            'The update has been downloaded. Please restart the app to apply the latest updates.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else if (status == UpdateStatus.upToDate) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('App is already up to date!')),
                    );
                  }
                } else if (status == UpdateStatus.restartRequired) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please restart the app to apply the latest updates.',
                        ),
                      ),
                    );
                  }
                }
              },
              child: Icon(Icons.update, color: Colors.white),
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
              color: Theme.of(context).colorScheme.primary,
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
                      Builder(
                        builder: (context) {
                          final avatarUrl = _avatarUrlFromMetadata(
                            Supabase
                                .instance
                                .client
                                .auth
                                .currentUser
                                ?.userMetadata?['avatar_url'],
                          );

                          if (avatarUrl == null) {
                            return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.teal.withAlpha(150),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: AssetImage(Assets.profile),
                              ),
                            );
                          }

                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.teal.withAlpha(150),
                            child: CachedNetworkImage(
                              imageUrl: avatarUrl,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 48,
                                  ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 48,
                                backgroundImage: AssetImage(Assets.profile),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    radius: 48,
                                    backgroundImage: AssetImage(Assets.profile),
                                  ),
                            ),
                          );
                        },
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
                          text:
                              Supabase.instance.client.auth.currentUser?.id ??
                              'N/A',
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
                      _buildThemeSettings(context),
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
                      FutureBuilder(
                        future: getAppInfo(),
                        builder: (context, asyncSnapshot) {
                          return Text.rich(
                            textAlign: .center,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'FCDS Announcements App\n\n',
                                  style: MyTextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: asyncSnapshot.data,
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
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Updater Statues: ',
                              style: MyTextStyle(),
                            ),
                            TextSpan(
                              text: isUpdaterAvailable
                                  ? 'Available'
                                  : 'Unavailable',
                              style: MyTextStyle(
                                color: isUpdaterAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildThemeSettings(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Theme Settings',
                  style: MyTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Theme Mode Selector (Light, Dark, System)
                Text(
                  'Theme Mode',
                  style: MyTextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModeOption(context, ThemeMode.light, Icons.light_mode, 'Light', state.themeMode),
                    _buildModeOption(context, ThemeMode.dark, Icons.dark_mode, 'Dark', state.themeMode),
                    _buildModeOption(context, ThemeMode.system, Icons.settings_brightness, 'System', state.themeMode),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Theme Color Palette Selector
                Text(
                  'Color Palette',
                  style: MyTextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorOption(context, AppThemeType.mint, const Color(0xFF367D65), 'Mint', state.themeType),
                    _buildColorOption(context, AppThemeType.ocean, const Color(0xFF1565C0), 'Ocean', state.themeType),
                    _buildColorOption(context, AppThemeType.sunset, const Color(0xFFD84315), 'Sunset', state.themeType),
                    _buildColorOption(context, AppThemeType.lavender, const Color(0xFF673AB7), 'Lavender', state.themeType),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeOption(
    BuildContext context,
    ThemeMode mode,
    IconData icon,
    String label,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().changeThemeMode(mode);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withAlpha(40) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.withAlpha(80),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: MyTextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    AppThemeType type,
    Color color,
    String label,
    AppThemeType currentType,
  ) {
    final isSelected = type == currentType;
    
    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().changeThemeType(type);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected 
                    ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black) 
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(100),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: MyTextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
