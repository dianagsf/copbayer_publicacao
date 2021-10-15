import 'package:flutter/material.dart';

class ManutencaoPage extends StatefulWidget {
  @override
  _ManutencaoPageState createState() => _ManutencaoPageState();
}

class _ManutencaoPageState extends State<ManutencaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 92, 204, 252),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/manutencaoAPP.jpg",
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Estamos em manutenção. Voltaremos em breve.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
