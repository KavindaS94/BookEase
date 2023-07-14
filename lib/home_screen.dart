import 'package:flutter/material.dart';
import 'ground_model.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ground {
  final String name;
  final String location;
  final double pricePerHour;

  Ground({
    required this.name,
    required this.location,
    required this.pricePerHour,
  });
}

class HomeScreen extends StatelessWidget {
  final List<Ground> grounds = [
    Ground(name: 'Central Park Soccer Field', location: 'New York City, USA', pricePerHour: 10),
    Ground(name: 'Wembley Stadium', location: 'London, United Kingdom', pricePerHour: 15),
    Ground(name: 'Maracanã Stadium', location: 'Rio de Janeiro, Brazil', pricePerHour: 12),
    Ground(name: 'Camp Nou', location: 'Barcelona, Spain', pricePerHour: 20),
    Ground(name: 'Sydney Cricket Ground', location: 'Sydney, Australia', pricePerHour: 18),
    Ground(name: 'Tokyo Dome', location: 'Tokyo, Japan', pricePerHour: 14)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available courts')),
      body: ListView.builder(
        itemCount: grounds.length,
        itemBuilder: (context, index) {
          final ground = grounds[index];
          return Card(
            child: ListTile(
              title: Text(ground.name),
              subtitle: Text('Location: ${ground.location}'),
              trailing: Text('\$${ground.pricePerHour.toString()} / hour'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TimeOfDay selectedStartTime = TimeOfDay.now();
                    TimeOfDay selectedEndTime = TimeOfDay.now();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Booking'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Ground: ${ground.name}'),
                              SizedBox(height: 8.0),
                              Text('Location: ${ground.location}'),
                              SizedBox(height: 8.0),
                              Text(
                                  'Per-Hour Charges: \$${ground.pricePerHour.toString()}'),
                              SizedBox(height: 16.0),
                              Text('Select Start Time:'),
                              ElevatedButton(
                                child: Text(selectedStartTime.format(context)),
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: selectedStartTime,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      selectedStartTime = selectedTime;
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 8.0),
                              Text('Select End Time:'),
                              ElevatedButton(
                                child: Text(selectedEndTime.format(context)),
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: selectedEndTime,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      selectedEndTime = selectedTime;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text('Book'),
                              onPressed: () async {
                                final duration = _calculateDuration(
                                    selectedStartTime, selectedEndTime);
                                final hours = duration.inHours +
                                    (duration.inMinutes % 60 > 0 ? 1 : 0);
                                final totalCharge = ground.pricePerHour * hours;

                                await saveBookingData(ground, selectedStartTime,
                                    selectedEndTime, totalCharge);
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text('View All Bookings'),
                              onPressed: () async {
                                final duration = _calculateDuration(
                                    selectedStartTime, selectedEndTime);
                                final hours = duration.inHours +
                                    (duration.inMinutes % 60 > 0 ? 1 : 0);
                                final totalCharge = ground.pricePerHour * hours;

                                await saveBookingData(ground, selectedStartTime,
                                    selectedEndTime, totalCharge);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/allBookings');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Duration _calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    return endDateTime.difference(startDateTime);
  }

  Future<void> saveBookingData(Ground ground, TimeOfDay startTime,
      TimeOfDay endTime, double totalCharge) async {
    final prefs = await SharedPreferences.getInstance();

    final booking = {
      'groundName': ground.name,
      'location': ground.location,
      'startTime': startTime,
      'endTime': endTime,
      'totalCharge': totalCharge.toString(),
    };

    List<String>? savedBookings = prefs.getStringList('bookings');

    if (savedBookings == null) {
      savedBookings = [booking.toString()];
    } else {
      savedBookings.add(booking.toString());
    }

    await prefs.setStringList('bookings', savedBookings);
  }
}
