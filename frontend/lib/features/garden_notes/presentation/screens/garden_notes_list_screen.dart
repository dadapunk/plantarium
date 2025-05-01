import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/core/services/garden_note.service.dart';
import 'package:plantarium/features/garden_notes/presentation/providers/garden_notes_provider.dart';
import 'package:plantarium/features/garden_notes/presentation/screens/garden_note_edit_screen.dart';

class GardenNotesListScreen extends StatelessWidget {
  final GardenNoteService gardenNoteService;

  const GardenNotesListScreen({Key? key, required this.gardenNoteService})
    : super(key: key);

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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your garden notes...'),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${provider.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              if (provider.errorCode != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Code: ${provider.errorCode}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: provider.loadNotes,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('No garden notes yet', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Create your first note to get started!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToEditScreen(context, null),
              icon: const Icon(Icons.add),
              label: const Text('Create Note'),
            ),
          ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToEditScreen(context, note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              Text(
                note.note,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _navigateToEditScreen(BuildContext context, GardenNoteDTO? note) {
    // Get the provider and service from the current context
    final provider = Provider.of<GardenNotesProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => GardenNoteEditScreen(
              gardenNoteService: provider.gardenNoteService,
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
