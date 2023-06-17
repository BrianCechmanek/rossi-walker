import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(RossiApp());
}

class RossiApp extends StatelessWidget {
  const RossiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RossiAppState(),
      child: MaterialApp(
        title: 'rossi walker app',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(89, 19, 192, 189)),
        ),
        home: HomePage(),
      ),
    );
  }
}

class RossiAppState extends ChangeNotifier {
  var walkers = "None";
  var walk_time_start = "None";

  // var currentPair = WordPair.random();
  // var favourites = <WordPair>[];

  // void getNext() {
  //   currentPair = WordPair.random();
  //   notifyListeners();
  // }

  void toggleWalker(walker) {
    if (walker == "MB") {
      print("toggled MB");
    } else if (walker == "B") {
      print("toggled B");
    } else {
      print("toggled {$walker}");
    }
    notifyListeners();
  }

  void toggleTime(time) {
    print("time toggled");
    if (time == "A") {
      print("toggled time of: A");
    } else if (time == "L") {
      print("toggled time of: L");
    } else if (time == "D") {
      print("toggled time of: D");
    } else if (time == "E") {
      print("toggled time of: E");
    } else {
      throw UnimplementedError('No walking time for for $time');
    }
    notifyListeners();
  }

  void _submitWalk() {
    print("submitting walk");
  }

  // void toggleFavourite() {
  //   if (favourites.contains(currentPair)) {
  //     favourites.remove(currentPair);
  //   } else {
  //     favourites.add(currentPair);
  //   }
  //   notifyListeners();
  // }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override 
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = SubmitPage();
        break;
      case 1: 
        page = const Placeholder(); //calendar();
        break;
      case 2:
        page = const Placeholder(); //stats
        break;
      case 3:
        page = const Placeholder(); //edit
        break;
      default: 
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.directions_walk ),
                      label: Text('Submit Walk'),
                    ),
                    NavigationRailDestination(
                        icon: Icon(Icons.calendar_month_outlined), 
                        label: Text('Calendar'),
                    ),
                    NavigationRailDestination(
                        icon: Icon(Icons.add_chart_outlined),
                        label: Text('Stats'),
                    ),
                    NavigationRailDestination(
                        icon: Icon(Icons.mode_edit_outline_outlined), 
                        label: Text('Edit')
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {selectedIndex = value;});
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      });
  }
}

class SubmitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<RossiAppState>();

    // IconData icon;
    // if (appState.favourites.contains(pair)) {
    //   icon = Icons.favorite;
    // } else {
    //   icon = Icons.favorite_border;
    // }

    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        title: const Text('Walk Detail'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Time (start):', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)
            ),
            const SizedBox(height: 10),
            Column(
              children:[
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("A");},
                      label: const Text('A'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("L");},
                      label: const Text('L'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("D");},
                      label: const Text('D'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("E");},
                      label: const Text('E'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Walker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)
            ),
            Column(
              children:[
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleWalker("MB");},
                      label: const Text('MB'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleWalker("B");},
                      label: const Text('B'),
                      icon: Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(width: 180,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Fran?',
                      filled: true,
                      fillColor: Colors.white10,
                    ),
                  ),
                )
              ],            
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("submitting walk");
        },
        label: const Text('Submit'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.cyanAccent[400],
      ),
    );
  }
}