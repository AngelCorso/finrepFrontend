import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/mostrar_balance_general.dart';
import 'subirArchivo.dart';
import 'mostrar_balance_general.dart';
import 'HomePage.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          ElevatedButton(
            child: const Text('Subir archivo'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubirArchivo()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Ver balance general'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MBalanceGeneral()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ]),
      ),
    );
  }
}



//Seleccionar archivo
