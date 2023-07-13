import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  // initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  Map<String, bool> timesToggle = {
    "A": false, 
    "L": false, 
    "D": false, 
    "E": false,
    "Now": false
  };

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
    List<String> times = timesToggle.keys.toList();

    if (times.contains(time)) {
      times.remove(time);
    } else {
      times.add(time);
    }
    print("times is now: $times");
    timesToggle[time] = !timesToggle[time]!;
    print("timesToggle is now $timesToggle");
    notifyListeners();
  }

  void _submitWalk() {
    print("submitting walk");
  }
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

    // make expected walkers list & buttons
    List<String> defaultWalkers = ["MB", "B", "_"];
    late List<Widget> walkerButtons = defaultWalkers.map(
      (String text) => WalkerButton(walkerLabel:text)).toList();
    // and the walk times list & buttons 
    List<String> defaultTimes = ["A", "L", "D", "E", "Now"];
    late List<Widget> timeButtons = defaultTimes.map(
      (String text) => TimeButton(timeLabel:text)).toList();

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
                    walkerButtons[0],
                    const SizedBox(width: 10),
                    walkerButtons[1],
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
                    timeButtons[0],
                    const SizedBox(width: 10),
                    timeButtons[1],
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeButtons[2],
                    const SizedBox(width: 10),
                    timeButtons[3],
                  ],
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeButtons[4],
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

class WalkerButton extends StatelessWidget{

  final String walkerLabel;

  const WalkerButton({Key? key, required this.walkerLabel}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final appState = context.read<RossiAppState>();
        appState.toggleWalker(walkerLabel);
      },
      label: Text(walkerLabel),
      icon:
        context.read<RossiAppState>().walkersToggle[walkerLabel]! 
        ? const Icon(Icons.check_box)
        : const Icon(Icons.check_box_outline_blank),
    );
  }
}

class TimeButton extends StatelessWidget{

  final String timeLabel;

  const TimeButton({Key? key, required this.timeLabel}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final appState = context.read<RossiAppState>();
        appState.toggleTime(timeLabel);
      },
      label: Text(timeLabel),
      icon:
        context.read<RossiAppState>().timesToggle[timeLabel]! 
        ? const Icon(Icons.check_box)
        : const Icon(Icons.check_box_outline_blank),
    );
  }
}