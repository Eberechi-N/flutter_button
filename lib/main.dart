import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final theme = Theme.of(context);
    final gradImage = 'assets/grad.png';
    final style = theme.textTheme.displayMedium!.copyWith(
      color: Colors.black,
    );

    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    }else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Graduation Quote Generator:',
              style: style,
              textAlign: TextAlign.center,
              //https://stackoverflow.com/questions/71356226/textwidthbasis-longestline-alternative-for-autosizetext
              textWidthBasis: TextWidthBasis.longestLine,
              ),
            Image.asset(
              gradImage,
              height: 400,
              fit: BoxFit.cover,
            ),
            BigCard(pair: pair),
        
          Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text("Like"),
              )
            ],
          )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return 
    Container(
      width: 300,
      height: 150,
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Let's go ${pair.asLowerCase}!" ,
            style: style,
            semanticsLabel: "Let's go ${pair.first} ${pair.second}!",
          ),
        ),
      ),
    );
  }

  
}