<script lang="ts">
  import { appStore } from '../stores/app';
  import type { GardenArea, Plot, Plant } from '../lib/types';
  import { onMount } from 'svelte';

  interface Props {
    areaId: string;
    onBack: () => void;
  }

  let { areaId, onBack }: Props = $props();

  let area: GardenArea | undefined = $state();
  let plots: Plot[] = $state([]);
  let showAddForm = false;
  let newPlotName = '';
  let newPlotWidth = 200;
  let newPlotHeight = 150;

  let showPlantPalette = false;
  let selectedPlotId: string | null = $state(null);

  onMount(() => {
    const unsub = appStore.subscribe((state) => {
      area = state.areas.find((a: GardenArea) => a.id === areaId);
      plots = state.plots.filter((p: Plot) => p.areaId === areaId);
    });
    return unsub;
  });

  function addPlot() {
    if (newPlotName.trim()) {
      appStore.addPlot(areaId, newPlotName.trim(), newPlotWidth, newPlotHeight);
      newPlotName = '';
      showAddForm = false;
    }
  }

  function deletePlot(id: string) {
    if (confirm('¿Eliminar esta parcela?')) {
      appStore.deletePlot(id);
    }
  }

  function openPlantPalette(plotId: string) {
    selectedPlotId = plotId;
    showPlantPalette = true;
  }

  function addPlant(plantId: string) {
    if (selectedPlotId) {
      const plot = plots.find((p) => p.id === selectedPlotId);
      if (plot) {
        appStore.addPlantToPlot(selectedPlotId, plantId, 20, 20);
      }
    }
    showPlantPalette = false;
  }
</script>

<div class="area-detail">
  <button class="back-btn" onclick={onBack}>← Volver</button>
  
  {#if area}
    <div class="header">
      <h1>{area.name}</h1>
      <button class="btn-primary" onclick={() => showAddForm = !showAddForm}>
        {showAddForm ? 'Cancelar' : '+ Nueva Parcela'}
      </button>
    </div>

    {#if showAddForm}
      <form class="add-form" onsubmit={(e) => { e.preventDefault(); addPlot(); }}>
        <input
          type="text"
          bind:value={newPlotName}
          placeholder="Nombre de la parcela..."
          class="input"
        />
        <div class="size-inputs">
          <label>
            Ancho:
            <input type="number" bind:value={newPlotWidth} min="50" max="1000" />
          </label>
          <label>
            Alto:
            <input type="number" bind:value={newPlotHeight} min="50" max="1000" />
          </label>
        </div>
        <button type="submit" class="btn-primary">Crear</button>
      </form>
    {/if}

    {#if plots.length === 0}
      <div class="empty">
        <p>No hay parcelas todavía.</p>
        <p>Crea una para diseñar tu jardín.</p>
      </div>
    {:else}
      <div class="plots-grid">
        {#each plots as plot}
          <div class="plot-card">
            <div class="plot-header">
              <h3>{plot.name}</h3>
              <div class="plot-actions">
                <button class="btn-small" onclick={() => openPlantPalette(plot.id)}>
                  + Planta
                </button>
                <button class="btn-delete" onclick={() => deletePlot(plot.id)}>
                  Eliminar
                </button>
              </div>
            </div>
            <div class="plot-canvas" style="width: {plot.width}px; height: {plot.height}px;">
              {#each plot.plants as placedPlant}
                {@const plant = $appStore.plants.find((p: Plant) => p.id === placedPlant.plantId)}
                {#if plant}
                  <div
                    class="plant-item"
                    style="left: {placedPlant.x}px; top: {placedPlant.y}px; background: {plant.color};"
                    title={plant.name}
                  >
                    {plant.name.charAt(0)}
                  </div>
                {/if}
              {/each}
            </div>
            <p class="plot-info">{plot.plants.length} plantas</p>
          </div>
        {/each}
      </div>
    {/if}
  {:else}
    <p>Área no encontrada</p>
  {/if}
</div>

{#if showPlantPalette}
  <div class="modal-overlay" onclick={() => showPlantPalette = false}>
    <div class="modal" onclick={(e) => e.stopPropagation()}>
      <h2>Seleccionar Planta</h2>
      <div class="plant-grid">
        {#each $appStore.plants as plant}
          <button class="plant-option" onclick={() => addPlant(plant.id)}>
            <div class="plant-color" style="background: {plant.color};"></div>
            <span>{plant.name}</span>
          </button>
        {/each}
      </div>
      <button class="btn-cancel" onclick={() => showPlantPalette = false}>Cancelar</button>
    </div>
  </div>
{/if}

<style>
  .area-detail {
    max-width: 1200px;
    margin: 0 auto;
  }

  .back-btn {
    background: none;
    border: none;
    color: #2d5a27;
    cursor: pointer;
    font-size: 1rem;
    margin-bottom: 1rem;
    padding: 0.5rem 0;
  }

  .header {
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

  .add-form {
    display: flex;
    gap: 1rem;
    align-items: flex-end;
    margin-bottom: 1.5rem;
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

  .size-inputs {
    display: flex;
    gap: 1rem;
  }

  .size-inputs label {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    font-size: 0.875rem;
    color: #666;
  }

  .size-inputs input {
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 6px;
    width: 80px;
  }

  .empty {
    text-align: center;
    padding: 3rem;
    color: #666;
  }

  .plots-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.5rem;
  }

  .plot-card {
    background: white;
    border-radius: 12px;
    padding: 1rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }

  .plot-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  .plot-header h3 {
    margin: 0;
    color: #333;
  }

  .plot-actions {
    display: flex;
    gap: 0.5rem;
  }

  .btn-small {
    padding: 0.25rem 0.5rem;
    background: #2d5a27;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.875rem;
  }

  .btn-delete {
    padding: 0.25rem 0.5rem;
    background: #e74c3c;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.875rem;
  }

  .plot-canvas {
    background: #f5f5f0;
    border: 2px dashed #ccc;
    border-radius: 8px;
    position: relative;
    overflow: hidden;
    margin-bottom: 0.5rem;
  }

  .plant-item {
    position: absolute;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: bold;
    font-size: 0.875rem;
    cursor: move;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }

  .plot-info {
    color: #666;
    font-size: 0.875rem;
    margin: 0;
  }

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 100;
  }

  .modal {
    background: white;
    padding: 1.5rem;
    border-radius: 12px;
    max-width: 400px;
    width: 90%;
  }

  .modal h2 {
    margin: 0 0 1rem 0;
    color: #2d5a27;
  }

  .plant-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.5rem;
    margin-bottom: 1rem;
  }

  .plant-option {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem;
    background: #f5f5f0;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    text-align: left;
  }

  .plant-color {
    width: 24px;
    height: 24px;
    border-radius: 50%;
  }

  .btn-cancel {
    width: 100%;
    padding: 0.5rem;
    background: #ddd;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }
</style>
