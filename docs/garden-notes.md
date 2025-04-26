# Garden Notes Feature Documentation

## Overview

The Garden Notes feature provides a flexible and powerful way to document gardening activities, observations, and plans. It implements a dual-storage system:
- **SQLite Database**: For fast querying and app integration
- **Markdown Files**: For user accessibility and external editing

This approach combines the benefits of structured data storage with the flexibility of markdown files, allowing users to edit their notes both within the app and using external tools like Obsidian.

## Table of Contents

1. [Architecture](#architecture)
2. [Data Model](#data-model)
3. [API Endpoints](#api-endpoints)
4. [File System Integration](#file-system-integration)
5. [Synchronization](#synchronization)
6. [Usage Examples](#usage-examples)
7. [Future Enhancements](#future-enhancements)

## Architecture

### Module Structure
```
backend/src/garden-notes/
├── entities/
│   └── garden-note.entity.ts
├── dto/
│   └── create-garden-note.dto.ts
├── garden-note.controller.ts
├── garden-note.service.ts
└── garden-note.module.ts
```

### Current Implementation
- **Database**: SQLite for structured storage
- **File System**: Markdown files in `garden notes` directory
- **Sync**: Real-time synchronization between database and files

## Data Model

### Current Entity
```typescript
@Entity()
export class GardenNote {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column()
  note: string;

  @Column({
    type: 'date',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  date: Date;
}
```

### Planned Enhancements
```typescript
@Entity()
export class GardenNote {
  // ... existing fields ...
  
  @Column({ nullable: true })
  plantId?: number;

  @Column({ nullable: true })
  plotId?: number;

  @Column('simple-array', { nullable: true })
  tags?: string[];

  @Column({ nullable: true })
  weather?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

## API Endpoints

### Current Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | `/garden-notes` | Create a new note |
| GET    | `/garden-notes` | List all notes |
| GET    | `/garden-notes/:id` | Get a specific note |
| PUT    | `/garden-notes/:id` | Update a note |
| DELETE | `/garden-notes/:id` | Delete a note |

### Planned Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/garden-notes/search` | Search notes with filters |
| GET    | `/garden-notes/by-plant/:plantId` | Get notes for a specific plant |
| GET    | `/garden-notes/by-plot/:plotId` | Get notes for a specific plot |
| GET    | `/garden-notes/by-date-range` | Get notes within a date range |

## File System Integration

### Current Implementation
- **Location**: `garden notes` directory
- **File Naming**: `<title>.md`
- **Content Format**:
  ```markdown
  # Title
  
  Note content
  ```

### Planned Enhancement
```markdown
---
date: 2024-05-01
tags: [planting, tomato]
plantId: 12
plotId: 3
weather: sunny
---

# Title

Note content
```

## Synchronization

### Current Implementation
- Uses `chokidar` for file system watching
- Automatic sync between files and database
- Basic error handling and logging

### Key Features
1. **File to Database Sync**
   - Watches for file changes
   - Updates corresponding database entries
   - Handles concurrent modifications

2. **Database to File Sync**
   - Creates/updates markdown files
   - Maintains consistent formatting
   - Preserves metadata

## Usage Examples

### Creating a Note via API
```json
POST /garden-notes
{
  "title": "First Tomato Planting",
  "note": "Planted tomatoes in Bed 2. Weather was sunny.",
  "date": "2024-05-01"
}
```

### Resulting Markdown File
```markdown
# First Tomato Planting

Planted tomatoes in Bed 2. Weather was sunny.
```

### External Editing
1. Open the `garden notes` directory in your preferred markdown editor
2. Edit or create `.md` files
3. Changes are automatically synced to the database

## Future Enhancements

1. **Version Control**
   - Git integration for note history
   - Branch support for different garden seasons

2. **Advanced Search**
   - Full-text search in markdown content
   - Semantic search for plant-related content

3. **Media Support**
   - Image attachments
   - Plant growth progress photos

4. **Export/Import**
   - Bulk export to markdown
   - Import from other garden apps

5. **Collaboration**
   - Shared notes between users
   - Comment system

## Technical Considerations

### Performance
- Efficient file watching with `chokidar`
- Indexed database queries
- Caching for frequently accessed notes

### Security
- Input validation via DTOs
- File path sanitization
- Rate limiting for API endpoints

### Error Handling
- Graceful handling of file system errors
- Database transaction management
- Conflict resolution for concurrent edits

## Contributing

When contributing to the Garden Notes feature:
1. Follow the existing dual-storage pattern
2. Maintain backward compatibility
3. Add appropriate tests
4. Update documentation

## Support

For issues or questions:
1. Check the error logs in the application
2. Verify file system permissions
3. Ensure the database is properly initialized
4. Contact the development team for assistance 