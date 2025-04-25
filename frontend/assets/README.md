# Assets Directory Structure

This directory contains all the static assets used in the Plantarium application.

## Directory Structure

```
assets/
├── images/
│   ├── plants/       # Plant-related images and photos
│   ├── backgrounds/  # Background images and patterns
│   └── logos/        # Application logos and branding
├── fonts/           # Custom fonts
└── icons/           # Custom icons and SVG files
```

## Usage Guidelines

### Images
- Place plant-related images in `images/plants/`
- Store background images and patterns in `images/backgrounds/`
- Keep all branding and logo files in `images/logos/`
- Use PNG format for images with transparency
- Use JPG format for photos and complex images
- Optimize all images for size before adding

### Fonts
- Store font files in `fonts/` directory
- Include all font weights and styles needed
- Update pubspec.yaml when adding new fonts

### Icons
- Store custom icons in `icons/` directory
- Prefer SVG format for scalable icons
- Follow a consistent naming convention

## Adding New Assets

1. Place the asset in the appropriate directory
2. Update pubspec.yaml if needed
3. Run `flutter pub get` to update dependencies
4. Reference the asset using the correct path in the code

## Best Practices

1. Keep file names lowercase and use underscores
2. Optimize assets for size before adding
3. Document any special usage requirements
4. Remove unused assets regularly 