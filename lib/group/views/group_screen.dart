import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synhub/group/bloc/group/group_event.dart';

import '../bloc/group/group_bloc.dart';
import '../bloc/group/group_state.dart';
import '../models/group.dart';
import '../services/group_service.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(groupService: GroupService())
        ..add(LoadMemberGroupEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Group'),
        ),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MemberGroupLoaded) {
              return _buildGroupContent(state.group);
            } else if (state is GroupError) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('No hay datos'));
          },
        ),
      ),
    );
  }

  Widget _buildGroupContent(Group group) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grupo: ${group.name}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Código del grupo: ${group.code}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text(
            'Descripción: ${group.description}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}