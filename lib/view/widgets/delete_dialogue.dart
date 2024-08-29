
import 'package:calenderapp/controller/home_controller.dart';
import 'package:flutter/material.dart';

void showConfirmDeleteDialog(BuildContext context, HomeController provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete all events?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.deleteAllEvents();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }