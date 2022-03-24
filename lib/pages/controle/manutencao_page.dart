import 'package:copbayer_app/utils/responsive.dart';
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
      body: Responsive(
        mobile: buildManutencaoMobile(),
        tablet: buildManutencaoMobile(),
        desktop: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "images/manutencaoAPP.jpg",
                    fit: BoxFit.scaleDown,
                    width: 600,
                    height: 600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildManutencaoMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            "images/manutencaoAPP.jpg",
            fit: BoxFit.scaleDown,
          ),
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
    );
  }
}
