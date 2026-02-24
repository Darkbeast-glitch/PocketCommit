import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/app/app_theme.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commitViewModelProvider);
    final currentCommit = state.currentCommit;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Streaks',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Consistency',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Month Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppTheme.textMedium,
                        ),
                      ),
                      Text(
                        _getMonthYearString(_currentMonth),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppTheme.textMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Week Days Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map(
                          (day) => SizedBox(
                            width: 40,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Calendar Grid
                  Expanded(child: _buildCalendarGrid(currentCommit)),

                  // Stats Section
                  const SizedBox(height: 24),
                  _buildStatsSection(currentCommit),
                ],
              ),
            ),
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendarGrid(Commit? commit) {
    final today = DateTime.now();
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    // Get completion status for this month
    final completionStatus =
        commit?.getMonthCompletionStatus(
          _currentMonth.year,
          _currentMonth.month,
        ) ??
        {};

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 rows x 7 days
      itemBuilder: (context, index) {
        final dayNumber = index - startingWeekday + 1;

        // Skip days before/after the month
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          _currentMonth.year,
          _currentMonth.month,
          dayNumber,
        );
        final isToday =
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final isCompleted = completionStatus[dayNumber] ?? false;
        final isPast = date.isBefore(
          DateTime(today.year, today.month, today.day),
        );
        final isFuture = date.isAfter(today);

        return _buildDayCell(
          dayNumber: dayNumber,
          isToday: isToday,
          isCompleted: isCompleted,
          isPast: isPast,
          isFuture: isFuture,
        );
      },
    );
  }

  Widget _buildDayCell({
    required int dayNumber,
    required bool isToday,
    required bool isCompleted,
    required bool isPast,
    required bool isFuture,
  }) {
    // Determine colors based on status
    Color backgroundColor;
    Color textColor;
    bool showCheckmark = false;

    if (isCompleted) {
      // Completed day - green with checkmark
      backgroundColor = AppTheme.primaryGreen;
      textColor = Colors.white;
      showCheckmark = true;
    } else if (isPast && !isCompleted) {
      // Missed day - light gray
      backgroundColor = AppTheme.cardBorder.withValues(alpha: 0.5);
      textColor = AppTheme.textMedium;
    } else if (isFuture) {
      // Future day - very light
      backgroundColor = Colors.transparent;
      textColor = AppTheme.textLight;
    } else {
      // Today (not completed yet)
      backgroundColor = Colors.transparent;
      textColor = AppTheme.textDark;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: AppTheme.textDark, width: 2) : null,
      ),
      child: Center(
        child: showCheckmark
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '$dayNumber',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
      ),
    );
  }

  Widget _buildStatsSection(Commit? commit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow(
            'Current Streak',
            '${commit?.streak ?? 0} Days',
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 12),
          Divider(color: AppTheme.cardBorder),
          const SizedBox(height: 12),
          _buildStatRow(
            'Longest Streak',
            '${commit?.longestStreak ?? 0} Days',
            AppTheme.streakFire,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: AppTheme.textMedium)),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
