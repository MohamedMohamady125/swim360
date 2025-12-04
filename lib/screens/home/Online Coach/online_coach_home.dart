import 'package:flutter/material.dart';
import 'package:swim360/screens/home/Online Coach/my_programs.dart';
import 'package:swim360/screens/home/Online Coach/my_clients.dart';
import 'package:swim360/screens/home/Online Coach/create_program.dart';

class OnlineCoachHome extends StatefulWidget {
    const OnlineCoachHome({Key? key}) : super(key: key);

    @override
    State<OnlineCoachHome> createState() => _OnlineCoachHomeState();
}

class _OnlineCoachHomeState extends State<OnlineCoachHome> {
    int _selectedIndex = 0;

    final List<Widget> _pages = const [
        MyProgramsScreen(),
        MyClientsScreen(),
    ];

    void _onTapNav(int index) {
        setState(() => _selectedIndex = index);
    }

    void _openCreateProgram() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateProgramScreen()));
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Online Coach'),
                actions: [
                    IconButton(onPressed: _openCreateProgram, icon: const Icon(Icons.add)),
                ],
            ),
            body: IndexedStack(index: _selectedIndex, children: _pages),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: _openCreateProgram,
                icon: const Icon(Icons.add),
                label: const Text('New Program'),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onTapNav,
                items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Programs'),
                    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
                ],
            ),
        );
    }
}