import 'package:equatable/equatable.dart';

class EmployeeStats extends Equatable {
  final String todayEarnings;
  final String lifetimeEarnings;
  final int totalCalls;

  const EmployeeStats({
    required this.todayEarnings,
    required this.lifetimeEarnings,
    required this.totalCalls,
  });

  factory EmployeeStats.empty() {
    return const EmployeeStats(
      todayEarnings: '0',
      lifetimeEarnings: '0',
      totalCalls: 0,
    );
  }

  @override
  List<Object> get props => [todayEarnings, lifetimeEarnings, totalCalls];
}
