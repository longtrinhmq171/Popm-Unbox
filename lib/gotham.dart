import 'dart:math';
import 'package:flutter/material.dart';

class GothamPage extends StatelessWidget {
  final List<Map<String, dynamic>> unboxedCharacters;
  final Function(List<Map<String, dynamic>>) updateCharacters;

  const GothamPage({super.key, required this.unboxedCharacters, required this.updateCharacters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DC Gotham City',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono',)),
        backgroundColor: Colors.black),
      body: Center(
        child: CharacterSelection(unboxedCharacters: unboxedCharacters, updateCharacters: updateCharacters),
      ),
    );
  }
}

class CharacterSelection extends StatefulWidget {
  final List<Map<String, dynamic>> unboxedCharacters;
  final Function(List<Map<String, dynamic>>) updateCharacters;

  const CharacterSelection({super.key, required this.unboxedCharacters, required this.updateCharacters});

  @override
  _CharacterSelectionState createState() => _CharacterSelectionState();
}

class _CharacterSelectionState extends State<CharacterSelection> {
  final List<Map<String, dynamic>> _characters = [
    {'name': 'Harley Queen', 'image': 'assets/batman/b1.webp', 'probability': 0.1},
    {'name': 'Batman Pre52', 'image': 'assets/batman/b2.webp', 'probability': 0.08},
    {'name': 'Batman Crime Alley', 'image': 'assets/batman/b3.webp', 'probability': 0.08},
    {'name': 'Batman 1966', 'image': 'assets/batman/b4.webp', 'probability': 0.1},
    {'name': 'Catwoman', 'image': 'assets/batman/b5.webp', 'probability': 0.1},
    {'name': 'Batgirl', 'image': 'assets/batman/b6.webp', 'probability': 0.1},
    {'name': 'Riddler', 'image': 'assets/batman/b7.webp', 'probability': 0.1},
    {'name': 'The Joker - New Bat', 'image': 'assets/batman/b8.webp', 'probability': 0.1},
    {'name': 'The Joker - DC Rebirth', 'image': 'assets/batman/b9.webp', 'probability': 0.1},
    {'name': 'Poison Ivy', 'image': 'assets/batman/b10.webp', 'probability': 0.1},
    {'name': 'Red Robin', 'image': 'assets/batman/b11.webp', 'probability': 0.1},
    {'name': 'Red Hood', 'image': 'assets/batman/b12.webp', 'probability': 0.1},
    {'name': 'Secret', 'image': 'assets/batman/b13.webp', 'probability': 0.01},
  ];

  String _randomCharacter() {
    final random = Random();
    double cumulativeProbability = 0.0;
    final randomValue = random.nextDouble();

    for (final character in _characters) {
      cumulativeProbability += character['probability'];
      if (randomValue <= cumulativeProbability) {
        return character['name'];
      }
    }
    return _characters.last['name'];
  }

  void _showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to choose this box?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Execute the confirm callback
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _onBoxTap(BuildContext context) {
    final selectedCharacterName = _randomCharacter();
    final selectedCharacter = _characters.firstWhere((character) => character['name'] == selectedCharacterName);
    setState(() {
      widget.unboxedCharacters.add(selectedCharacter);
    });
    widget.updateCharacters(widget.unboxedCharacters);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CharacterScreen(
          character: _characters.firstWhere((character) => character['name'] == selectedCharacterName),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Please choose one box to unbox',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0, // Square items
            ),
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => _showConfirmationDialog(context, () => _onBoxTap(context)),
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/batman/bbox.webp'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity, // Set to 100% width
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0), // Add border
          ),
          child: const Text(
            "Your Prizes. Zoom in to see clearer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        InteractiveViewer(
          child: Image.asset('assets/batman/bchoices.png', height: 150),
        ),
      ],
    );
  }
}

class CharacterScreen extends StatelessWidget {
  final Map<String, dynamic> character;

  const CharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              character['image'],
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            Text(
              character['name'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              textAlign: TextAlign.center,
              'Congratulations! You have unlocked this character!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}