import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beautiful_todo_app/models/category_info.dart';
import 'package:beautiful_todo_app/models/todo_filter.dart';
import 'package:beautiful_todo_app/viewmodels/todo_viewmodel.dart';

import '../models/todo_item.dart';

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1B998B)),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _HeaderSection(
              completedCount: viewModel.completedCount,
              totalCount: viewModel.totalCount,
              completionRate: viewModel.completionRate,
            ),
            const SizedBox(height: 8),
            _StatsRow(
              totalCount: viewModel.totalCount,
              completedCount: viewModel.completedCount,
              activeCount: viewModel.activeCount,
            ),
            const SizedBox(height: 8),
            _FilterBar(
              selectedFilter: viewModel.selectedFilter,
              onFilterChanged: (filter) => viewModel.setFilter(filter),
              onClearCompleted: viewModel.clearCompleted,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: viewModel.filteredTodos.isEmpty
                  ? _EmptyState(
                      isFiltered: viewModel.selectedFilter != TodoFilter.all,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemBuilder: (context, index) {
                        final todo = viewModel.filteredTodos[index];
                        return _TodoCard(
                          todo: todo,
                          onToggle: () => viewModel.toggleTodo(todo),
                          onDelete: () => viewModel.deleteTodo(todo),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: viewModel.filteredTodos.length,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddTodoSheet(context),
          elevation: 2,
          backgroundColor: const Color(0xFF1B998B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: const Text(
            'New Task',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _showAddTodoSheet(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var selectedCategoryIndex = 0;

    final newTask = await showModalBottomSheet<_NewTaskData>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 6,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1B998B), Color(0xFF0F4C5C)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'New Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Task title',
                        labelStyle: const TextStyle(color: Color(0xFF8E8E9E)),
                        hintText: 'What do you need to do?',
                        hintStyle: const TextStyle(color: Color(0xFF5E5E6E)),
                        prefixIcon:
                            const Icon(Icons.edit_rounded, color: Color(0xFF8E8E9E)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF2E2E3E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF2E2E3E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFF1B998B), width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF252538),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please add a task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Color(0xFF8E8E9E)),
                        hintText: 'Add some details...',
                        hintStyle: const TextStyle(color: Color(0xFF5E5E6E)),
                        prefixIcon: const Icon(Icons.description_outlined,
                            color: Color(0xFF8E8E9E)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF2E2E3E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF2E2E3E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFF1B998B), width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF252538),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFFB0B0C0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? cat.color.withValues(alpha: 0.2)
                                    : const Color(0xFF252538),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isSelected
                                      ? cat.color
                                      : const Color(0xFF3A3A4E),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(cat.emoji,
                                      style: const TextStyle(fontSize: 18)),
                                  if (isSelected) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: cat.color,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B998B), Color(0xFF0F4C5C)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF1B998B).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              Navigator.of(sheetContext).pop(
                                _NewTaskData(
                                  title: titleController.text.trim(),
                                  description:
                                      descriptionController.text.trim(),
                                  categoryIndex: selectedCategoryIndex,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Create Task',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (newTask != null) {
      context
          .read<TodoViewModel>()
          .addTodo(newTask.title, newTask.description, newTask.categoryIndex);
    }
  }
}

// ─── Header Section ──────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.completedCount,
    required this.totalCount,
    required this.completionRate,
  });

  final int completedCount;
  final int totalCount;
  final double completionRate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12 ? 'Morning' : hour < 17 ? 'Afternoon' : 'Evening';
    final greetingEmoji = hour < 12 ? '🌅' : hour < 17 ? '☀️' : '🌙';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C5C), Color(0xFF1B998B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C5C).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          greetingEmoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Good $greeting',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${now.day}/${now.month}/${now.year}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: completionRate),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 4,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.15),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                    ),
                    Text(
                      '$totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(
                icon: Icons.check_circle_rounded,
                label: '$completedCount done',
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.radio_button_unchecked_rounded,
                label: '${totalCount - completedCount} left',
              ),
              const Spacer(),
              Text(
                '${(completionRate * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.totalCount,
    required this.completedCount,
    required this.activeCount,
  });

  final int totalCount;
  final int completedCount;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _QuickStat(
            label: 'Total',
            value: '$totalCount',
            color: const Color(0xFF0F4C5C),
          ),
          const SizedBox(width: 8),
          _QuickStat(
            label: 'Active',
            value: '$activeCount',
            color: const Color(0xFFF4A261),
          ),
          const SizedBox(width: 8),
          _QuickStat(
            label: 'Done',
            value: '$completedCount',
            color: const Color(0xFF1B998B),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EDF2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8E8E9E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onClearCompleted,
  });

  final TodoFilter selectedFilter;
  final ValueChanged<TodoFilter> onFilterChanged;
  final VoidCallback onClearCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.inbox_rounded,
            active: selectedFilter == TodoFilter.all,
            onTap: () => onFilterChanged(TodoFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Active',
            icon: Icons.radio_button_unchecked_rounded,
            active: selectedFilter == TodoFilter.active,
            onTap: () => onFilterChanged(TodoFilter.active),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Done',
            icon: Icons.check_circle_outline_rounded,
            active: selectedFilter == TodoFilter.completed,
            onTap: () => onFilterChanged(TodoFilter.completed),
          ),
          const Spacer(),
          if (selectedFilter == TodoFilter.completed)
            GestureDetector(
              onTap: onClearCompleted,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD0D0)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_sweep_rounded,
                        size: 16, color: Color(0xFFE76F51)),
                    SizedBox(width: 4),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE76F51),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [Color(0xFF0F4C5C), Color(0xFF1B998B)],
                )
              : null,
          color: active ? null : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? Colors.transparent : const Color(0xFFE8EDF2),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color:
                        const Color(0xFF0F4C5C).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: active ? Colors.white : const Color(0xFF8E8E9E),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF3A3A4A),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Todo Card ───────────────────────────────────────────────────────────────

class _TodoCard extends StatefulWidget {
  const _TodoCard({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  State<_TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<_TodoCard> {
  bool _isHovered = false;

  String _timeAgo(String isoDate) {
    if (isoDate.isEmpty) return '';
    try {
      final created = DateTime.parse(isoDate);
      final diff = DateTime.now().difference(created);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${created.day}/${created.month}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    final cat = todo.categoryInfo;
    final timeAgo = _timeAgo(todo.createdAt);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isHovered
              ? cat.color.withValues(alpha: 0.2)
              : const Color(0xFFE8EDF2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C5C)
                .withValues(alpha: _isHovered ? 0.06 : 0.03),
            blurRadius: _isHovered ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(18),
            onHover: (value) {
              setState(() => _isHovered = value);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: todo.isDone
                            ? cat.color
                            : cat.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: todo.isDone
                              ? cat.color
                              : cat.color.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: todo.isDone
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 20)
                            : Text(cat.emoji,
                                style: const TextStyle(fontSize: 17)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: todo.isDone
                                      ? const Color(0xFFB0B0BC)
                                      : const Color(0xFF1A1A2E),
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: const Color(0xFFB0B0BC),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (todo.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.description,
                            style: TextStyle(
                              color: todo.isDone
                                  ? const Color(0xFFC4C4D0)
                                  : const Color(0xFF6B6B7B),
                              fontSize: 13,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: cat.color.withValues(
                                    alpha: todo.isDone ? 0.08 : 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(cat.emoji,
                                      style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    cat.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: cat.color.withValues(
                                          alpha: todo.isDone ? 0.5 : 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (timeAgo.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                timeAgo,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFB0B0BC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? const Color(0xFFFFE8E8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: _isHovered
                            ? const Color(0xFFE76F51)
                            : const Color(0xFFC4C4D0),
                      ),
                    ),
                    tooltip: 'Delete task',
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(6),
                      minimumSize: const Size(32, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isFiltered});

  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1B998B).withValues(alpha: 0.12),
                    const Color(0xFF0F4C5C).withValues(alpha: 0.08),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                isFiltered ? '🔍' : '✨',
                style: const TextStyle(fontSize: 44),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isFiltered ? 'Nothing here' : 'All clear!',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'No tasks match this filter.'
                  : 'Tap + to add your first task.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8E8E9E),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── New Task Data ───────────────────────────────────────────────────────────

class _NewTaskData {
  const _NewTaskData({
    required this.title,
    required this.description,
    required this.categoryIndex,
  });

  final String title;
  final String description;
  final int categoryIndex;
}
