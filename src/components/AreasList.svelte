<script lang="ts">
  import { appStore } from '../stores/app';
  import type { Plot } from '../lib/types';

  interface Props {
    onSelectArea: (id: string) => void;
  }

  let { onSelectArea }: Props = $props();

  let newAreaName = '';
  let showForm = false;

  function addArea() {
    if (newAreaName.trim()) {
      appStore.addArea(newAreaName.trim());
      newAreaName = '';
      showForm = false;
    }
  }

  function deleteArea(id: string) {
    if (confirm('¿Eliminar esta área y todas sus parcelas?')) {
      appStore.deleteArea(id);
    }
  }
</script>

<div class="areas-list">
  <div class="header-row">
    <h1>Áreas de Jardín</h1>
    <button class="btn-primary" onclick={() => showForm = !showForm}>
      {showForm ? 'Cancelar' : '+ Nueva Área'}
    </button>
  </div>

  {#if showForm}
    <form class="add-form" onsubmit={(e) => { e.preventDefault(); addArea(); }}>
      <input
        type="text"
        bind:value={newAreaName}
        placeholder="Nombre del área..."
        class="input"
      />
      <button type="submit" class="btn-primary">Crear</button>
    </form>
  {/if}

  {#if $appStore.areas.length === 0}
    <div class="empty">
      <p>No hay áreas todavía.</p>
      <p>Crea una para comenzar a planificar tu jardín.</p>
    </div>
  {:else}
    <div class="grid">
      {#each $appStore.areas as area}
        <div class="area-card">
          <div class="area-info">
            <h3>{area.name}</h3>
            <p class="plots-count">
              {$appStore.plots.filter((p: Plot) => p.areaId === area.id).length} parcelas
            </p>
          </div>
          <div class="area-actions">
            <button class="btn-select" onclick={() => onSelectArea(area.id)}>
              Ver parcelas
            </button>
            <button class="btn-delete" onclick={() => deleteArea(area.id)}>
              Eliminar
            </button>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .areas-list {
    max-width: 800px;
    margin: 0 auto;
  }

  .header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
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

  .btn-primary:hover {
    background: #3d7a37;
  }

  .add-form {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
    padding: 1rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  .input {
    flex: 1;
    padding: 0.5rem 0.75rem;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 1rem;
  }

  .empty {
    text-align: center;
    padding: 3rem;
    color: #666;
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1rem;
  }

  .area-card {
    background: white;
    border-radius: 12px;
    padding: 1.25rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .area-info h3 {
    margin: 0 0 0.25rem 0;
    color: #333;
  }

  .plots-count {
    color: #666;
    font-size: 0.875rem;
    margin: 0;
  }

  .area-actions {
    display: flex;
    gap: 0.5rem;
  }

  .btn-select {
    flex: 1;
    padding: 0.5rem;
    background: #2d5a27;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }

  .btn-select:hover {
    background: #3d7a37;
  }

  .btn-delete {
    padding: 0.5rem;
    background: #e74c3c;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }

  .btn-delete:hover {
    background: #c0392b;
  }
</style>
