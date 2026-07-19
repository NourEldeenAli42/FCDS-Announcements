import 'package:fcds_announcements/AdminFeature/Widgets/total_admins_card.dart';
import 'package:fcds_announcements/AdminFeature/Widgets/total_students_card.dart';
import 'package:fcds_announcements/AdminFeature/Widgets/user_card.dart';
import 'package:fcds_announcements/AdminFeature/bloc/search_users_bloc/search_users_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  BuildContext? _activeDialogContext;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_activeDialogContext?.mounted ?? false) {
          Navigator.of(_activeDialogContext!, rootNavigator: true).pop();
          _activeDialogContext = null;
        }
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchUsersBloc()..add(SearchUsersInitialEvent()),
      child: BlocBuilder<SearchUsersBloc, SearchUsersState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Manage Users',
                style: MyTextStyle(fontWeight: .bold),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<SearchUsersBloc>().add(
                    RefreshSearchUsersEvent(),
                  );
                },
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    SearchBar(
                      textStyle: WidgetStateProperty.all(MyTextStyle()),
                      onChanged: (value) {
                        context.read<SearchUsersBloc>().add(
                          SearchUsersQueryChangedEvent(
                            value,
                            users: state is SearchResultsLoaded
                                ? state.users
                                : [],
                          ),
                        );
                      },
                      hintText: 'Search by name or email...',
                      hintStyle: WidgetStateProperty.all(
                        MyTextStyle(color: Colors.grey),
                      ),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      leading: Icon(Icons.search, color: Colors.grey),
                      side: WidgetStateProperty.all(
                        BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<SearchUsersBloc, SearchUsersState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Skeletonizer(
                              enabled: state is! SearchResultsLoaded,
                              enableSwitchAnimation: true,
                              child: TotalStudentsCard(
                                totalStudents: state is SearchResultsLoaded
                                    ? state.totalUsers
                                    : null, // Replace with actual data
                              ),
                            ),
                            Skeletonizer(
                              enabled: state is! SearchResultsLoaded,
                              enableSwitchAnimation: true,
                              child: TotalAdminsCard(
                                totalAdmins: state is SearchResultsLoaded
                                    ? state.totalAdmins
                                    : null,
                              ), // Replace with actual data
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          'Manage Admins',
                          style: MyTextStyle(fontSize: 18, fontWeight: .bold),
                        ),
                        Text(
                          state is SearchResultsLoaded
                              ? '${state.users.length} Users'
                              : '...',
                          style: MyTextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<SearchUsersBloc, SearchUsersState>(
                        builder: (context, state) {
                          if (state is SearchResultsLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is SearchResultsLoaded) {
                            final users = state.users;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return UserCard(
                                  userData: user,
                                  onClick: () {
                                    showAdaptiveDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        _activeDialogContext = dialogContext;
                                        return BlocProvider(
                                          create: (context) =>
                                              SearchUsersBloc(),
                                          child: BlocBuilder<SearchUsersBloc, SearchUsersState>(
                                            builder: (context, state) {
                                              return AlertDialog(
                                                title: Text(
                                                  user.isAdmin
                                                      ? 'Remove Admin Permission'
                                                      : 'Add Admin Permission',
                                                  style: MyTextStyle(
                                                    fontWeight: .bold,
                                                  ),
                                                ),
                                                content:
                                                    state
                                                        is SearchResultsLoading
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : state is RequestSentState
                                                    ? Lottie.asset(
                                                        'assets/Checkmark.lottie',
                                                        width: 200,
                                                        height: 200,
                                                        controller:
                                                            _animationController,
                                                        onLoaded: (composition) {
                                                          _animationController
                                                            ..duration =
                                                                composition
                                                                    .duration
                                                            ..forward();
                                                        },
                                                      )
                                                    : state
                                                          is SearchResultsError
                                                    ? Text(
                                                        'Failed to send request: ${state.error}',
                                                      )
                                                    : Text(
                                                        'Are you sure you want to ${user.isAdmin ? "remove" : "add"} admin permission from ${user.name}?',
                                                      ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () {
                                                      if (user.isAdmin) {
                                                        context
                                                            .read<
                                                              SearchUsersBloc
                                                            >()
                                                            .add(
                                                              RemoveAdminPermissionEvent(
                                                                user,
                                                              ),
                                                            );
                                                      } else {
                                                        context
                                                            .read<
                                                              SearchUsersBloc
                                                            >()
                                                            .add(
                                                              AddAdminPermissionEvent(
                                                                user,
                                                              ),
                                                            );
                                                      }
                                                    },
                                                    child: Text(
                                                      user.isAdmin
                                                          ? 'Remove'
                                                          : 'Add',
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      _activeDialogContext = null;
                                    });
                                  },
                                );
                              },
                            );
                          } else if (state is SearchResultsError) {
                            return Center(child: Text(state.error));
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
