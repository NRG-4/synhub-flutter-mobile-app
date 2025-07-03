import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_event.dart';
import '../bloc/statistics_state.dart';
import '../services/statistics_service.dart';
import '../../tasks/services/task_service.dart';
import '../../tasks/models/task.dart';

const Color kBluePrimary = Color(0xFF1A4E85);
const Color kBlueLight = Color(0xFFE3F2FD);
const Color kBlueLighter = Color(0xFFF0F6FF);
const Color kBlueAccent = Color(0xFF1976D2);
const Color kBlueCard = Color(0xFFF5F9FF);

class StatisticsScreen extends StatefulWidget {
  final String memberId;
  final String memberName;
  final String username;
  final String profileImageUrl;

  const StatisticsScreen({
    super.key,
    required this.memberId,
    required this.memberName,
    required this.username,
    required this.profileImageUrl,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Task> _memberTasks = [];
  bool _loadingTasks = true;

  @override
  void initState() {
    super.initState();
    _fetchMemberTasks();
  }

  Future<void> _fetchMemberTasks() async {
    try {
      final tasks = await TaskService().getMemberTasks();
      setState(() {
        _memberTasks = tasks;
        _loadingTasks = false;
      });
    } catch (_) {
      setState(() {
        _memberTasks = [];
        _loadingTasks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsBloc(StatisticsService())..add(LoadMemberStatistics(widget.memberId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Resumen de mi desempeño', style: TextStyle(color: kBluePrimary)),
          iconTheme: const IconThemeData(color: kBluePrimary),
          elevation: 0,
        ),
        body: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading || _loadingTasks) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatisticsLoaded) {
              final stats = state.statistics;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.white, // Card principal en blanco
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: kBlueLight,
                                backgroundImage: widget.profileImageUrl.isNotEmpty
                                    ? NetworkImage(widget.profileImageUrl)
                                    : null,
                                child: widget.profileImageUrl.isEmpty
                                    ? Icon(Icons.person, color: kBluePrimary, size: 32)
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.memberName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: kBluePrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.username,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Resumen de tu desempeño',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatCard(label: 'Completadas', value: stats.overview.completed.toString(), color: Colors.green),
                            _StatCard(label: 'En progreso', value: stats.overview.inProgress.toString(), color: Colors.blue),
                            _StatCard(label: 'Pendientes', value: stats.overview.pending.toString(), color: Colors.orange),
                            _StatCard(label: 'Atrasadas', value: stats.overview.overdue.toString(), color: Colors.red),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionCard(
                        icon: Icons.bar_chart,
                        title: 'Distribución de Tareas',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: ${_memberTasks.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: kBluePrimary)),
                            const SizedBox(height: 8),
                            if (_memberTasks.isEmpty)
                              const Text('No hay tareas asignadas.', style: TextStyle(color: Colors.black54)),
                            if (_memberTasks.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _memberTasks.length,
                                itemBuilder: (context, idx) {
                                  final task = _memberTasks[idx];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${idx + 1}. ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kBluePrimary,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionCard(
                        icon: Icons.build,
                        title: 'Tareas Reprogramadas',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MetricRow(label: 'Reprogramadas', value: stats.rescheduledTasks.rescheduled.toString()),
                            _MetricRow(label: 'No reprogramadas', value: stats.rescheduledTasks.notRescheduled.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionCard(
                        icon: Icons.date_range,
                        title: 'Tiempo Promedio de Finalización',
                        child: Row(
                          children: [
                            Icon(Icons.timer, color: kBlueAccent),
                            const SizedBox(width: 8),
                            Text(
                              _formatAvgCompletionTime(stats.avgCompletionTime.avgDays),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kBlueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is StatisticsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data'));
          },
        ),
      ),
    );
  }

  String _formatAvgCompletionTime(double avgDays) {
    final totalMinutes = (avgDays * 24 * 60).round();
    final days = totalMinutes ~/ (24 * 60);
    final hours = (totalMinutes % (24 * 60)) ~/ 60;
    final minutes = totalMinutes % 60;

    List<String> parts = [];
    if (days > 0) parts.add('$days día${days == 1 ? '' : 's'}');
    if (hours > 0) parts.add('$hours hora${hours == 1 ? '' : 's'}');
    if (minutes > 0 || parts.isEmpty) parts.add('$minutes minuto${minutes == 1 ? '' : 's'}');

    return parts.join(', ');
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  Color get vibrantBackground {
    if (color == Colors.green) {
      return const Color(0xFFB9F6CA);
    } else if (color == Colors.blue) {
      return const Color(0xFF82B1FF);
    } else if (color == Colors.orange) {
      return const Color(0xFFFFE082);
    } else if (color == Colors.red) {
      return const Color(0xFFFF8A80);
    }
    return color.withOpacity(0.15);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: vibrantBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 100,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Fondo blanco para todas las section cards
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kBluePrimary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: kBluePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: kBlueAccent)),
        ],
      ),
    );
  }
}
