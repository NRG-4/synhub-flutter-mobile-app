import 'package:flutter/material.dart';
import 'package:synhub/shared/views/Login.dart';
import '../../group/views/group.dart';
import '../../statistics/views/statistics.dart';
import '../../tasks/views/tasks.dart';
import '../../validations/views/request_&_validations.dart';
import '../../shared/client/api_client.dart';

const List<Map<String, dynamic>> drawerOptions = [
  {'label': 'Grupo', 'icon': Icons.groups, 'route': 'Group'},
  {'label': 'Solicitudes y validaciones', 'icon': Icons.mail_outline, 'route': 'validations'},
  {'label': 'Tareas', 'icon': Icons.assignment_outlined, 'route': 'Tasks'},
  {'label': 'Mi desempeño', 'icon': Icons.area_chart, 'route': 'AnalyticsAndReports'},
  {'label': 'Cerrar sesión', 'icon': Icons.logout, 'route': 'Login'},
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SynHub'),
      ),
      drawerEnableOpenDragGesture: true,
      drawer: _CustomDrawer(
        name: 'Nombre',
        surname: 'Apellido',
        imgUrl: '',
        onNavigate: (route) {
          Navigator.pop(context);
          if (route == 'Group') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GroupScreen()));
          } else if (route == 'Tasks') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TasksScreen()));
          } else if (route == 'Statistics') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()));
          } else if (route == 'RequestsAndValidations') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestAndValidationsScreen()));
          } else if (route == 'Login') {
            ApiClient.resetToken();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
          }
        },
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Text('Bienvenido a SynHub'),
        ),
      ),
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  final String name;
  final String surname;
  final String imgUrl;
  final Function(String) onNavigate;

  const _CustomDrawer({
    required this.name,
    required this.surname,
    required this.imgUrl,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    const double gap = 15.0;
    return Drawer(
      child: Container(
        color: const Color(0xFF1A4E85),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 60),
            Center(
              child: Text(
                '$name $surname',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: gap),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: imgUrl.isNotEmpty
                      ? Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 80, color: Colors.white);
                          },
                        )
                      : const Icon(Icons.person, size: 80, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: gap),
            const Divider(color: Colors.white),
            const SizedBox(height: gap),
            _buildDrawerItem(
              icon: Icons.groups,
              label: 'Grupo',
              onTap: () => onNavigate('Group'),
            ),
            _buildDrawerItem(
              icon: Icons.assignment_outlined,
              label: 'Tareas',
              onTap: () => onNavigate('Tasks'),
            ),
            _buildDrawerItem(
              icon: Icons.bar_chart,
              label: 'Mi desempeño',
              onTap: () => onNavigate('Statistics'),
            ),
            _buildDrawerItem(
              icon: Icons.fact_check,
              label: 'Solicitudes y Validaciones',
              onTap: () => onNavigate('RequestsAndValidations'),
            ),
            const SizedBox(height: gap),
            const Divider(color: Colors.white),
            const SizedBox(height: gap),
            _buildDrawerItem(
              icon: Icons.logout,
              label: 'Cerrar Sesión',
              onTap: () => onNavigate('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(fontSize: 17, color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
    );
  }
}
