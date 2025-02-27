import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/custom_uis/custom_divider.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/common/utils/functions/utils_functions.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/presentation/providers/tasks_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/common_text/common_text.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_textfield/tasks_text_field.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    getUsers();
    _selectedDay = _focusedDay;
    super.initState();
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  bool _isSaveEnabled() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _rangeStart != null &&
        _rangeEnd != null && getIt<UserProvider>().selectedUserIds.isNotEmpty;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartTaskAppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TableCalendar(
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week',
                },
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                onPageChanged: (focusDay) {
                  _focusedDay = focusDay;
                },
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onRangeSelected: _onRangeSelected,
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: SmartTaskAppColors.primaryColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: buildText(
                    _rangeStart != null && _rangeEnd != null
                        ? 'Task starting at ${formatDate(dateTime: _rangeStart.toString())} - ${formatDate(dateTime: _rangeEnd.toString())}'
                        : 'Select a date range',
                    SmartTaskAppColors.primaryColor,
                    9,
                    FontWeight.w400,
                    TextAlign.start,
                    TextOverflow.clip,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// Select Users
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.userState == UserState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userProvider.userState == UserState.error) {
                    return Center(
                        child: Text(userProvider.errorMessage ??
                            "Failed to load users"));
                  } else if (userProvider.userState == UserState.loaded) {
                    return SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userProvider.users.length,
                        itemBuilder: (context, index) {
                          final user = userProvider.users[index];
                          bool isSelected =
                              userProvider.selectedUserIds.contains(user.id);

                          return GestureDetector(
                            onTap: () {
                              userProvider.toggleUserSelection(user.id);
                              setState(
                                  () {}); // Ensure UI updates when a user is selected
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        getUserNameInitials(user.name),
                                        style: SmartTaskFonts.medium().copyWith(
                                          color: SmartTaskAppColors.whiteColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    user.name.split(' ').first,
                                    style: SmartTaskFonts.large().copyWith(
                                      fontSize: 17,
                                      color: SmartTaskAppColors.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox(); // Empty state
                },
              ),

              CustomDivider(),
              buildText('Title', SmartTaskAppColors.blackColor, 15,
                  FontWeight.bold, TextAlign.start, TextOverflow.clip),
              const SizedBox(height: 10),
              BuildTextField(
                hint: "Task Title",
                controller: titleController,
                inputType: TextInputType.text,
                fillColor: SmartTaskAppColors.whiteColor,
                onChange: (value) => setState(() {}),
              ),
              const SizedBox(height: 20),
              buildText('Description', SmartTaskAppColors.blackColor, 15,
                  FontWeight.bold, TextAlign.start, TextOverflow.clip),
              const SizedBox(height: 10),
              BuildTextField(
                hint: "Task Description",
                controller: descriptionController,
                inputType: TextInputType.multiline,
                fillColor: SmartTaskAppColors.whiteColor,
                onChange: (value) => setState(() {}),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    bgColor: SmartTaskAppColors.greyColor,
                  ),
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      String buttonText = "Save";
                      VoidCallback? onTap = _isSaveEnabled()
                          ? () {

                              taskProvider.addNewTask(titleController.text,
                                  descriptionController.text,
                                  formatAddTaskDate(_rangeStart!),
                                  formatAddTaskDate(_rangeEnd!),
                                  getIt<UserProvider>().selectedUserIds);
                            }
                          : null;

                      if (taskProvider.taskState == TaskState.loading) {
                        buttonText = "Saving...";
                        onTap = null;
                      } else if (taskProvider.taskState == TaskState.success) {
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          titleController.clear();
                          descriptionController.clear();
                          _rangeStart = null;
                          _rangeEnd = null;
                          _selectedDay=null;
                          getIt<UserProvider>().resetSelectedUsers();
                          _isSaveEnabled();
                        });

                      }

                      return CustomButton(
                        onTap: onTap,
                        text: buttonText,
                        bgColor: _isSaveEnabled()
                            ? SmartTaskAppColors.buttonBackGroundColor
                            : SmartTaskAppColors.greyColor,
                      );
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

  DateTime toDate({required String dateTime}) {
    final utcDateTime = DateTime.parse(dateTime);
    return utcDateTime.toLocal();
  }

  String formatDate({required String dateTime, format = "dd MMM, yyyy"}) {
    final localDateTime = toDate(dateTime: dateTime);
    return DateFormat(format).format(localDateTime);
  }

  void getUsers() {
    getIt<UserProvider>().getAllUsers();
  }
}

