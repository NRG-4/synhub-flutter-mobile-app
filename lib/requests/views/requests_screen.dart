import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
import '../models/request.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(LoadMemberRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Mis solicitudes',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: const Center(
        child: Text('Placeholder'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the floating action button
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
