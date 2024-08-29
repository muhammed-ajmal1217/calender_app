import 'package:calenderapp/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showAddEventDialog(BuildContext context, DateTime selectedDate) {
  final eventNameController = TextEditingController();
  DateTime startTime = selectedDate;
  DateTime endTime = selectedDate.add(const Duration(hours: 1));
  String repeatOption = 'Daily';
  String formattedStartTime = formatDateTime(startTime);
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add New Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: eventNameController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                final selectedStartTime = await selectDateTime(context, startTime);
                if (selectedStartTime != null) {
                  setState(() {
                    startTime = selectedStartTime;
                    formattedStartTime = formatDateTime(startTime);
                  });
                }
              },
              child: const Text('Select Time'),
            ),
            const SizedBox(height: 10,),
            Text(formattedStartTime,style: const TextStyle(fontWeight: FontWeight.w700),),
            const SizedBox(height: 10,),
            DropdownButton<String>(
              value: repeatOption,
              onChanged: (String? newValue) {
                setState(() {
                  repeatOption = newValue!;
                });
              },
              items: <String>['Daily', 'Weekly', 'Bi-Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (eventNameController.text.isNotEmpty) {
                final provider = Provider.of<HomeController>(context, listen: false);
                provider.addEvent(
                    eventNameController.text, startTime, endTime, repeatOption);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }
    Future<DateTime> selectDateTime(
      BuildContext context, DateTime initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
          pickedTime!.hour, pickedTime.minute);
    }
    return initialDate;
  }