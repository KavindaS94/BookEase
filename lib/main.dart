import 'package:flutter/material.dart';
import 'package:ground_booking_app/allBookings_screen.dart';
import 'package:ground_booking_app/home_screen.dart';
import 'package:ground_booking_app/login_screen.dart';
import 'package:ground_booking_app/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BookingApp());
}

class BookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/allBookings': (context) => AllBookingsScreen(),
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingScreen(),
    );
  }


class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ground Booking'),
      ),
      body: Center(
        child: Text('Welcome to the Ground Booking App!'),
      ),
    );
  }
}
