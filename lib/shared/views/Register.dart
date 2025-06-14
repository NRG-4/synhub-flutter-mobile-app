import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController urlPfpController = TextEditingController();
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    userController.dispose();
    mailController.dispose();
    urlPfpController.dispose();
    pass1Controller.dispose();
    pass2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 60,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Nombre',
                        prefixIcon: Icon(Icons.abc, color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFFF3F3F3),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: surnameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                        hintText: 'Apellido',
                        prefixIcon: Icon(Icons.abc, color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFFF3F3F3),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  hintText: 'Usuario',
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: mailController,
                decoration: InputDecoration(
                  labelText: 'Mail',
                  hintText: 'Mail',
                  prefixIcon: Icon(Icons.mail, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: urlPfpController,
                decoration: InputDecoration(
                  labelText: 'Url Pfp',
                  hintText: 'Url Pfp',
                  prefixIcon: Icon(Icons.link, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: pass1Controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: pass2Controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFFF3F3F3),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Aquí puedes acceder a los valores con nameController.text, etc.
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
