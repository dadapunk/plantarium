<script lang="ts">
  import { appStore } from '../stores/app';
  import type { Task } from '../lib/types';

  let showAddForm = false;
  let newTaskTitle = '';
  let newTaskDate = '';
  let newTaskType: Task['type'] = 'custom';
  let filter: 'all' | 'pending' | 'completed' = 'all';

  function addTask() {
    if (newTaskTitle.trim() && newTaskDate) {
      appStore.addTask(newTaskTitle.trim(), newTaskDate, newTaskType);
      newTaskTitle = '';
      newTaskDate = '';
      newTaskType = 'custom';
      showAddForm = false;
    }
  }

  function toggleTask(id: string) {
    appStore.toggleTask(id);
  }

  function deleteTask(id: string) {
    appStore.deleteTask(id);
  }

  function getTypeLabel(type: Task['type']): string {
    const labels: Record<Task['type'], string> = {
      sowing: 'Siembra',
      watering: 'Riego',
      harvest: 'Cosecha',
      fertilizing: 'Fertilización',
      custom: 'Otro',
    };
    return labels[type];
  }

  function getTypeColor(type: Task['type']): string {
    const colors: Record<Task['type'], string> = {
      sowing: '#2ecc71',
      watering: '#3498db',
      harvest: '#e67e22',
      fertilizing: '#9b59b6',
      custom: '#95a5a6',
    };
    return colors[type];
  }

  let filteredTasks = $derived(() => {
    const tasks: Task[] = $appStore.tasks;
    if (filter === 'pending') return tasks.filter((t: Task) => !t.completed);
    if (filter === 'completed') return tasks.filter((t: Task) => t.completed);
    return tasks;
  });
</script>

<div class="tasks">
  <div class="header">
    <h1>Tareas</h1>
    <button class="btn-primary" onclick={() => showAddForm = !showAddForm}>
      {showAddForm ? 'Cancelar' : '+ Nueva Tarea'}
    </button>
  </div>

  {#if showAddForm}
    <form class="add-form" onsubmit={(e) => { e.preventDefault(); addTask(); }}>
      <input
        type="text"
        bind:value={newTaskTitle}
        placeholder="Título de la tarea..."
        class="input"
      />
      <input
        type="date"
        bind:value={newTaskDate}
        class="input"
      />
      <select bind:value={newTaskType} class="input">
        <option value="sowing">Siembra</option>
        <option value="watering">Riego</option>
        <option value="harvest">Cosecha</option>
        <option value="fertilizing">Fertilización</option>
        <option value="custom">Otro</option>
      </select>
      <button type="submit" class="btn-primary">Crear</button>
    </form>
  {/if}

  <div class="filters">
    <button class="filter-btn" class:active={filter === 'all'} onclick={() => filter = 'all'}>
      Todas
    </button>
    <button class="filter-btn" class:active={filter === 'pending'} onclick={() => filter = 'pending'}>
      Pendientes
    </button>
    <button class="filter-btn" class:active={filter === 'completed'} onclick={() => filter = 'completed'}>
      Completadas
    </button>
  </div>

  {#if filteredTasks().length === 0}
    <div class="empty">
      <p>No hay tareas.</p>
      <p>Crea una tarea para mantenerte organizado.</p>
    </div>
  {:else}
    <div class="task-list">
      {#each filteredTasks() as task}
        <div class="task-item" class:completed={task.completed}>
          <button class="checkbox" onclick={() => toggleTask(task.id)}>
            {#if task.completed}✓{/if}
          </button>
          <div class="task-info">
            <span class="task-title">{task.title}</span>
            <div class="task-meta">
              <span class="task-date">{new Date(task.date).toLocaleDateString('es-ES')}</span>
              <span class="task-type" style="background: {getTypeColor(task.type)};">
                {getTypeLabel(task.type)}
              </span>
            </div>
          </div>
          <button class="btn-delete" onclick={() => deleteTask(task.id)}>×</button>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .tasks {
    max-width: 600px;
    margin: 0 auto;
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  h1 {
    font-size: 1.75rem;
    color: #2d5a27;
  }

  .btn-primary {
    padding: 0.5rem 1rem;
    background: #2d5a27;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
  }

  .add-form {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
    padding: 1rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    flex-wrap: wrap;
  }

  .input {
    padding: 0.5rem 0.75rem;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 1rem;
  }

  .filters {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
  }

  .filter-btn {
    padding: 0.5rem 1rem;
    background: white;
    border: 1px solid #ddd;
    border-radius: 6px;
    cursor: pointer;
    color: #666;
  }

  .filter-btn.active {
    background: #2d5a27;
    color: white;
    border-color: #2d5a27;
  }

  .empty {
    text-align: center;
    padding: 3rem;
    color: #666;
  }

  .task-list {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .task-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  }

  .task-item.completed {
    opacity: 0.6;
  }

  .task-item.completed .task-title {
    text-decoration: line-through;
  }

  .checkbox {
    width: 24px;
    height: 24px;
    border: 2px solid #2d5a27;
    border-radius: 4px;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #2d5a27;
    font-weight: bold;
  }

  .task-info {
    flex: 1;
  }

  .task-title {
    display: block;
    font-weight: 500;
    color: #333;
  }

  .task-meta {
    display: flex;
    gap: 0.5rem;
    margin-top: 0.25rem;
  }

  .task-date {
    font-size: 0.75rem;
    color: #666;
  }

  .task-type {
    font-size: 0.75rem;
    color: white;
    padding: 0.125rem 0.5rem;
    border-radius: 3px;
  }

  .btn-delete {
    padding: 0.25rem 0.5rem;
    background: #e74c3c;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
  }
</style>
