import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:plantarium/features/garden_notes/presentation/screens/garden_note_edit_screen.dart';
import 'package:plantarium/shared/widgets/app_widgets.dart';
import 'package:plantarium/shared/di/service_locator.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';

class GardenNotesListScreen extends StatelessWidget {
  const GardenNotesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  const _GardenNotesListContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GardenNotesProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garden Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.loadNotes,
            tooltip: 'Refresh notes',
          ),
        ],
      ),
      body: _buildBody(context, provider, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditScreen(context, null),
        tooltip: 'Create new note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GardenNotesProvider provider,
    ThemeData theme,
  ) {
    if (provider.isLoading) {
      return AppLoadingIndicators.standard(
        message: 'Loading your garden notes...',
      );
    }

    if (provider.error != null) {
      return AppErrorDisplays.standard(
        errorMessage: provider.error ?? 'Unknown error',
        errorCode: provider.errorCode,
        onRetry: provider.loadNotes,
      );
    }

    if (provider.notes.isEmpty) {
      return AppEmptyStates.standard(
        title: 'No garden notes yet',
        subtitle: 'Create your first note to get started!',
        icon: Icons.note_add,
        iconColor: theme.colorScheme.primary.withOpacity(0.5),
        actionButton: ElevatedButton.icon(
          onPressed: () => _navigateToEditScreen(context, null),
          icon: const Icon(Icons.add),
          label: const Text('Create Note'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadNotes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.notes.length,
        itemBuilder: (context, index) {
          final note = provider.notes[index];
          return _buildNoteCard(context, note, theme);
        },
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    GardenNoteDTO note,
    ThemeData theme,
  ) {
    return AppCard(
      onTap: () => _navigateToEditScreen(context, note),
      title: note.title,
      actions: [
        DateDisplay(
          date: note.date,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
      child: Text(
        note.note,
        style: theme.textTheme.bodyMedium,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, GardenNoteDTO? note) {
    // Get the provider from the current context
    final provider = Provider.of<GardenNotesProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => GardenNoteEditScreen(
              gardenNoteService: sl<IGardenNoteService>(),
              note: note,
            ),
      ),
    ).then((shouldRefresh) {
      if (shouldRefresh == true) {
        provider.loadNotes();
      }
    });
  }
}
