---
sidebar_position: 3
---

# Quick Start Guide 🚀

Get up and running with Plantarium in minutes! This guide will walk you through the essential steps to start using Plantarium effectively.

## Step 1: Create Your First Garden

1. Click the "New Garden" button on the dashboard
2. Enter your garden's name and location
3. Select your garden type (vegetable, flower, herb, etc.)
4. Choose your garden size and layout preference

```dart
// Example garden creation
final garden = Garden(
  name: 'My First Garden',
  location: 'Backyard',
  type: GardenType.vegetable,
  size: Size(10, 15), // 10x15 feet
  layout: GardenLayout.grid
);
```

## Step 2: Add Plants to Your Garden

1. Browse the plant database or use the search function
2. Select plants suitable for your climate and season
3. Drag and drop plants onto your garden layout
4. Use the companion planting guide for optimal placement

```dart
// Example plant addition
final tomato = Plant(
  name: 'Tomato',
  variety: 'Cherry',
  spacing: Spacing(24, 36), // inches
  companionPlants: ['Basil', 'Marigold']
);

garden.addPlant(tomato, position: Point(2, 3));
```

## Step 3: Set Up Your Garden Calendar

1. Review the suggested planting schedule
2. Customize tasks and reminders
3. Set up weather alerts
4. Enable automatic watering reminders

```dart
// Example calendar setup
final calendar = GardenCalendar(
  startDate: DateTime.now(),
  tasks: [
    GardenTask(
      type: TaskType.planting,
      plant: tomato,
      date: DateTime.now().add(Duration(days: 7)),
      reminder: true
    )
  ]
);
```

## Step 4: Start Your Garden Journal

1. Create your first garden note
2. Add photos of your garden
3. Record observations and measurements
4. Track plant growth and health

```dart
// Example garden note
final note = GardenNote(
  title: 'First Planting Day',
  content: 'Planted tomatoes and basil today. Weather was perfect!',
  photos: ['planting_day_1.jpg'],
  tags: ['planting', 'tomatoes', 'basil']
);

garden.addNote(note);
```

## Essential Features to Try

### Garden Planning
- Use the drag-and-drop layout tool
- Get plant compatibility suggestions
- View 3D garden preview
- Print your garden plan

### Plant Care
- Set up watering reminders
- Track plant growth
- Record harvest dates
- Monitor plant health

### Weather Integration
- Get local weather forecasts
- Receive frost alerts
- Plan around weather conditions
- Track microclimate data

### Community Features
- Share your garden progress
- Ask questions in the forum
- Join local gardening groups
- Exchange tips and advice

## Tips for Success

1. **Start Small**: Begin with a few easy-to-grow plants
2. **Use the Calendar**: Stay on top of important tasks
3. **Take Notes**: Document your gardening journey
4. **Ask for Help**: Join the community for support

## Next Steps

Now that you're up and running, explore these advanced features:

- [Garden Layout System](../core-features/garden-layout)
- [Plant Database](../core-features/plant-database)
- [Weather Integration](../core-features/climate-weather)
- [Companion Planting](../core-features/companion-planting)

## Need Help?

- Check our [FAQ](../project-info/faq)
- Join our [Discord community](https://discord.gg/plantarium)
- Visit our [GitHub Discussions](https://github.com/plantarium/plantarium/discussions)

---

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <p>Ready to dive deeper?</p>
  <a href="../core-features" className="button button--primary button--lg">
    Explore Core Features
  </a>
</div> 