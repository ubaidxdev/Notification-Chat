import 'package:notification_chat/Views/home/account_screen.dart';
import 'package:notification_chat/Views/home/home_screen.dart';
import 'package:notification_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetsList = [
    const HomeScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetsList[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: constantSheet.colors.black,
        selectedItemColor: constantSheet.colors.primary,
        items: [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.home,
                size: 24.sp,
              )),
          BottomNavigationBarItem(
              label: "Account",
              icon: Icon(
                Icons.person,
                size: 24.sp,
              ))
        ],
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
