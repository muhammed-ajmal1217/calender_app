import 'package:calenderapp/view/widgets/add_dialogue.dart';
import 'package:calenderapp/view/widgets/delete_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:calenderapp/controller/home_controller.dart';
import 'package:calenderapp/controller/event_data_resources.dart';
import 'package:calenderapp/model/event_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeController>(context, listen: false);
      provider.loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Calendar App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final provider = Provider.of<HomeController>(context, listen: false);
              showConfirmDeleteDialog(context, provider);
            },
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, provider, child) {
          final size = MediaQuery.of(context).size;
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfCalendar(
                        cellBorderColor: Colors.black,
                        todayHighlightColor: const Color.fromARGB(255, 54, 142, 155),
                        todayTextStyle: const TextStyle(color: Colors.white),
                        appointmentTextStyle: const TextStyle(color: Colors.white),
                        weekNumberStyle: const WeekNumberStyle(
                            textStyle: TextStyle(color: Colors.white)),
                        viewHeaderStyle: const ViewHeaderStyle(
                            backgroundColor: Color.fromARGB(255, 236, 234, 234),
                            dateTextStyle: TextStyle(color: Colors.green)),
                        blackoutDatesTextStyle: const TextStyle(
                            color: Colors.white, backgroundColor: Colors.green),
                        headerStyle: const CalendarHeaderStyle(
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(color: Colors.white)),
                        showDatePickerButton: true,
                        showCurrentTimeIndicator: true,
                        allowDragAndDrop: true,
                        view: CalendarView.month,
                        dataSource: EventDataResource(provider.events),
                        onTap: (calendarTapDetails) {
                          if (calendarTapDetails.targetElement ==
                              CalendarElement.calendarCell) {
                            showAddEventDialog(
                                context, calendarTapDetails.date!);
                          }
                        },
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedEvents(provider.events).length,
                    itemBuilder: (context, index) {
                      final event = groupedEvents(provider.events)[index];
                      final Map<String, Color> repeatOptionColors = {
                        'Daily': Colors.blue,
                        'Weekly': Colors.orange,
                        'Bi-Weekly': Colors.pink,
                        'Monthly': Colors.red,
                      };
                      final Color backgroundColor =
                          repeatOptionColors[event.repeatOption] ?? Colors.grey;

                      return ListTile(
                        title: Text(event.eventName),
                        subtitle: Text(formatDateTime(event.from)),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              event.repeatOption,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<EventModel> groupedEvents(List<EventModel> events) {
    final Map<String, EventModel> grouped = {};

    for (var event in events) {
      if (!grouped.containsKey(event.eventName)) {
        grouped[event.eventName] = EventModel(
          eventName: event.eventName,
          from: event.from,
          to: event.to,
          background: event.background,
          isAllDay: event.isAllDay,
          repeatOption: event.repeatOption,
        );
      }
    }

    return grouped.values.toList();
  }
}

