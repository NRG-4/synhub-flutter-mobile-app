import 'package:flutter/material.dart';

class SearchGroup extends StatefulWidget {
  const SearchGroup({super.key});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {

  final TextEditingController codeGroupController = TextEditingController();

  @override
  void dispose() {
    codeGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              const Text(
                'Únete a un grupo',
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: codeGroupController,
                decoration: InputDecoration(
                  labelText: 'Código del grupo',
                  hintText: 'Código del grupo',
                  prefixIcon: Icon(Icons.abc, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () {
                  // Aquí puedes agregar la lógica para buscar el grupo
                },
                child: const Text(
                  'Buscar grupo',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
