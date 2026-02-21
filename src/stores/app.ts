import { writable } from 'svelte/store';
import type { AppState, GardenArea, Plot, Plant, Task, CalendarEvent } from './types';
import { v4 as uuid } from 'uuid';

const STORAGE_KEY = 'plantarium_data';

const defaultPlants: Plant[] = [
  { id: 'tomato', name: 'Tomate', color: '#e74c3c' },
  { id: 'lettuce', name: 'Lechuga', color: '#2ecc71' },
  { id: 'carrot', name: 'Zanahoria', color: '#e67e22' },
  { id: 'pepper', name: 'Pimiento', color: '#c0392b' },
  { id: 'onion', name: 'Cebolla', color: '#9b59b6' },
  { id: 'garlic', name: 'Ajo', color: '#f1c40f' },
  { id: 'bean', name: 'Frijol', color: '#27ae60' },
  { id: 'corn', name: 'Maíz', color: '#f39c12' },
  { id: 'potato', name: 'Papa', color: '#8b4513' },
  { id: 'spinach', name: 'Espinaca', color: '#1abc9c' },
];

function loadFromStorage(): AppState {
  if (typeof localStorage === 'undefined') {
    return getDefaultState();
  }
  
  try {
    const data = localStorage.getItem(STORAGE_KEY);
    if (data) {
      return JSON.parse(data);
    }
  } catch (e) {
    console.error('Error loading from localStorage:', e);
  }
  return getDefaultState();
}

function getDefaultState(): AppState {
  return {
    areas: [],
    plots: [],
    plants: defaultPlants,
    tasks: [],
    events: [],
  };
}

function createAppStore() {
  const { subscribe, set, update } = writable<AppState>(loadFromStorage());

  function saveToStorage(state: AppState) {
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    }
  }

  return {
    subscribe,

    addArea: (name: string) => {
      update(state => {
        const area: GardenArea = {
          id: uuid(),
          name,
          createdAt: Date.now(),
        };
        const newState = { ...state, areas: [...state.areas, area] };
        saveToStorage(newState);
        return newState;
      });
    },

    updateArea: (id: string, name: string) => {
      update(state => {
        const newState = {
          ...state,
          areas: state.areas.map(a => a.id === id ? { ...a, name } : a),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    deleteArea: (id: string) => {
      update(state => {
        const newState = {
          ...state,
          areas: state.areas.filter(a => a.id !== id),
          plots: state.plots.filter(p => p.areaId !== id),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    addPlot: (areaId: string, name: string, width: number, height: number) => {
      update(state => {
        const plot: Plot = {
          id: uuid(),
          areaId,
          name,
          width,
          height,
          plants: [],
        };
        const newState = { ...state, plots: [...state.plots, plot] };
        saveToStorage(newState);
        return newState;
      });
    },

    updatePlot: (id: string, updates: Partial<Plot>) => {
      update(state => {
        const newState = {
          ...state,
          plots: state.plots.map(p => p.id === id ? { ...p, ...updates } : p),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    deletePlot: (id: string) => {
      update(state => {
        const newState = {
          ...state,
          plots: state.plots.filter(p => p.id !== id),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    addPlantToPlot: (plotId: string, plantId: string, x: number, y: number) => {
      update(state => {
        const newState = {
          ...state,
          plots: state.plots.map(p => {
            if (p.id === plotId) {
              return {
                ...p,
                plants: [...p.plants, { id: uuid(), plantId, x, y }],
              };
            }
            return p;
          }),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    updatePlantPosition: (plotId: string, placedPlantId: string, x: number, y: number) => {
      update(state => {
        const newState = {
          ...state,
          plots: state.plots.map(p => {
            if (p.id === plotId) {
              return {
                ...p,
                plants: p.plants.map(plant =>
                  plant.id === placedPlantId ? { ...plant, x, y } : plant
                ),
              };
            }
            return p;
          }),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    removePlantFromPlot: (plotId: string, placedPlantId: string) => {
      update(state => {
        const newState = {
          ...state,
          plots: state.plots.map(p => {
            if (p.id === plotId) {
              return {
                ...p,
                plants: p.plants.filter(plant => plant.id !== placedPlantId),
              };
            }
            return p;
          }),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    addTask: (title: string, date: string, type: Task['type']) => {
      update(state => {
        const task: Task = {
          id: uuid(),
          title,
          date,
          type,
          completed: false,
        };
        const newState = { ...state, tasks: [...state.tasks, task] };
        saveToStorage(newState);
        return newState;
      });
    },

    toggleTask: (id: string) => {
      update(state => {
        const newState = {
          ...state,
          tasks: state.tasks.map(t => t.id === id ? { ...t, completed: !t.completed } : t),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    deleteTask: (id: string) => {
      update(state => {
        const newState = {
          ...state,
          tasks: state.tasks.filter(t => t.id !== id),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    addEvent: (title: string, date: string, type: string) => {
      update(state => {
        const event: CalendarEvent = {
          id: uuid(),
          title,
          date,
          type,
        };
        const newState = { ...state, events: [...state.events, event] };
        saveToStorage(newState);
        return newState;
      });
    },

    deleteEvent: (id: string) => {
      update(state => {
        const newState = {
          ...state,
          events: state.events.filter(e => e.id !== id),
        };
        saveToStorage(newState);
        return newState;
      });
    },

    reset: () => {
      const newState = getDefaultState();
      saveToStorage(newState);
      set(newState);
    },
  };
}

export const appStore = createAppStore();
