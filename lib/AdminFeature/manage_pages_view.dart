import 'package:fcds_announcements/AdminFeature/Widgets/page_card.dart';
import 'package:fcds_announcements/AdminFeature/bloc/manage_pages_bloc/manage_pages_bloc.dart';
import 'package:fcds_announcements/AdminFeature/bloc/page_info_cubit/page_info_cubit.dart';
import 'package:fcds_announcements/AdminFeature/bloc/update_pages_cubit/update_pages_cubit.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ManagePagesView extends StatefulWidget {
  const ManagePagesView({super.key});

  @override
  State<ManagePagesView> createState() => _ManagePagesViewState();
}

class _ManagePagesViewState extends State<ManagePagesView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController searchController;
  late final TextEditingController titleController;
  late final TextEditingController hallController;
  late final AnimationController _animationController;
  String selectedInstructor = '';
  @override
  void initState() {
    titleController = TextEditingController();
    hallController = TextEditingController();
    searchController = TextEditingController();
    _animationController = AnimationController(vsync: this);
    final managePagesBloc = context.read<ManagePagesBloc>();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        _animationController.reset();
        managePagesBloc.add(RefreshPagesEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    hallController.dispose();
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagePagesBloc, ManagePagesState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ManagePagesBloc>().add(RefreshPagesEvent());
          },
          child: Scaffold(
            appBar: AppBar(title: Text('Manage Pages'), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SearchBar(
                    hintText: 'Search Pages',
                    controller: searchController,
                    leading: Icon(Icons.search),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  state is ManagePagesLoading
                      ? Center(child: CircularProgressIndicator())
                      : state is ManagePagesError
                      ? Center(
                          child: Text(
                            'Error: ${state.message}',
                            style: MyTextStyle(fontSize: 16, color: Colors.red),
                          ),
                        )
                      : SizedBox.shrink(),
                  state is ManagePagesLoaded
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state
                                .pages
                                .length, // Replace with the actual number of pages
                            itemBuilder: (context, index) => PageCard(
                              pageData: state.pages[index],
                              onEdit: (page) {
                                var selectedTime = page.startTime;
                                var timeText = selectedTime.format(context);
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              UpdatePagesCubit(),
                                        ),
                                        BlocProvider.value(
                                          value: context
                                              .read<ManagePagesBloc>(),
                                        ),
                                      ],
                                      child: Stack(
                                        alignment: .center,
                                        children: [
                                          AbsorbPointer(
                                            absorbing: true,
                                            child: Opacity(
                                              opacity: 0.1,
                                              child: AlertDialog(
                                                title: Text('Edit Page'),
                                                content: BlocBuilder<PageInfoCubit, PageInfoState>(
                                                  builder: (blocContext, state) {
                                                    if (state
                                                        is PageInfoLoading) {
                                                      return SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (state
                                                        is PageInfoError) {
                                                      return Text(
                                                        'Error: ${state.message}',
                                                        style: MyTextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    } else if (state
                                                        is PageInfoLoaded) {
                                                      final instructors =
                                                          state.instructors;
                                                      return StatefulBuilder(
                                                        builder:
                                                            (
                                                              dialogContext,
                                                              setDialogState,
                                                            ) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    .min,
                                                                children: [
                                                                  TextField(
                                                                    controller:
                                                                        titleController
                                                                          ..text =
                                                                              page.title,
                                                                    decoration: const InputDecoration(
                                                                      labelText:
                                                                          'Page Title',
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: hallController
                                                                            ..text =
                                                                                page.hall,
                                                                          decoration: const InputDecoration(
                                                                            labelText:
                                                                                'Hall',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          final pickedTime = await showTimePicker(
                                                                            context:
                                                                                dialogContext,
                                                                            initialTime:
                                                                                selectedTime,
                                                                          );
                                                                          if (pickedTime !=
                                                                              null) {
                                                                            setDialogState(() {
                                                                              selectedTime = pickedTime;
                                                                              timeText = selectedTime.format(
                                                                                dialogContext,
                                                                              );
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color: Color.fromARGB(
                                                                            255,
                                                                            54,
                                                                            125,
                                                                            101,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        timeText,
                                                                        style: MyTextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 16,
                                                                  ),
                                                                  DropdownButtonFormField<
                                                                    String
                                                                  >(
                                                                    initialValue:
                                                                        page.instructor,
                                                                    items: instructors
                                                                        .map(
                                                                          (
                                                                            instructor,
                                                                          ) =>
                                                                              DropdownMenuItem<
                                                                                String
                                                                              >(
                                                                                value: instructor.name,
                                                                                child: Text(
                                                                                  '${instructor.doctor ? 'Dr. ' : 'TA/ '}${instructor.name}',
                                                                                ),
                                                                              ),
                                                                        )
                                                                        .toList(),
                                                                    onChanged: (value) {
                                                                      setDialogState(() {
                                                                        selectedInstructor =
                                                                            value!;
                                                                      });
                                                                    },
                                                                    decoration: const InputDecoration(
                                                                      labelText:
                                                                          'Instructor',
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                      );
                                                    } else {
                                                      return SizedBox.shrink();
                                                    }
                                                  },
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
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Under Construction',
                                            style: MyTextStyle(
                                              fontSize: 24,
                                              color: Colors.red,
                                              fontWeight: .bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              onDelete: (page) {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: context
                                              .read<ManagePagesBloc>(),
                                        ),
                                        BlocProvider(
                                          create: (context) =>
                                              UpdatePagesCubit(),
                                        ),
                                      ],
                                      child: BlocBuilder<UpdatePagesCubit, UpdatePagesState>(
                                        builder: (blocContext, state) {
                                          return AlertDialog(
                                            title: Text('Delete Page'),
                                            content: state is UpdatePagesLoading
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        LinearProgressIndicator(),
                                                  )
                                                : state is UpdatePagesError
                                                ? Lottie.asset(
                                                    'assets/Error.lottie',
                                                    controller:
                                                        _animationController,
                                                    onLoaded: (composition) {
                                                      _animationController
                                                              .duration =
                                                          composition.duration;
                                                      _animationController
                                                          .forward();
                                                    },
                                                  )
                                                : state is UpdatePagesSuccess
                                                ? Lottie.asset(
                                                    'assets/Checkmark.lottie',
                                                    controller:
                                                        _animationController,
                                                    onLoaded: (composition) {
                                                      _animationController
                                                              .duration =
                                                          composition.duration;
                                                      _animationController
                                                          .forward();
                                                    },
                                                  )
                                                : Text(
                                                    'Are you sure you want to delete this page?',
                                                  ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    dialogContext,
                                                  ).pop();
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: MyTextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              FilledButton(
                                                onPressed: () {
                                                  blocContext
                                                      .read<UpdatePagesCubit>()
                                                      .deletePage(page.id);
                                                },
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ), // Replace with the actual page card widget
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
