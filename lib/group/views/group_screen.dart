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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              String title = 'Group';
              if (state is MemberGroupLoaded) {
                title = state.group.name;
              } else if (state is GroupLoading) {
                title = 'Cargando...';
              } else if (state is GroupError) {
                title = 'Error';
              }
              return AppBar(
                backgroundColor: Colors.white,
                title: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              );
            },
          ),
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
          Center(
            child: Card(
              color: Color(0xFF4A90E2),
              elevation: 5,
              child:
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text('#${group.code}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                )
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Card(
              color: Color(0xFF1A4E85),
              elevation: 5,
              child:
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(group.description,
                      style:
                      TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                    textAlign: TextAlign.justify,
                  ),
                )
            ),
          ),
          const SizedBox(height: 12),
          Text('Tus compañeros de equipo:',
              style:
              TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A4E85)
              )
          ),
          const SizedBox(height: 12),
          Card(
            color: Color(0xFFF5F5F5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                elevation: 5,
                  child: SizedBox(
                  height: 400, // Altura máxima para evitar desbordes
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: group.members.map((member) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(member.imgUrl),
                        ),
                        title: Text('${member.name} ${member.surname}'),
                        subtitle: Text(member.username),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}