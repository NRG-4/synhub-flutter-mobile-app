import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../bloc/task/task_state.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetail extends StatelessWidget {
  final int taskId;

  const TaskDetail({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskService: TaskService())
        ..add(LoadTaskByIdEvent(taskId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Detalles de la tarea',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskDetailLoaded) {
              return _buildTaskCard(context, state.task);
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No se encontró la tarea'));
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {

    final progressColor = _getDividerColor(task.createdAt, task.dueDate);
    final formattedDates = _formatTaskDates(task);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Color(0xFFF5F5F5),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.black
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 100,
                  minWidth: double.infinity,
                ),
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      task.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  formattedDates,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              // Barra de progreso con color según estado
              const SizedBox(height: 12),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF9800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                    Text("Enviar un comentario", style: TextStyle(fontSize: 18, color: Colors.white))
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                    Text("Marcar como completada", style: TextStyle(fontSize: 18, color: Colors.white))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getDividerColor(String createdAt, String dueDate) {
    try {
      // Parsear fechas considerando la zona horaria
      final created = _parseDateWithTimeZone(createdAt);
      final due = _parseDateWithTimeZone(dueDate);
      final now = DateTime.now();

      final totalSeconds = due.difference(created).inSeconds.toDouble();
      final secondsPassed = now.difference(created).inSeconds.toDouble();

      if (totalSeconds <= 0) return const Color(0xFFF44336);

      final progress = (secondsPassed / totalSeconds).clamp(0.0, 1.0);

      if (now.isAfter(due)) {
        return const Color(0xFFF44336); // Rojo - Tarea vencida
      } else if (progress < 0.7) {
        return const Color(0xFF4CAF50); // Verde - Buen progreso
      } else {
        return const Color(0xFFFDD634); // Amarillo - Progreso crítico
      }
    } catch (e) {
      return const Color(0xFF4CAF50); // Verde por defecto si hay error
    }
  }

  DateTime _parseDateWithTimeZone(String dateString) {
    try {
      // Intenta parsear como fecha con zona horaria (ISO 8601)
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      try {
        // Intenta parsear como fecha simple
        return DateFormat("yyyy-MM-dd").parse(dateString);
      } catch (e) {
        // Si falla, devuelve la fecha actual como fallback
        return DateTime.now();
      }
    }
  }

  String _formatTaskDates(Task task) {
    try {
      final createdAt = _parseDateWithTimeZone(task.createdAt);
      final dueDate = _parseDateWithTimeZone(task.dueDate);

      final format1 = DateFormat('dd/MM/yyyy');
      final format2 = DateFormat('dd/MM/yyyy HH:mm');
      return '${format1.format(createdAt)} - ${format2.format(dueDate)}';
    } catch (e) {
      // Si falla el parsing, usar los primeros 10 caracteres
      return '${task.createdAt.substring(0, 10)} - ${task.dueDate.substring(0, 10)}';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString.length > 10 ? dateString.substring(0, 10) : dateString;
    }
  }

  bool _isTaskOverdue(String dueDate) {
    try {
      final due = DateTime.parse(dueDate);
      return DateTime.now().isAfter(due);
    } catch (e) {
      return false;
    }
  }
}