import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:plantarium/features/garden_notes/data/models/garden_note.dto.dart';
import 'package:plantarium/shared/services/garden_note_service_interface.dart';
import 'package:plantarium/core/network/models/api_error.dart';
import 'package:flutter/foundation.dart';

class GardenNoteEditScreen extends StatefulWidget {
  final IGardenNoteService gardenNoteService;
  final GardenNoteDTO? note;

  const GardenNoteEditScreen({
    Key? key,
    required this.gardenNoteService,
    this.note,
  }) : super(key: key);

  @override
  State<GardenNoteEditScreen> createState() => _GardenNoteEditScreenState();
}

class _GardenNoteEditScreenState extends State<GardenNoteEditScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  bool _isSaving = false;
  String? _error;
  String? _errorCode;
  Map<String, dynamic>? _errorDetails;
  bool _hasUnsavedChanges = false;
  DateTime? _lastAutoSave;
  late TabController _tabController;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();

    // Simply load the content as is, without modification
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _noteController = TextEditingController(text: widget.note?.note ?? '');

    // Debug logging for initial content
    if (kDebugMode && widget.note != null) {
      print('INIT: Loading note with ID: ${widget.note!.id}');
      print('INIT: Title: "${widget.note!.title}"');
      print(
        'INIT: Content starts with: "${widget.note!.note.substring(0, widget.note!.note.length > 50 ? 50 : widget.note!.note.length)}..."',
      );
      print('INIT: Content length: ${widget.note!.note.length} characters');
    }

    _tabController = TabController(length: 2, vsync: this);

    // Listen for changes to enable auto-save
    _titleController.addListener(_onTextChanged);
    _noteController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _noteController.removeListener(_onTextChanged);
    _titleController.dispose();
    _noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }

    // Only auto-save for existing notes, not for new ones
    if (widget.note != null) {
      _autoSave();
    }
  }

  void _autoSave() async {
    // Skip auto-save for new notes
    if (!_hasUnsavedChanges || _isSaving || widget.note == null) return;

    final now = DateTime.now();
    if (_lastAutoSave != null && now.difference(_lastAutoSave!).inSeconds < 5) {
      return; // Don't auto-save more often than every 5 seconds
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
      _errorCode = null;
      _errorDetails = null;
    });

    try {
      // Debug logging
      if (kDebugMode) {
        print('AUTO-SAVE: Saving note with ID: ${widget.note!.id}');
        print('AUTO-SAVE: Title: "${_titleController.text}"');
        print(
          'AUTO-SAVE: Content starts with: "${_noteController.text.substring(0, _noteController.text.length > 50 ? 50 : _noteController.text.length)}..."',
        );
        print(
          'AUTO-SAVE: Content length: ${_noteController.text.length} characters',
        );
      }

      // Only update existing notes with auto-save - send the content as is
      final updatedNote = GardenNoteDTO(
        id: widget.note!.id,
        title: _titleController.text,
        note: _noteController.text,
        date: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
      );
      await widget.gardenNoteService.updateNote(widget.note!.id!, updatedNote);

      setState(() {
        _hasUnsavedChanges = false;
        _lastAutoSave = DateTime.now();
      });
    } on ApiError catch (e) {
      setState(() {
        _error = e.message;
        _errorCode = e.errorCode;
        _errorDetails = e.errorDetails;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
      _errorCode = null;
      _errorDetails = null;
    });

    try {
      if (widget.note != null) {
        // Debug logging
        if (kDebugMode) {
          print(
            'EDIT SCREEN: Updating existing note with ID: ${widget.note!.id}',
          );
          print('EDIT SCREEN: Title: "${_titleController.text}"');
          print(
            'EDIT SCREEN: Content starts with: "${_noteController.text.substring(0, _noteController.text.length > 50 ? 50 : _noteController.text.length)}..."',
          );
          print(
            'EDIT SCREEN: Content length: ${_noteController.text.length} characters',
          );
        }

        // Update existing note while preserving ID - send the content as is
        final updatedNote = GardenNoteDTO(
          id: widget.note!.id,
          title: _titleController.text,
          note: _noteController.text,
          date: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        );
        await widget.gardenNoteService.updateNote(
          widget.note!.id!,
          updatedNote,
        );
      } else {
        // Debug logging
        if (kDebugMode) {
          print('EDIT SCREEN: Creating new note');
          print('EDIT SCREEN: Title: "${_titleController.text}"');
          print(
            'EDIT SCREEN: Content starts with: "${_noteController.text.substring(0, _noteController.text.length > 50 ? 50 : _noteController.text.length)}..."',
          );
          print(
            'EDIT SCREEN: Content length: ${_noteController.text.length} characters',
          );
        }

        // Create new note - send the content as is without adding a header
        final newNote = GardenNoteDTO.create(
          title: _titleController.text,
          note: _noteController.text,
        );
        await widget.gardenNoteService.createNote(newNote);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on ApiError catch (e) {
      setState(() {
        _error = e.message;
        _errorCode = e.errorCode;
        _errorDetails = e.errorDetails;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (!_hasUnsavedChanges) return true;

        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Unsaved Changes'),
                content: const Text(
                  'You have unsaved changes. Are you sure you want to leave?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Discard'),
                  ),
                ],
              ),
        );

        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note == null ? 'New Garden Note' : 'Edit Garden Note',
          ),
          actions: [
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveNote,
                tooltip: 'Save note',
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() => _isPreviewMode = index == 1);
            },
            tabs: const [
              Tab(icon: Icon(Icons.edit), text: 'Edit'),
              Tab(icon: Icon(Icons.preview), text: 'Preview'),
            ],
          ),
        ),
        body: _buildBody(theme, isDark),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, bool isDark) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                    if (_errorCode != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Error Code: $_errorCode',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    isDark
                        ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                        : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                prefixIcon: const Icon(Icons.title),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _titleController,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/100',
                      style: theme.textTheme.bodySmall,
                    );
                  },
                ),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isPreviewMode
                      ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? theme.colorScheme.surfaceVariant
                                      .withOpacity(0.5)
                                  : theme.colorScheme.surfaceVariant
                                      .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Markdown(
                          data: _noteController.text,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: theme.textTheme.bodyLarge,
                            h1: theme.textTheme.headlineSmall,
                            h2: theme.textTheme.titleLarge,
                            h3: theme.textTheme.titleMedium,
                            h4: theme.textTheme.titleSmall,
                            blockquote: theme.textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            code: theme.textTheme.bodyMedium?.copyWith(
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              fontFamily: 'monospace',
                            ),
                            listBullet: theme.textTheme.bodyLarge,
                          ),
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                labelText: 'Note',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor:
                                    isDark
                                        ? theme.colorScheme.surfaceVariant
                                            .withOpacity(0.5)
                                        : theme.colorScheme.surfaceVariant
                                            .withOpacity(0.3),
                                alignLabelWithHint: true,
                                prefixIcon: const Icon(Icons.note),
                              ),
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your note';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          ValueListenableBuilder(
                            valueListenable: _noteController,
                            builder: (context, value, child) {
                              return Text(
                                '${value.text.length} characters',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.end,
                              );
                            },
                          ),
                        ],
                      ),
            ),
            if (_hasUnsavedChanges) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Changes will be saved automatically',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
