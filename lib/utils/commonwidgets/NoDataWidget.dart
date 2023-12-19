import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String message;

  const NoDataWidget({Key? key, this.message = "No data available"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      color: Colors.grey[200], // Customize the background color as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_empty,
            color: Colors.grey,
            size: 40.0,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No Data',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
