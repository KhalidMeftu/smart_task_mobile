import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/common_text/common_text.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_textfield/tasks_text_field.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/custom_button/custom_button.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    super.initState();
  }

  _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
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
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: SmartTaskAppColors.primaryColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: buildText(
                    _rangeStart != null && _rangeEnd != null
                        ? 'Task starting at ${formatDate(dateTime: _rangeStart.toString())} - ${formatDate(dateTime: _rangeEnd.toString())}'
                        : 'Select a date range',
                    SmartTaskAppColors.primaryColor,
                    9,
                    FontWeight.w400,
                    TextAlign.start,
                    TextOverflow.clip),
              ),
              const SizedBox(height: 20),
              buildText('Title', SmartTaskAppColors.blackColor, 15,
                  FontWeight.bold, TextAlign.start, TextOverflow.clip),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                  hint: "Task Title",
                  controller: title,
                  inputType: TextInputType.text,
                  fillColor: SmartTaskAppColors.whiteColor,
                  onChange: (value) {}),
              const SizedBox(
                height: 20,
              ),
              buildText('Description', SmartTaskAppColors.blackColor, 15,
                  FontWeight.bold, TextAlign.start, TextOverflow.clip),
              const SizedBox(
                height: 10,
              ),
              BuildTextField(
                  hint: "Task Description",
                  controller: description,
                  inputType: TextInputType.multiline,
                  fillColor: SmartTaskAppColors.whiteColor,
                  onChange: (value) {}),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: (){

                    },
                    text: "Cancel",
                    bgColor: SmartTaskAppColors.greyColor,
                  ),
                  CustomButton(
                    onTap: (){

                    },
                    text: "Save",
                    bgColor: SmartTaskAppColors.buttonBackGroundColor,
                  ),

                ],
              )

              //final String taskId = DateTime.now()
              //                           .millisecondsSinceEpoch
              //                           .toString();
              //                       var taskModel = flutterTaskModel(
              //                           id: taskId,
              //                           title: title.text,
              //                           description: description.text,
              //                           startDateTime: _rangeStart,
              //                           stopDateTime: _rangeEnd);
              //                       context.read<TasksBloc>().add(
              //                           AddNewTaskEvent(
              //                               taskModel: taskModel));
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
}

//https://github.com/nikhilbadyal/settings_ui
// date formats and update database  bcend
// test locally
/// implemente local databases, user settings(theme, 2fa,notifications and firebase/
/// migrate to jwt
/// env, device IP center
/// images and text commom, textfields
/// tests
///
