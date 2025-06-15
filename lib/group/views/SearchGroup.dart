import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group/group_bloc.dart';
import '../bloc/group/group_event.dart';
import '../bloc/group/group_state.dart';
import '../models/group.dart';
import '../services/group_service.dart';

class SearchGroup extends StatefulWidget {
  const SearchGroup({super.key});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(groupService: GroupService()),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Únete a un grupo',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Código del grupo',
                    hintText: 'Ingresa el código de 6 dígitos',
                    prefixIcon: const Icon(Icons.code, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un código';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocConsumer<GroupBloc, GroupState>(
                  listener: (context, state) {
                    if (state is GroupFound) {
                      _showGroupDialog(context, state.group);
                    } else if (state is GroupError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: state is GroupLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<GroupBloc>().add(
                            SearchGroupByCodeEvent(_codeController.text),
                          );
                        }
                      },
                      child: state is GroupLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Buscar grupo',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                if (_codeController.text.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Pide el código al administrador del grupo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGroupDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grupo Encontrado'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (group.imgUrl.isNotEmpty)
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(group.imgUrl),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Nombre: ${group.name}'),
              const SizedBox(height: 8),
              Text('Miembros: ${group.memberCount}'),
              const SizedBox(height: 8),
              Text('Descripción: ${group.description}'),
              const SizedBox(height: 8),
              Text('Código: ${group.code}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
            ),
            onPressed: () {
              // Lógica para unirse al grupo
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Te has unido a ${group.name}'),
                  backgroundColor: Colors.green,
                ),
              );
              // Aquí podrías navegar a la pantalla principal
            },
            child: const Text('Unirse', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}