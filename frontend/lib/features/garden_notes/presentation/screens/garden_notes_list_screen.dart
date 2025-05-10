import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plantarium/features/garden_notes/domain/entities/garden_note.entity.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes.provider.dart';
import 'package:plantarium/features/garden_notes/presentation/state/garden_notes.state.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:intl/intl.dart';

class GardenNotesListScreen extends ConsumerWidget {
  const GardenNotesListScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Get the provider from Riverpod and load notes
    final notifier = ref.read(gardenNotesProvider.notifier);

    // Initialize loading notes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.loadNotes();
    });

    return const _GardenNotesListContent();
  }
}

class _GardenNotesListContent extends ConsumerWidget {
  const _GardenNotesListContent({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(gardenNotesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          const AppSidebar(selectedIndex: 7),

          // Main content
          Expanded(
            child: Column(
              children: [
                _buildAppBar(theme),
                Expanded(child: _buildBody(context, ref, state, theme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(final ThemeData theme) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Garden Notes',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Keep track of observations and tasks',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildBody(
    final BuildContext context,
    final WidgetRef ref,
    final GardenNotesState state,
    final ThemeData theme,
  ) {
    if (state.isLoading) {
      return AppLoadingIndicators.standard(
        message: 'Loading your garden notes...',
      );
    }

    if (state.hasError) {
      return AppErrorDisplays.standard(
        errorMessage: state.errorMessage ?? 'Unknown error',
        onRetry: () => ref.read(gardenNotesProvider.notifier).loadNotes(),
      );
    }

    final notes = state.notes;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Existing Notes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                notes.isEmpty
                    ? _buildEmptyState(context, theme)
                    : _buildNotesList(context, ref, notes, theme),
          ),
          const SizedBox(height: 16),
          Text(
            'Add New Note',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildNewNoteForm(context, ref, theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context, final ThemeData theme) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No garden notes yet',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first note below to get started!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget _buildNotesList(
    final BuildContext context,
    final WidgetRef ref,
    final List<GardenNote> notes,
    final ThemeData theme,
  ) => ListView.builder(
    itemCount: notes.length,
    itemBuilder: (context, index) {
      final note = notes[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatDate(note.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(note.content, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildNewNoteForm(
    final BuildContext context,
    final WidgetRef ref,
    final ThemeData theme,
  ) {
    // Garden selection
    final gardenTypes = ['Backyard Garden', 'Herb Garden', 'Container Garden'];
    String selectedGarden = gardenTypes[0];
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title input
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Note title',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),

        // Note input area
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: TextField(
            controller: contentController,
            decoration: InputDecoration(
              hintText: 'Write your garden observations here...',
              hintStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              border: InputBorder.none,
            ),
            style: theme.textTheme.bodyMedium,
            maxLines: 5,
          ),
        ),
        const SizedBox(height: 16),

        // Garden selector and save button
        Row(
          children: [
            // Garden dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedGarden,
                decoration: InputDecoration(
                  labelText: 'Garden',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items:
                    gardenTypes.map((garden) {
                      return DropdownMenuItem<String>(
                        value: garden,
                        child: Text(garden),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedGarden = value;
                  }
                },
              ),
            ),
            const SizedBox(width: 16),

            // Save button
            ElevatedButton.icon(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  // Create a new garden note
                  final newNote = GardenNote(
                    id: null, // ID will be assigned by repository
                    title: titleController.text,
                    content: contentController.text,
                    date: DateTime.now(),
                  );

                  // Save the note using the provider
                  ref.read(gardenNotesProvider.notifier).createNote(newNote);

                  // Clear the form
                  titleController.clear();
                  contentController.clear();
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(final DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
