<script lang="ts">
  import { appStore } from '../stores/app';
  import type { CalendarEvent } from '../lib/types';

  let currentDate = $state(new Date());
  let showAddEvent = false;
  let newEventTitle = '';
  let newEventDate = '';
  let newEventType = 'sowing';

  const weekDays = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  function getDaysInMonth(date: Date): (Date | null)[] {
    const year = date.getFullYear();
    const month = date.getMonth();
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    
    const days: (Date | null)[] = [];
    
    for (let i = 0; i < firstDay.getDay(); i++) {
      days.push(null);
    }
    
    for (let i = 1; i <= lastDay.getDate(); i++) {
      days.push(new Date(year, month, i));
    }
    
    return days;
  }

  function prevMonth() {
    currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
  }

  function nextMonth() {
    currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
  }

  function getEventsForDay(date: Date) {
    const dateStr = date.toISOString().split('T')[0];
    return $appStore.events.filter((e: CalendarEvent) => e.date === dateStr);
  }

  function addEvent() {
    if (newEventTitle.trim() && newEventDate) {
      appStore.addEvent(newEventTitle.trim(), newEventDate, newEventType);
      newEventTitle = '';
      newEventDate = '';
      newEventType = 'sowing';
      showAddEvent = false;
    }
  }

  function deleteEvent(id: string) {
    appStore.deleteEvent(id);
  }

  let days = $derived(getDaysInMonth(currentDate));
  let monthName = $derived(currentDate.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' }));
</script>

<div class="calendar">
  <div class="header">
    <h1>Calendario</h1>
    <button class="btn-primary" onclick={() => showAddEvent = !showAddEvent}>
      {showAddEvent ? 'Cancelar' : '+ Nuevo Evento'}
    </button>
  </div>

  {#if showAddEvent}
    <form class="add-form" onsubmit={(e) => { e.preventDefault(); addEvent(); }}>
      <input
        type="text"
        bind:value={newEventTitle}
        placeholder="Título del evento..."
        class="input"
      />
      <input
        type="date"
        bind:value={newEventDate}
        class="input"
      />
      <select bind:value={newEventType} class="input">
        <option value="sowing">Siembra</option>
        <option value="watering">Riego</option>
        <option value="harvest">Cosecha</option>
        <option value="fertilizing">Fertilización</option>
        <option value="custom">Otro</option>
      </select>
      <button type="submit" class="btn-primary">Crear</button>
    </form>
  {/if}

  <div class="calendar-nav">
    <button class="nav-btn" onclick={prevMonth}>←</button>
    <h2>{monthName}</h2>
    <button class="nav-btn" onclick={nextMonth}>→</button>
  </div>

  <div class="calendar-grid">
    {#each weekDays as day}
      <div class="day-header">{day}</div>
    {/each}
    
    {#each days as day}
      {#if day}
        {@const events = getEventsForDay(day)}
        <div class="day-cell">
          <span class="day-number">{day.getDate()}</span>
          {#each events as event}
            <div class="event" onclick={() => deleteEvent(event.id)} title="Clic para eliminar">
              {event.title}
            </div>
          {/each}
        </div>
      {:else}
        <div class="day-cell empty"></div>
      {/if}
    {/each}
  </div>
</div>

<style>
  .calendar {
    max-width: 900px;
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

  .calendar-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  .calendar-nav h2 {
    font-size: 1.25rem;
    color: #333;
    text-transform: capitalize;
  }

  .nav-btn {
    padding: 0.5rem 1rem;
    background: white;
    border: 1px solid #ddd;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1.25rem;
  }

  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 1px;
    background: #ddd;
    border: 1px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
  }

  .day-header {
    background: #2d5a27;
    color: white;
    padding: 0.5rem;
    text-align: center;
    font-weight: 500;
  }

  .day-cell {
    background: white;
    min-height: 80px;
    padding: 0.25rem;
  }

  .day-cell.empty {
    background: #f5f5f5;
  }

  .day-number {
    display: block;
    font-weight: 500;
    color: #333;
    margin-bottom: 0.25rem;
  }

  .event {
    background: #2d5a27;
    color: white;
    padding: 0.125rem 0.25rem;
    border-radius: 3px;
    font-size: 0.75rem;
    margin-bottom: 0.125rem;
    cursor: pointer;
  }

  .event:hover {
    background: #e74c3c;
  }
</style>
