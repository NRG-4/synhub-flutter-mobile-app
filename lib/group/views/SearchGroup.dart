import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group/group_bloc.dart';
import '../bloc/group/group_event.dart';
import '../bloc/group/group_state.dart';
import '../bloc/invitation/invitation_bloc.dart';
import '../bloc/invitation/invitation_event.dart';
import '../bloc/invitation/invitation_state.dart';
import '../models/group.dart';
import '../services/group_service.dart';
import '../services/invitation_service.dart';

class SearchGroup extends StatefulWidget {
  const SearchGroup({super.key});

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GroupBloc(groupService: GroupService()),
        ),
        BlocProvider(
          create: (context) => InvitationBloc(invitationService: InvitationService()),
        ),
      ],
      child: _SearchGroupContent(formKey: _formKey, codeController: _codeController, showGroupDialog: _showGroupDialog),
    );
  }

  void _showGroupDialog(BuildContext context, Group group) {
    final invitationBloc = BlocProvider.of<InvitationBloc>(context);
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: invitationBloc,
        child: BlocListener<InvitationBloc, InvitationState>(
          listener: (context, state) {
            if (state is GroupInvitationSent) {
              Navigator.pop(context);
              // Recargar la invitación para mostrar la card
              context.read<InvitationBloc>().add(LoadMemberInvitationEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Solicitud enviada al grupo ${group.name}'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is InvitationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
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
              BlocBuilder<InvitationBloc, InvitationState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                    ),
                    onPressed: state is InvitationLoading
                        ? null
                        : () {
                      context.read<InvitationBloc>().add(
                        SendGroupInvitationEvent(group.id),
                      );
                    },
                    child: state is InvitationLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Enviar solicitud',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchGroupContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final void Function(BuildContext, Group) showGroupDialog;

  const _SearchGroupContent({required this.formKey, required this.codeController, required this.showGroupDialog});

  @override
  State<_SearchGroupContent> createState() => _SearchGroupContentState();
}

class _SearchGroupContentState extends State<_SearchGroupContent> {
  @override
  void initState() {
    super.initState();
    // Ahora sí, el Bloc está disponible en el contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvitationBloc>().add(LoadMemberInvitationEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: BlocBuilder<InvitationBloc, InvitationState>(
          builder: (context, state) {
            if (state is InvitationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvitationError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            } else if (state is MemberInvitationLoaded) {
              final invitation = state.invitation;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tienes una invitación pendiente', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Grupo: ${invitation.group.name}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Código: #${invitation.group.code}', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvitationBloc>().add(CancelMemberInvitationEvent());
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Cancelar solicitud', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // NoMemberInvitation o estado inicial: mostrar formulario de búsqueda
              return Form(
                key: widget.formKey,
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
                      controller: widget.codeController,
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
                        if (value.length != 9) {
                          return 'El código debe tener 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<GroupBloc, GroupState>(
                      listener: (context, state) {
                        if (state is GroupFound) {
                          widget.showGroupDialog(context, state.group);
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
                            if (widget.formKey.currentState!.validate()) {
                              context.read<GroupBloc>().add(
                                SearchGroupByCodeEvent(widget.codeController.text),
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
                    if (widget.codeController.text.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Pide el código al administrador del grupo',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}