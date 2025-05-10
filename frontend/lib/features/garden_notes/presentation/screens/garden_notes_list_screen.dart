import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:plantarium/features/garden_notes/presentation/screens/garden_note_edit_screen.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';
import 'package:plantarium/shared/di/service_locator.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/features/dashboard/presentation/widgets/app_sidebar.dart';
import 'package:intl/intl.dart';

class GardenNotesListScreen extends StatelessWidget {
  const GardenNotesListScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    // Get the provider from context and load notes
    final provider = Provider.of<GardenNotesProvider>(context, listen: false);
    // Initialize loading notes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadNotes();
    });

    return const _GardenNotesListContent();
  }
}

class _GardenNotesListContent extends StatelessWidget {
  const _GardenNotesListContent({super.key});

  @override
  Widget build(final BuildContext context) {
    final provider = context.watch<GardenNotesProvider>();
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
                Expanded(child: _buildBody(context, provider, theme)),
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
    final GardenNotesProvider provider,
    final ThemeData theme,
  ) {
    if (provider.isLoading) {
      return AppLoadingIndicators.standard(
        message: 'Loading your garden notes...',
      );
    }

    if (provider.error != null) {
      return AppErrorDisplays.standard(
        errorMessage: provider.error ?? 'Unknown error',
        onRetry: provider.loadNotes,
      );
    }

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
                provider.notes.isEmpty
                    ? _buildEmptyState(context, theme)
                    : _buildNotesList(context, provider, theme),
          ),
          const SizedBox(height: 16),
          Text(
            'Add New Note',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildNewNoteForm(context, theme),
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
    final GardenNotesProvider provider,
    final ThemeData theme,
  ) => ListView.builder(
    itemCount: provider.notes.length,
    itemBuilder: (context, index) {
      final note = provider.notes[index];
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
              Text(note.note, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildNewNoteForm(final BuildContext context, final ThemeData theme) {
    // Garden selection
    final gardenTypes = ['Backyard Garden', 'Herb Garden', 'Container Garden'];
    String selectedGarden = gardenTypes[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGarden,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items:
                        gardenTypes
                            .map(
                              (garden) => DropdownMenuItem<String>(
                                value: garden,
                                child: Text(garden),
                              ),
                            )
                            .toList(),
                    onChanged: (final newValue) {
                      // This would be handled in a StatefulWidget
                      if (newValue != null) {
                        selectedGarden = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Save button
            ElevatedButton(
              onPressed: () {
                // This would save the note in a real implementation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Save Note'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(final DateTime date) =>
      DateFormat('MMMM d, yyyy').format(date);

  void _navigateToEditScreen(
    final BuildContext context,
    final GardenNoteDTO? note,
  ) {
    // Get the provider from the current context
    final provider = Provider.of<GardenNotesProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (final context) => GardenNoteEditScreen(
              gardenNoteService: sl<IGardenNoteService>(),
              note: note,
            ),
      ),
    ).then((final shouldRefresh) {
      if (shouldRefresh == true) {
        provider.loadNotes();
      }
    });
  }
}
