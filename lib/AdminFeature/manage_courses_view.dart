import 'package:fcds_announcements/AdminFeature/bloc/manage_courses_bloc/manage_courses_bloc.dart';
import 'package:fcds_announcements/AdminFeature/bloc/update_course_cubit/update_course_cubit.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ManageCoursesView extends StatefulWidget {
  const ManageCoursesView({super.key});

  @override
  State<ManageCoursesView> createState() => _ManageCoursesViewState();
}

class _ManageCoursesViewState extends State<ManageCoursesView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController creditsController;
  late final AnimationController _animationController;
  late final ManageCoursesBloc _manageCoursesBloc;
  @override
  void initState() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    creditsController = TextEditingController();
    _animationController = AnimationController(vsync: this);
    _manageCoursesBloc = context.read<ManageCoursesBloc>();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();

        _manageCoursesBloc.add(RefreshCourses());
        _animationController.reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _manageCoursesBloc.add(RefreshCourses());
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Manage Courses'), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder: (dialogContext) {
                return BlocProvider(
                  create: (context) => UpdateCourseCubit(),
                  child: BlocBuilder<UpdateCourseCubit, UpdateCourseState>(
                    builder: (blocContext, state) {
                      return AlertDialog.adaptive(
                        title: Text(
                          'Add Course',
                          style: MyTextStyle(fontSize: 20, fontWeight: .bold),
                        ),
                        content: state is UpdateCourseLoading
                            ? const CircularProgressIndicator()
                            : state is UpdateCourseSuccess
                            ? Lottie.asset(
                                'assets/Checkmark.lottie',
                                controller: _animationController,
                                onLoaded: (composition) {
                                  _animationController.duration =
                                      composition.duration;
                                  _animationController.forward();
                                },
                              )
                            : state is UpdateCourseError
                            ? Lottie.asset(
                                '/assets/Error.lottie',
                                controller: _animationController,
                                onLoaded: (composition) {
                                  _animationController.duration =
                                      composition.duration;
                                  _animationController.forward();
                                },
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController..text = '',
                                    decoration: const InputDecoration(
                                      labelText: 'Course Name',
                                    ),
                                  ),
                                  TextField(
                                    controller: descriptionController
                                      ..text = '',
                                    decoration: const InputDecoration(
                                      labelText: 'Course Description',
                                    ),
                                  ),
                                  TextField(
                                    controller: creditsController..text = '',
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Credits',
                                    ),
                                  ),
                                ],
                              ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              final newCourse = CourseDataModel(
                                id: 0, // Assuming the ID will be generated by the backend
                                name: nameController.text,
                                description: descriptionController.text,
                                credits:
                                    int.tryParse(creditsController.text) ?? 0,
                              );
                              blocContext.read<UpdateCourseCubit>().addCourse(
                                newCourse,
                              );
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        body: BlocBuilder<ManageCoursesBloc, ManageCoursesState>(
          builder: (context, state) {
            if (state is ManageCoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ManageCoursesLoaded) {
              final courses = state.courses;
              return ListView.builder(
                padding: const .all(8),
                itemCount: courses.length,
                itemBuilder: (dialogContext, index) {
                  final course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text.rich(
                        TextSpan(
                          text: course.name,
                          style: MyTextStyle(fontSize: 18, fontWeight: .bold),
                          children: [
                            TextSpan(
                              text: ' (${course.credits})',
                              style: MyTextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: .normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        course.description,
                        style: MyTextStyle(fontSize: 16, fontWeight: .normal),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value: _manageCoursesBloc,

                                child: BlocProvider(
                                  create: (context) => UpdateCourseCubit(),
                                  child: BlocBuilder<UpdateCourseCubit, UpdateCourseState>(
                                    builder: (blocContext, state) {
                                      return AlertDialog.adaptive(
                                        title: Text(
                                          'Edit Course',
                                          style: MyTextStyle(
                                            fontSize: 20,
                                            fontWeight: .bold,
                                          ),
                                        ),
                                        content: state is UpdateCourseSuccess
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
                                            : state is UpdateCourseError
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
                                            : state is UpdateCourseLoading
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    const LinearProgressIndicator(),
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: nameController
                                                      ..text = course.name,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText:
                                                              'Course Name',
                                                        ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        descriptionController
                                                          ..text = course
                                                              .description,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText:
                                                              'Course Description',
                                                        ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        creditsController
                                                          ..text = course
                                                              .credits
                                                              .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                          labelText: 'Credits',
                                                        ),
                                                  ),
                                                ],
                                              ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              blocContext
                                                  .read<UpdateCourseCubit>()
                                                  .deleteCourse(course.id);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(blocContext).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              final updatedCourse =
                                                  CourseDataModel(
                                                    id: course.id,
                                                    name: nameController.text,
                                                    description:
                                                        descriptionController
                                                            .text,
                                                    credits:
                                                        int.tryParse(
                                                          creditsController
                                                              .text,
                                                        ) ??
                                                        0,
                                                  );
                                              blocContext
                                                  .read<UpdateCourseCubit>()
                                                  .updateCourse(updatedCourse);
                                            },
                                            child: const Text('Save'),
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
                      ),
                    ),
                  );
                },
              );
            } else if (state is ManageCoursesError) {
              return Center(child: Text('Error loading courses'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
