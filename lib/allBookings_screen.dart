import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllBookingsScreen extends StatefulWidget {
  @override
  _AllBookingsScreenState createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  List<String> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBookings = prefs.getStringList('bookings') ?? [];

    setState(() {
      bookings = savedBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Bookings')),
      body: bookings.isEmpty
          ? Center(child: Text('No bookings yet'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text('Booking ${index + 1}'),
                  subtitle: Text(booking),
                );
              },
            ),
    );
  }
}
