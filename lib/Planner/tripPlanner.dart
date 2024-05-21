import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TripPlanner extends StatefulWidget {
  const TripPlanner({super.key});

  @override
  State<TripPlanner> createState() => _TripPlannerState();
}

class _TripPlannerState extends State<TripPlanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'OUR DEVELOPER IS ON VACATION :(',
                style: TextStyle(
                  color: Color.fromRGBO(24, 22, 106, 1),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              // Text
              Lottie.asset('assets/animationVacation.json', height: 300, width: 300),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'This feature will be available as soon as he gets back. We guarantee you that!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
