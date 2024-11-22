import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

// ignore: must_be_immutable
class BotttomNavation extends StatefulWidget {
  final thispage = PageController();
  int selected = 0;
  BotttomNavation(
    thispage,
    selected, {
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<BotttomNavation> createState() =>
      // ignore: no_logic_in_create_state
      _BotttomNavationState(thispage, selected);
}

class _BotttomNavationState extends State<BotttomNavation> {
  var thispage = PageController();
  int page;
  _BotttomNavationState(this.thispage, this.page);

  int currentIndex = 0;
  List label = ["Home", "Borrow", "Personal"];
  List<IconData> icon = [
    Boxicons.bx_home,
    Boxicons.bx_book,
    CupertinoIcons.person,
  ];

  int _selectedIndex = 0;
  // ignore: unused_field
  static TextStyle optionStyle =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10, spreadRadius: -1, color: Colors.black38)
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Boxicons.bx_book),
              label: 'Borrow',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Person',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
