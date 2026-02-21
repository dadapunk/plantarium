<script lang="ts">
  import AreasList from './components/AreasList.svelte';
  import AreaDetail from './components/AreaDetail.svelte';
  import Calendar from './components/Calendar.svelte';
  import Tasks from './components/Tasks.svelte';

  let currentView: 'areas' | 'area' | 'calendar' | 'tasks' = 'areas';
  let selectedAreaId: string | null = null;

  function goToAreas() {
    currentView = 'areas';
    selectedAreaId = null;
  }

  function goToArea(id: string) {
    selectedAreaId = id;
    currentView = 'area';
  }

  function goToCalendar() {
    currentView = 'calendar';
  }

  function goToTasks() {
    currentView = 'tasks';
  }
</script>

<div class="app">
  <header class="header">
    <button class="logo" onclick={goToAreas}>🌱 Plantarium</button>
    <nav class="nav">
      <button class="nav-btn" class:active={currentView === 'areas' || currentView === 'area'} onclick={goToAreas}>
        Parcelas
      </button>
      <button class="nav-btn" class:active={currentView === 'calendar'} onclick={goToCalendar}>
        Calendario
      </button>
      <button class="nav-btn" class:active={currentView === 'tasks'} onclick={goToTasks}>
        Tareas
      </button>
    </nav>
  </header>

  <main class="main">
    {#if currentView === 'areas'}
      <AreasList onSelectArea={goToArea} />
    {:else if currentView === 'area' && selectedAreaId}
      <AreaDetail areaId={selectedAreaId} onBack={goToAreas} />
    {:else if currentView === 'calendar'}
      <Calendar />
    {:else if currentView === 'tasks'}
      <Tasks />
    {/if}
  </main>
</div>

<style>
  .app {
    display: flex;
    flex-direction: column;
    height: 100vh;
    background: #f5f5f0;
  }

  .header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.75rem 1.5rem;
    background: #2d5a27;
    color: white;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  }

  .logo {
    font-size: 1.5rem;
    font-weight: 700;
    background: none;
    border: none;
    color: white;
    cursor: pointer;
  }

  .nav {
    display: flex;
    gap: 0.5rem;
  }

  .nav-btn {
    padding: 0.5rem 1rem;
    background: rgba(255, 255, 255, 0.1);
    border: none;
    border-radius: 6px;
    color: white;
    cursor: pointer;
    transition: background 0.2s;
  }

  .nav-btn:hover {
    background: rgba(255, 255, 255, 0.2);
  }

  .nav-btn.active {
    background: rgba(255, 255, 255, 0.25);
  }

  .main {
    flex: 1;
    overflow: auto;
    padding: 1.5rem;
  }
</style>
