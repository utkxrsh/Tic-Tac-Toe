import 'package:flutter/material.dart';

// Main function
void main() {
  runApp(MyApp());
}

// MyApp class
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// MyHomePage class
class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application.
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// _MyHomePageState class
class _MyHomePageState extends State<MyHomePage> {
  // A value notifier to store the current theme mode
  ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  List<String> _cells = List.filled(9, '');

  bool _isX = true;

  String _message = '';

  void _checkWinner() {
    List<List<int>> _winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (List<int> combination in _winningCombinations) {
      if (_cells[combination[0]] == _cells[combination[1]] &&
          _cells[combination[1]] == _cells[combination[2]] &&
          _cells[combination[0]] != '') {
        setState(() {
          _message = '${_cells[combination[0]]} wins!';
        });

        break;
      }
    }

    if (_message == '' && !_cells.contains('')) {
      setState(() {
        _message = 'It\'s a draw!';
      });
    }
  }

  void _resetGame() {
    setState(() {
      // Clearing the cells list
      _cells = List.filled(9, '');
      // Resetting the turn to X
      _isX = true;
      // Clearing the message
      _message = '';
    });
  }

  // A method to handle the tap on a cell
  void _handleTap(int index) {
    // Checking if the cell is empty and there is no winner or draw
    if (_cells[index] == '' && _message == '') {
      setState(() {
        // Setting the cell value to X or O depending on the turn
        _cells[index] = _isX ? 'X' : 'O';
        // Switching the turn to the other player
        _isX = !_isX;
      });
      // Checking if there is a winner or a draw after each tap
      _checkWinner();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeMode,
        builder: (context, themeMode, child) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Tic Tac Toe'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () {
                      // Toggling the theme mode between light and dark
                      _themeMode.value = themeMode == ThemeMode
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Showing the message if there is a winner or a draw
                    if (_message != '')
                      Text(
                        _message,
                        style: const TextStyle(fontSize: 24),
                      ),
                    // Showing a grid view of 3x3 cells
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Handling the tap on a cell
                            _handleTap(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                _cells[index],
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Showing a reset button
                    ElevatedButton(
                      onPressed: () {
                        // Resetting the game state
                        _resetGame();
                      },
                      child: const Text('Reset'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
