import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SortingHatApp());
}

class SortingHatApp extends StatelessWidget {
  const SortingHatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chapéu Seletor",
      theme: ThemeData(brightness: Brightness.dark, fontFamily: "Cinzel"),
      home: const SortingHatScreen(),
    );
  }
}

class SortingHatScreen extends StatefulWidget {
  const SortingHatScreen({super.key});

  @override
  State<SortingHatScreen> createState() => _SortingHatScreenState();
}

class _SortingHatScreenState extends State<SortingHatScreen> {

  final List<House> houses = [
  House(
    name: "Grifinória",
    imagePath: "assets/images/gryffindor_1.png",
    color: Colors.red,
  ),
  House(
    name: "Sonserina",
    imagePath: "assets/images/slytherin_1.png",
    color: Colors.green,
  ),
  House(
    name: "Corvinal",
    imagePath: "assets/images/ravenclaw_1.png",
    color: Colors.blue,
  ),
  House(
    name: "Lufa-Lufa",
    imagePath: "assets/images/hufflepuff_1.png",
    color: Colors.amber,
  ),
];

House? selectedHouse;
SortingState state = SortingState.idle;

Future<void> sortHouse() async {
  if (state != SortingState.idle) return;

  setState(() {
    state = SortingState.sorting;
    selectedHouse = null;
  });

  await Future.delayed(const Duration(seconds: 3));

  final random = Random();
  final house = houses[random.nextInt(houses.length)];

  setState(() {
    selectedHouse = house;
    state = SortingState.result;
  });

  await Future.delayed(const Duration(seconds: 5));

  setState(() {
    selectedHouse = null;
    state = SortingState.idle;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0c0c1e),
      body: SafeArea(
  child: SingleChildScrollView(
    child: Column(
      children: [
        const HogwartsHeader(),

        SizedBox(
          height: 400,
          child: HouseArea(
            house: selectedHouse,
            state: state,
          ),
        ),

        SortingButton(
          onPressed: sortHouse,
          state: state,
        ),

        const SizedBox(height: 40),
      ],
    ),
  ),
),
    );
  }
}

class HogwartsLogo extends StatelessWidget {
  const HogwartsLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "HarryPoter",
      style: TextStyle(fontSize: 96, fontFamily: "HarryPotter"),
    );
  }
}

class HogwartsHeader extends StatelessWidget {
  const HogwartsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 20),
        HogwartsLogo(),
        Text(
          "e o chapéu seletor",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "CinzelDecorative",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

enum SortingState { idle, sorting, result }

class SortingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final SortingState state;

  const SortingButton({
    super.key,
    required this.onPressed,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    switch (state) {
      case SortingState.idle:
        text = "Descobrir minha casa";
        break;

      case SortingState.sorting:
        text = "Pensando";
        break;

      case SortingState.result:
        text = "Sua casa foi escolhida";
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5D4037),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: state == SortingState.idle ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/icone_chapeu_seletor.png",
              height: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class House {
  final String name;
  final String imagePath;
  final Color color;
  House({required this.name, required this.imagePath, required this.color});
}

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SortingHatView extends StatelessWidget {
  const SortingHatView({super.key, required this.state});
  final SortingState state;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset("assets/images/sorting_hat_sticker.png", height: 325),
            if (state == SortingState.sorting)
              const Positioned(
                top: 20,
                child: SpeechBubble(text: "Hmm... difícil..."),
              ),
          ],
        ),
      ),
    );
  }
}

class HouseView extends StatelessWidget {
  const HouseView({super.key, required this.house});
  final House? house;
  @override
  Widget build(BuildContext context) {
    return Center(
  child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: house?.color.withOpacity(0.6) ?? Colors.transparent,
          blurRadius: 40,
          spreadRadius: 10,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (house == null)
          Image.asset('assets/images/hogwarts_2.png', height: 200)
        else ...[
          Image.asset(house!.imagePath, height: 200),
          const SizedBox(height: 20),
          Text(
            house!.name,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: house!.color,
            ),
          ),
        ],
      ],
    ),
  ),
);
  }
}

class HouseArea extends StatelessWidget {
  final House? house;
  final SortingState state;

  const HouseArea({
    super.key,
    required this.house,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state == SortingState.idle || state == SortingState.sorting) {
      return SortingHatView(state: state);
    }

    return HouseView(house: house);
  }
}


