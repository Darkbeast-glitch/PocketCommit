import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_commit/app/app_theme.dart';
import 'package:pocket_commit/core/utils/emoji_mapper.dart';
import 'package:pocket_commit/features/commits/data/models/commit_model.dart';
import 'package:pocket_commit/features/commits/viewmodel/commit_provider.dart';

class CommitScreen extends ConsumerStatefulWidget {
  const CommitScreen({super.key});

  @override
  ConsumerState<CommitScreen> createState() => _CommitScreenState();
}

class _CommitScreenState extends ConsumerState<CommitScreen>
    with SingleTickerProviderStateMixin {
  late CardSwiperController _swiperController;
  late CardSwiperController _doneSwiperController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    _doneSwiperController = CardSwiperController();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(
      () => ref.read(commitViewModelProvider.notifier).loadAllCommits(),
    );
  }

  @override
  void dispose() {
    _swiperController.dispose();
    _doneSwiperController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Get commits that are NOT completed today (pending)
  List<Commit> _getPendingCommits(List<Commit> commits) {
    return commits.where((c) => !c.isCompletedToday).toList();
  }

  /// Get commits that ARE completed today
  List<Commit> _getCompletedCommits(List<Commit> commits) {
    return commits.where((c) => c.isCompletedToday).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commitViewModelProvider);
    final pendingCommits = _getPendingCommits(state.commits);
    final completedCommits = _getCompletedCommits(state.commits);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'Home',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: AppTheme.primaryGreen,
              size: 28,
            ),
            onPressed: _showCreateCommitDialog,
          ),
        ],
        bottom: state.commits.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBorder.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.primaryGreen,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textMedium,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.pending_actions_rounded, size: 18),
                            const SizedBox(width: 6),
                            Text('To Do (${pendingCommits.length})'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 18),
                            const SizedBox(width: 6),
                            Text('Done (${completedCommits.length})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.commits.isEmpty
          ? _buildEmptyState()
          : TabBarView(
              controller: _tabController,
              children: [
                // Pending/To Do Tab - uses card swiper
                pendingCommits.isEmpty
                    ? _buildAllDoneState()
                    : _buildStackedCards(
                        state,
                        pendingCommits,
                        _swiperController,
                      ),
                // Done Tab - uses simple list
                completedCommits.isEmpty
                    ? _buildNoDoneState()
                    : _buildDoneList(completedCommits),
              ],
            ),
    );
  }

  /// State when all commits are done for today
  Widget _buildAllDoneState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Text('🎉', style: TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 32),
            Text(
              'All Done!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ve completed all your commitments\nfor today. Great job!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// State when no commits are done yet
  Widget _buildNoDoneState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.textLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_empty_rounded,
                size: 64,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Nothing Done Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete some commitments\nand they\'ll appear here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Simple list view for completed commits
  Widget _buildDoneList(List<Commit> commits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Completed Today",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Scrollable list of done cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: commits.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildDoneCard(commits[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Compact card for completed commits
  Widget _buildDoneCard(Commit commit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Checkmark icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commit.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                if (commit.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    commit.description,
                    style: TextStyle(fontSize: 14, color: AppTheme.textMedium),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.streakBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '${commit.streak}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.streakFire,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 64,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Commitments Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first daily pocket commitment\nand start building your streak!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showCreateCommitDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Create Your First Commitment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedCards(
    dynamic state,
    List<Commit> commits,
    CardSwiperController controller, {
    bool isDoneTab = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            isDoneTab ? "Completed Today" : "Today's Pocket",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Stacked Card Swiper
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CardSwiper(
              key: ValueKey(
                commits.length,
              ), // <== Forces rebuild when count changes!
              controller: controller,
              cardsCount: commits.length,
              numberOfCardsDisplayed: commits.length > 2 ? 3 : commits.length,
              backCardOffset: const Offset(0, 24),
              padding: const EdgeInsets.only(bottom: 40),
              isLoop: commits.length > 1,
              onSwipe: (previousIndex, currentIndex, direction) {
                // For the pending tab, update the current index
                if (!isDoneTab && currentIndex != null) {
                  // Find the actual index in the full commits list
                  final actualIndex = state.commits.indexOf(
                    commits[currentIndex],
                  );
                  if (actualIndex != -1) {
                    ref
                        .read(commitViewModelProvider.notifier)
                        .setCurrentIndex(actualIndex);
                  }
                }
                return true;
              },
              cardBuilder:
                  (
                    context,
                    index,
                    horizontalOffsetPercentage,
                    verticalOffsetPercentage,
                  ) {
                    return _buildCommitCard(
                      commits[index],
                      isDoneTab: isDoneTab,
                    );
                  },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommitCard(Commit commit, {bool isDoneTab = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDoneTab
            ? AppTheme.primaryGreen.withValues(alpha: 0.05)
            : AppTheme.background,
        borderRadius: BorderRadius.circular(32),
        border: isDoneTab
            ? Border.all(
                color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Emoji Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commit.title,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (commit.description.isNotEmpty)
                                Text(
                                  commit.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textMedium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Emoji
                        Text(
                          isDoneTab ? '✅' : EmojiMapper.getEmoji(commit.title),
                          style: const TextStyle(fontSize: 60),
                        ),
                      ],
                    ),

                    // Scheduled Time (if set)
                    if (commit.scheduledTime != null &&
                        commit.scheduledTime!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: AppTheme.primaryGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              commit.scheduledTime!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Streak Badge
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.streakBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'Streak: ${commit.streak}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.streakFire,
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

            // Mark as Done Button or Completed Indicator
            SizedBox(
              width: double.infinity,
              height: 60,
              child: isDoneTab
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed Today',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: commit.isCompletedToday
                          ? null
                          : () => ref
                                .read(commitViewModelProvider.notifier)
                                .markAsDone(commit.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        disabledBackgroundColor: AppTheme.primaryGreen
                            .withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        commit.isCompletedToday
                            ? 'Completed ✓'
                            : 'Mark as Done',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCommitDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'New Commitment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What small thing will you commit to daily?',
                style: TextStyle(fontSize: 14, color: AppTheme.textMedium),
              ),
              const SizedBox(height: 24),

              // Title Field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Daily Walk',
                  labelText: 'Title',
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'e.g., 20 minutes outdoors',
                  labelText: 'Description (optional)',
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time Picker
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppTheme.primaryGreen,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setModalState(() {
                      selectedTime = time;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: AppTheme.textMedium,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Set reminder time (optional)',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedTime != null
                              ? AppTheme.textDark
                              : AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Create Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final timeString = selectedTime?.format(context);

                      ref
                          .read(commitViewModelProvider.notifier)
                          .createCommit(
                            titleController.text,
                            description: descriptionController.text,
                            scheduledTime: timeString,
                          );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Commitment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
