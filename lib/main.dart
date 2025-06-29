import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synhub/shared/views/login.dart';
import 'package:synhub/tasks/bloc/task/task_bloc.dart';

import 'shared/bloc/auth/auth_bloc.dart';
import 'shared/bloc/member/member_bloc.dart';
import 'shared/services/auth_service.dart';
import 'shared/services/member_service.dart';
import 'tasks/services/task_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authService: AuthService(),
            memberService: MemberService(),
          ),
        ),
        BlocProvider(
          create: (_) => MemberBloc(memberService: MemberService()),
        ),
        BlocProvider(
          create: (_) => TaskBloc(taskService: TaskService()),
        ),
      ],
      child: MaterialApp(
        title: 'SynHub',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Login(),
      ),
    );
  }
}