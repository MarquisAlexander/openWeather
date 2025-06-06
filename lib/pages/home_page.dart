import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Início')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Consultar previsão do tempo'),
          onPressed: () {
            Navigator.pushNamed(context, '/search_page');
          },
        ),
      ),
    );
  }
}
