import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RossiApp());
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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 185, 244, 220)),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class RossiAppState extends ChangeNotifier {

  // check_box_blank_outline -> check_box , when toggled() 
  // Map submission = {
  //   "walkers" : [],
  //   "time" : "",
  //   };

  String otherWalker = "_";
  Map<String, bool> walkersToggle = {
    "MB": false,
    "B": false,
    "_": false,
  };
  List<bool> timeToggle = [false, false, false, false];

  void toggleWalker(walker) {

    List<String> walkers = walkersToggle.keys.toList();

    if (walkers.contains(walker)) {
      walkers.remove(walker);
    } else {
      walkers.add(walker);
    }
    print("walkers is now: $walkers");
    walkersToggle[walker] = !walkersToggle[walker]!;
    print("walkersToggle is now $walkersToggle");
    notifyListeners();
  }

  void toggleTime(time) {
    print("time toggled");
    switch (time) {
      case "A":
        print("toggled time of: A");
      case "L":
        print("toggled time of: L");
      case "D":
        print("toggled time of: D");
      case "E":
        print("toggled time of: E");
      case "Now":
        print("toggled time of: Now");
      default:
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
  const HomePage({super.key});

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
                  destinations: const [
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
                        label: Text('Edit Record')
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

  SubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<RossiAppState>();
    
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        title: const Text('Submit a Walk'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      icon: appState.walkersToggle["MB"]! 
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleWalker("B");},
                      label: const Text('B'),
                      icon: appState.walkersToggle["B"]! 
                        ? const Icon(Icons.check_box)
                        : const Icon(Icons.check_box_outline_blank),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 180,
                      child: ElevatedButton(
                        onPressed: () {appState.toggleWalker("_");},
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: appState.walkersToggle["_"]! 
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                            labelText: 'Fran?',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: Colors.cyan),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],            
            ),
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
                      icon: const Icon(Icons.check_box_outline_blank)
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("L");},
                      label: const Text('L'),
                      icon: const Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("D");},
                      label: const Text('D'),
                      icon: const Icon(Icons.check_box_outline_blank)
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("E");},
                      label: const Text('E'),
                      icon: const Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {appState.toggleTime("Now");},
                      label: const Text("Now"),
                      icon: const Icon(Icons.check_box_outline_blank)
                    ),
                  ],
                ),
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
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

//TODO: create time button wrapper for factory
// class WalkButton {

//   final String time;

//   return 
//     ElevatedButton.icon(
//     onPressed: () {appState.toggleTime(time);},
//     label: const Text("Now"),
//     icon: const Icon(Icons.check_box_outline_blank)
//   )
// }