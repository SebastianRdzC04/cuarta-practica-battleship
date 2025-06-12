<template>
  <div class="min-h-screen bg-[#001428] font-pixel relative overflow-hidden p-4">
    <!-- Overlay con efecto escaneo -->
    <div class="absolute inset-0 pointer-events-none animate-moveLines overlay"></div>

    <!-- Título del juego -->
    <h1 class="text-center text-4xl text-[#00FF00] mb-6 tracking-widest animate-pulse" 
        style="text-shadow: 5px 5px 0px #00334d, -2px -2px 0px #00FFFF;">
      BATALLA NAVAL
    </h1>

    <!-- Contenedor VS -->
    <div class="w-full max-w-7xl mx-auto">
      <!-- Banner VS -->
      <div class="relative flex justify-center items-center my-4">
        <div class="absolute w-32 h-32 bg-[#00FF00] rounded-full opacity-25 animate-ping"></div>
        <span class="text-5xl text-[#FF0000] font-bold z-10 animate-blink" 
              style="text-shadow: 3px 3px 0px #00334d, -1px -1px 0px #FFFFFF;">
          VS
        </span>
      </div>

      <!-- Paneles de jugadores -->
      <div class="flex flex-col md:flex-row justify-between gap-8">
        <!-- Panel jugador -->
        <div class="flex-1 border-4 border-[#00FF00] bg-[#00112b] p-5 shadow-[0_0_20px_rgba(0,255,0,0.4)]"
             style="border-image: repeating-linear-gradient(45deg, #00FF00, #00FF00 10px, #007700 10px, #007700 20px) 8;">
          <div class="text-center mb-4">
            <h2 class="text-2xl text-[#00FF00] mb-1">JUGADOR</h2>
            <div class="w-full h-1 bg-[#00FF00]"></div>
          </div>
          
          <div class="player-avatar mx-auto my-4 w-24 h-24 bg-[#004400] border-2 border-[#00FF00] overflow-hidden relative">
            <div class="w-10 h-10 absolute top-6 left-7 bg-[#00FF00] rounded-full"></div>
            <div class="w-16 h-8 absolute bottom-2 left-4 bg-[#00FF00] rounded-t-full"></div>
          </div>

          <div class="stats text-[#00FF00] space-y-3 mt-6">
            <div class="flex justify-between items-center border-b border-dashed border-[#007700] pb-1">
              <span>NOMBRE:</span>
              <input v-model="playerName" 
                     class="bg-[#00334d] text-[#00FF00] border border-[#00FF00] px-2 max-w-[150px] font-pixel text-right" />
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#007700] pb-1">
              <span>VICTORIAS:</span>
              <span>{{ playerStats.wins }}</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#007700] pb-1">
              <span>DERROTAS:</span>
              <span>{{ playerStats.losses }}</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#007700] pb-1">
              <span>PRECISIÓN:</span>
              <span>{{ playerStats.accuracy }}%</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#007700] pb-1">
              <span>BARCOS:</span>
              <div class="flex space-x-1">
                <div v-for="i in 5" :key="`player-ship-${i}`" class="w-3 h-3 bg-[#00FF00]"></div>
              </div>
            </div>
          </div>
          
          <div class="mt-6 text-center">
            <button class="bg-[#00334d] text-[#00FF00] border-2 border-[#00FF00] font-pixel py-2 px-4 cursor-pointer transition-all duration-200 hover:bg-[#004d73] hover:-translate-y-0.5 hover:shadow-[0_5px_0px_#003300] active:translate-y-0.5 active:shadow-none"
                    style="text-shadow: 1px 1px #003300; box-shadow: 0 3px 0px #003300;">
              LISTO
            </button>
          </div>
        </div>

        <!-- Panel oponente -->
        <div class="flex-1 border-4 border-[#FF0000] bg-[#120011] p-5 shadow-[0_0_20px_rgba(255,0,0,0.3)]"
             style="border-image: repeating-linear-gradient(45deg, #FF0000, #FF0000 10px, #770000 10px, #770000 20px) 8;">
          <div class="text-center mb-4">
            <h2 class="text-2xl text-[#FF0000] mb-1">OPONENTE</h2>
            <div class="w-full h-1 bg-[#FF0000]"></div>
          </div>
          
          <div class="opponent-avatar mx-auto my-4 w-24 h-24 bg-[#440000] border-2 border-[#FF0000] overflow-hidden animate-pulse-slow opacity-50 flex justify-center items-center">
            <span class="text-[#FF0000] text-xs text-center">ESPERANDO <br> OPONENTE</span>
          </div>

          <div class="stats text-[#FF0000] space-y-3 mt-6">
            <div class="flex justify-between items-center border-b border-dashed border-[#770000] pb-1">
              <span>NOMBRE:</span>
              <span>???</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#770000] pb-1">
              <span>VICTORIAS:</span>
              <span>???</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#770000] pb-1">
              <span>DERROTAS:</span>
              <span>???</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#770000] pb-1">
              <span>PRECISIÓN:</span>
              <span>???</span>
            </div>
            <div class="flex justify-between items-center border-b border-dashed border-[#770000] pb-1">
              <span>BARCOS:</span>
              <div class="flex space-x-1">
                <div v-for="i in 5" :key="`opponent-ship-${i}`" class="w-3 h-3 bg-[#330000]"></div>
              </div>
            </div>
          </div>
          
          <div class="mt-6 text-center">
            <div class="bg-[#330000] text-[#770000] border-2 border-[#770000] font-pixel py-2 px-4 opacity-50 cursor-not-allowed">
              ESPERANDO
            </div>
          </div>
        </div>
      </div>

      <!-- Botón para iniciar -->
      <div class="text-center mt-10">
        <button @click="startGame" 
                class="bg-[#00334d] text-[#00FF00] border-3 border-[#00FF00] font-pixel py-4 px-8 text-base cursor-pointer transition-all duration-200 hover:bg-[#004d73] hover:-translate-x-0.5 hover:-translate-y-0.5 hover:shadow-[7px_7px_0px_#003300] active:translate-x-0.5 active:translate-y-0.5 active:shadow-[3px_3px_0px_#003300]"
                style="text-shadow: 2px 2px #003300; box-shadow: 5px 5px 0px #003300;"
                :disabled="!playerName.trim()">
          INICIAR BATALLA
        </button>
      </div>
      
      <!-- Pie de página -->
      <div class="text-center mt-8 text-[8px] text-[#007700]">
        BATALLA NAVAL RETRO - PREPARADO PARA COMBATE
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Index',
  data() {
    return {
      playerName: '',
      playerStats: {
        wins: 0,
        losses: 0,
        accuracy: 0
      }
    }
  },
  methods: {
    startGame() {
      if (!this.playerName.trim()) {
        return;
      }
      
      console.log('Iniciando batalla...');
      // Aquí iría la lógica para iniciar la partida
    }
  }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');

.font-pixel {
  font-family: 'Press Start 2P', cursive;
}

.overlay {
  background: repeating-linear-gradient(
    180deg,
    rgba(0, 0, 0, 0) 0,
    rgba(0, 0, 0, 0.1) 1px,
    rgba(0, 0, 0, 0) 2px
  );
}

/* Animaciones */
@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes pulse-slow {
  0% { opacity: 0.4; }
  50% { opacity: 0.6; }
  100% { opacity: 0.4; }
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

@keyframes moveLines {
  from { background-position: 0 0; }
  to { background-position: 0 100%; }
}

.animate-pulse {
  animation: pulse 2s infinite;
}

.animate-pulse-slow {
  animation: pulse-slow 4s infinite;
}

.animate-blink {
  animation: blink 1s infinite;
}

.animate-moveLines {
  animation: moveLines 6s linear infinite;
}

/* Inputs */
input {
  outline: none;
  font-size: 12px;
}

/* Responsiveness */
@media (max-width: 768px) {
  .text-4xl {
    font-size: 1.5rem;
  }
  
  .text-2xl {
    font-size: 1rem;
  }
}
</style>