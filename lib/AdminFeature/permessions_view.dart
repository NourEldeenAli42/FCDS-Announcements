import 'package:fcds_announcements/AdminFeature/Widgets/page_search_delegate.dart';
import 'package:fcds_announcements/AdminFeature/Widgets/user_permission_card.dart';
import 'package:fcds_announcements/AdminFeature/bloc/add_permission_cubit/add_permission_cubit.dart';
import 'package:fcds_announcements/AdminFeature/bloc/permissions_bloc/permissions_bloc.dart';
import 'package:fcds_announcements/AdminFeature/bloc/remove_permission_cubit/remove_permission_cubit.dart';
import 'package:fcds_announcements/AdminFeature/bloc/search_users_bloc/search_users_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PermessionsView extends StatefulWidget {
  const PermessionsView({super.key});

  @override
  State<PermessionsView> createState() => _PermessionsViewState();
}

class _PermessionsViewState extends State<PermessionsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        _animationController.reset();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchUsersBloc()..add(const SearchUsersInitialEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text('Manage Permissions')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                textStyle: WidgetStateProperty.all(MyTextStyle()),
                onChanged: (value) {},
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
              BlocBuilder<SearchUsersBloc, SearchUsersState>(
                builder: (context, state) {
                  if (state is SearchResultsLoading) {
                    return Center(child: CircularProgressIndicator());
                    // ignore: dead_code
                  } else if (state is SearchResultsError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is SearchResultsLoaded) {
                    final users = state.users;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserPermissionCard(
                            userData: user,
                            onClick: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  final permissionsBloc = PermissionsBloc()
                                    ..add(
                                      LoadPermissionsEvent(userId: user.id),
                                    );

                                  return BlocProvider(
                                    create: (context) => permissionsBloc,
                                    child: BlocBuilder<PermissionsBloc, PermissionsState>(
                                      builder: (context, state) {
                                        return Container(
                                          padding: EdgeInsets.all(16),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Edit Permissions for ${user.name}',
                                                  style: MyTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                if (state is PermissionsLoading)
                                                  CircularProgressIndicator()
                                                else if (state
                                                    is PermissionsLoaded)
                                                  ...state.pagesWithPermissions.map((
                                                    page,
                                                  ) {
                                                    return ListTile(
                                                      title: Text(page.title),
                                                      subtitle: Wrap(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                  right: 6,
                                                                  top: 4,
                                                                ),
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade100,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.circle,
                                                                  size: 8,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade800,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                  page.instructor,
                                                                  style: MyTextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .shade800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                  right: 6,
                                                                  top: 4,
                                                                ),
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade100,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.circle,
                                                                  size: 8,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade800,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                  page.startTime
                                                                      .format(
                                                                        context,
                                                                      ),
                                                                  style: MyTextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .shade800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                  right: 6,
                                                                  top: 4,
                                                                ),
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade100,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.circle,
                                                                  size: 8,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade800,
                                                                ),
                                                                SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Text(
                                                                  page.hall,
                                                                  style: MyTextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .shade800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: GestureDetector(
                                                        onTap: () {
                                                          final permissionsBloc =
                                                              context
                                                                  .read<
                                                                    PermissionsBloc
                                                                  >();

                                                          showAdaptiveDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return BlocProvider(
                                                                create: (context) =>
                                                                    RemovePermissionCubit(),
                                                                child:
                                                                    BlocListener<
                                                                      RemovePermissionCubit,
                                                                      RemovePermissionState
                                                                    >(
                                                                      listener:
                                                                          (
                                                                            context,
                                                                            state,
                                                                          ) {
                                                                            if (state
                                                                                is RemovePermissionSuccess) {
                                                                              if (context.mounted) {}
                                                                              permissionsBloc.add(
                                                                                LoadPermissionsEvent(
                                                                                  userId: user.id,
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                      child:
                                                                          BlocBuilder<
                                                                            RemovePermissionCubit,
                                                                            RemovePermissionState
                                                                          >(
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                  state,
                                                                                ) {
                                                                                  return AlertDialog(
                                                                                    title: Text(
                                                                                      'Confirm',
                                                                                    ),
                                                                                    content:
                                                                                        state
                                                                                            is RemovePermissionSuccess
                                                                                        ? Lottie.network(
                                                                                            'https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                                                                                            width: 100,
                                                                                            height: 100,
                                                                                            controller: _animationController,
                                                                                            onLoaded:
                                                                                                (
                                                                                                  composition,
                                                                                                ) {
                                                                                                  _animationController.duration = composition.duration;
                                                                                                  _animationController.forward();
                                                                                                },
                                                                                          )
                                                                                        : state
                                                                                              is RemovePermissionLoading
                                                                                        ? SizedBox(
                                                                                            width: 20,
                                                                                            height: 20,
                                                                                            child: CircularProgressIndicator(),
                                                                                          )
                                                                                        : Text(
                                                                                            'Are you sure you want to remove admin permission for ${user.name} on ${page.title}?',
                                                                                          ),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(
                                                                                            context,
                                                                                          ).pop();
                                                                                        },
                                                                                        child: Text(
                                                                                          'Cancel',
                                                                                        ),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () async {
                                                                                          context
                                                                                              .read<
                                                                                                RemovePermissionCubit
                                                                                              >()
                                                                                              .removePermission(
                                                                                                user.id,
                                                                                                page.id,
                                                                                              );
                                                                                        },
                                                                                        child: Text(
                                                                                          'Confirm',
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                          ),
                                                                    ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                else
                                                  Text(
                                                    'No permissions available.',
                                                  ),
                                                FilledButton(
                                                  onPressed: () async {
                                                    final result =
                                                        await showSearch(
                                                          context: context,
                                                          delegate:
                                                              PageSearchDelegate(
                                                                userId: user.id,
                                                              ),
                                                        );
                                                    if (result != null) {
                                                      if (context.mounted) {
                                                        final permissionsBloc =
                                                            context
                                                                .read<
                                                                  PermissionsBloc
                                                                >();

                                                        showAdaptiveDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return BlocProvider(
                                                              create: (context) =>
                                                                  AddPermissionCubit(),
                                                              child:
                                                                  BlocListener<
                                                                    AddPermissionCubit,
                                                                    AddPermissionState
                                                                  >(
                                                                    listener:
                                                                        (
                                                                          context,
                                                                          state,
                                                                        ) {
                                                                          if (state
                                                                              is AddPermissionSuccess) {
                                                                            permissionsBloc.add(
                                                                              LoadPermissionsEvent(
                                                                                userId: user.id,
                                                                              ),
                                                                            );
                                                                          }
                                                                        },
                                                                    child:
                                                                        BlocBuilder<
                                                                          AddPermissionCubit,
                                                                          AddPermissionState
                                                                        >(
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                state,
                                                                              ) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    'Add Permission',
                                                                                  ),
                                                                                  content:
                                                                                      state
                                                                                          is AddPermissionLoading
                                                                                      ? SizedBox(
                                                                                          width: 20,
                                                                                          height: 20,
                                                                                          child: CircularProgressIndicator(),
                                                                                        )
                                                                                      : state
                                                                                            is AddPermissionSuccess
                                                                                      ? Lottie.network(
                                                                                          'https://assets10.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                                                                                          width: 100,
                                                                                          height: 100,
                                                                                          controller: _animationController,
                                                                                          onLoaded:
                                                                                              (
                                                                                                composition,
                                                                                              ) {
                                                                                                _animationController.duration = composition.duration;
                                                                                                _animationController.forward();
                                                                                              },
                                                                                        )
                                                                                      : Text.rich(
                                                                                          TextSpan(
                                                                                            text: 'Are you sure you want to add admin permission for ${user.name} on:',
                                                                                            children: result
                                                                                                .map(
                                                                                                  (
                                                                                                    page,
                                                                                                  ) => TextSpan(
                                                                                                    text: '\n- ${page.title}',
                                                                                                    style: MyTextStyle(
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      color: Colors.green,
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                                .toList(),
                                                                                          ),
                                                                                        ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(
                                                                                          context,
                                                                                        ).pop();
                                                                                      },
                                                                                      child: Text(
                                                                                        'Cancel',
                                                                                      ),
                                                                                    ),
                                                                                    FilledButton(
                                                                                      onPressed: () async {
                                                                                        context
                                                                                            .read<
                                                                                              AddPermissionCubit
                                                                                            >()
                                                                                            .addPermissions(
                                                                                              user.id,
                                                                                              result,
                                                                                            );
                                                                                      },
                                                                                      child: Text(
                                                                                        'Confirm',
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                        ),
                                                                  ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Text('Add Permission'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No results found.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
