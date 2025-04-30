import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantarium/core/config/app_config.dart';
import 'package:plantarium/features/garden_notes/presentation/screens/garden_notes_list_screen.dart';
import 'package:plantarium/core/services/garden_note.service.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:dio/dio.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms
  if (!kIsWeb) {
    // Initialize FFI loader
    sqfliteFfiInit();
    // Change the default factory for desktop
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize environment configuration
  final String envName = const String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  final env = Environment.values.firstWhere(
    (e) => e.name == envName,
    orElse: () => Environment.development,
  );

  AppConfig.init(env);

  // Run the app with provider
  runApp(const PlantariumApp());
}

class PlantariumApp extends StatelessWidget {
  const PlantariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Dio with base configuration
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.current.apiBaseUrl,
        connectTimeout: AppConfig.current.timeoutDuration,
        receiveTimeout: AppConfig.current.timeoutDuration,
      ),
    );

    // Initialize GardenNoteService
    final gardenNoteService = GardenNoteService(
      dio: dio,
      baseUrl: AppConfig.current.apiBaseUrl,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GardenNotesProvider(gardenNoteService),
        ),
      ],
      child: MaterialApp(
        title: 'Plantarium',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: GardenNotesListScreen(gardenNoteService: gardenNoteService),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Plantarium',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a purple toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Plantarium Home'),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      // TRY THIS: Try changing the color here to a specific color (to
      // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      // change color while the other colors stay the same.
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),
    ),
    body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        //
        // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
        // action in the IDE, or press "p" in the console), to see the
        // wireframe for each widget.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
  );
}
