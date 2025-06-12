<template>
  <div class="min-h-screen bg-[#001428] font-pixel relative overflow-hidden p-4">
    <!-- Overlay con efecto escaneo -->
    <div class="absolute inset-0 pointer-events-none animate-moveLines overlay"></div>
    
    <!-- Encabezado -->
    <div class="flex justify-between items-center mb-4 px-2">
      <div class="text-[#00FF00]">
        <h1 class="text-2xl tracking-wider" style="text-shadow: 2px 2px 0px #00334d;">BATALLA NAVAL</h1>
      </div>
      <div class="text-[#FF0000] animate-blink">
        {{ isPlayerTurn ? 'TU TURNO' : 'TURNO ENEMIGO' }}
      </div>
      <div class="text-[#00FF00] text-sm">
        TIEMPO: {{ gameTime }}
      </div>
    </div>

    <!-- Contenedor principal con grid explícito y filas/columnas fijas -->
    <div class="fixed-height-container">
      <!-- COLUMNA IZQUIERDA: Historial de ataques -->
      <div class="grid-col-left">
        <div class="border-2 border-[#00FF00] bg-[#00112b] p-3 shadow-[0_0_10px_rgba(0,255,0,0.3)] h-full flex flex-col">
          <div class="flex justify-between items-center mb-2">
            <div class="text-[#00FF00] text-sm truncate">HISTORIAL</div>
            <div class="flex items-center">
              <span class="text-[#00FF00] text-xs">T: {{ turnCount }}</span>
            </div>
          </div>
          
          <!-- Contenedor de scroll con altura fija -->
          <div class="battle-log flex-grow overflow-y-auto overflow-x-hidden text-xs text-[#00AA00] p-2 bg-[#001800]">
            <p v-for="(log, index) in battleLogs" :key="index" class="mb-2 break-all">
              {{ log }}
            </p>
            <div ref="logEnd"></div>
          </div>
          
          <div class="flex justify-between items-center mt-2">
            <div class="text-[#00FF00] text-xs">HITS: {{ hits }}</div>
            <div class="text-[#00FF00] text-xs">{{ Math.round((hits / (turnCount-1)) * 100) || 0 }}%</div>
          </div>
        </div>
      </div>

      <!-- COLUMNA CENTRAL: Tablero enemigo grande -->
      <div class="grid-col-center">
        <!-- Tablero principal del enemigo -->
        <div class="border-4 border-[#FF0000] bg-[#120011] p-4 shadow-[0_0_15px_rgba(255,0,0,0.3)] h-full flex flex-col"
             style="border-image: repeating-linear-gradient(45deg, #FF0000, #FF0000 10px, #770000 10px, #770000 20px) 8;">
          <div class="flex justify-between items-center mb-3">
            <div class="text-[#FF0000] text-lg">RADAR ENEMIGO</div>
            <div class="flex items-center">
              <span class="text-[#FF0000] text-sm mr-2">BARCOS:</span>
              <div class="flex space-x-1">
                <div v-for="i in 5" :key="`enemy-ship-${i}`" 
                     :class="i <= enemyShipsRemaining ? 'bg-[#FF0000]' : 'bg-[#330000]'"
                     class="w-4 h-4"></div>
              </div>
            </div>
          </div>
          
          <div class="flex-grow flex justify-center items-center relative">
            <div v-if="!isPlayerTurn" class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center z-10">
              <span class="text-[#FF0000] text-3xl animate-blink">ESPERA TU TURNO</span>
            </div>
            <Board 
              :size="8" 
              :board="enemyBoard" 
              :is-mini="false" 
              :is-player-board="false"
              :disabled="!isPlayerTurn"
              :large="true"
              @cell-click="handleEnemyBoardClick" 
            />
          </div>
          
          <div class="mt-3 text-center">
            <div v-if="lastResult" :class="{
              'text-[#FF0000]': lastResult === 'miss',
              'text-[#00FF00]': lastResult === 'hit'
            }" class="text-xl animate-pulse">
              {{ lastResult === 'hit' ? '¡IMPACTO!' : 'AGUA...' }}
            </div>
          </div>
        </div>
      </div>

      <!-- COLUMNA DERECHA: Mini tablero del jugador y opciones -->
      <div class="grid-col-right">
        <div class="flex flex-col h-full gap-4">
          <!-- Información del jugador y mini tablero -->
          <div class="border-2 border-[#00FF00] bg-[#00112b] p-3 shadow-[0_0_10px_rgba(0,255,0,0.3)]">
            <div class="text-[#00FF00] mb-2 text-center font-bold truncate">{{ playerName }}</div>
            <div class="flex justify-between text-xs text-[#00FF00] mb-1">
              <span>BARCOS:</span>
              <span>{{ playerShipsRemaining }}/5</span>
            </div>
            <div class="w-full h-2 bg-[#003300] mb-3">
              <div class="h-full bg-[#00FF00]" :style="{ width: playerShipsRemaining * 20 + '%' }"></div>
            </div>
            
            <div class="text-center text-[#00FF00] text-xs mb-2">TU FLOTA</div>
            <div class="flex justify-center">
              <Board 
                :size="8" 
                :board="playerBoard" 
                :is-mini="true" 
                :is-player-board="true"
                @cell-click="handlePlayerBoardClick" 
              />
            </div>
          </div>
          
          <!-- Opciones de juego -->
          <div class="border-2 border-[#00FF00] bg-[#00112b] p-3 shadow-[0_0_10px_rgba(0,255,0,0.3)] flex-grow overflow-y-auto">
            <div class="text-center text-[#00FF00] text-xs mb-3">OPCIONES</div>
            <ul class="space-y-2">
              <li>
                <button @click="surrender" 
                        class="w-full bg-[#330000] text-[#FF0000] border border-[#FF0000] py-2 px-2 text-xs mb-1 hover:bg-[#550000] transition-colors truncate">
                  RENDIRSE
                </button>
              </li>
              <li>
                <button class="w-full bg-[#00334d] text-[#00FF00] border border-[#00FF00] py-2 px-2 text-xs mb-1 hover:bg-[#004d73] transition-colors truncate">
                  NUEVO OPONENTE
                </button>
              </li>
              <li>
                <button class="w-full bg-[#00334d] text-[#00FF00] border border-[#00FF00] py-2 px-2 text-xs mb-1 hover:bg-[#004d73] transition-colors truncate">
                  REINICIAR
                </button>
              </li>
              <li>
                <button class="w-full bg-[#00334d] text-[#00FF00] border border-[#00FF00] py-2 px-2 text-xs mb-1 hover:bg-[#004d73] transition-colors truncate">
                  AYUDA
                </button>
              </li>
              <li>
                <button class="w-full bg-[#00334d] text-[#00FF00] border border-[#00FF00] py-2 px-2 text-xs mb-1 hover:bg-[#004d73] transition-colors truncate">
                  SALIR
                </button>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Board from '@/Components/Board.vue';

export default {
  name: 'Game',
  components: {
    Board
  },
  data() {
    return {
      playerName: 'ALMIRANTE',
      playerBoard: Array(8).fill().map(() => Array(8).fill({ state: 'empty' })),
      enemyBoard: Array(8).fill().map(() => Array(8).fill({ state: 'empty' })),
      playerShipsRemaining: 5,
      enemyShipsRemaining: 5,
      isPlayerTurn: true,
      turnCount: 1,
      gameTime: '00:00',
      hits: 0,
      lastResult: null,
      timer: null,
      seconds: 0,
      battleLogs: [
        '» BATALLA INICIADA',
        '» COLOCA TUS BARCOS',
        '» ESPERA EL DESPLIEGUE ENEMIGO'
      ]
    };
  },
  mounted() {
    this.startTimer();
    this.initializeBoards();

    // Scroll al final de los logs
    this.$nextTick(() => {
      this.scrollToEndOfLogs();
    });
  },
  beforeUnmount() {
    clearInterval(this.timer);
  },
  methods: {
    initializeBoards() {
      // Colocando naves del jugador como ejemplo
      // (en un juego real, el jugador las colocaría)
      const playerShips = [
        [0, 0], [0, 1], [0, 2],  // Barco 1
        [2, 3], [3, 3],          // Barco 2
        [5, 2], [5, 3], [5, 4],  // Barco 3
        [7, 6],                  // Barco 4
        [2, 7], [3, 7], [4, 7]   // Barco 5
      ];
      
      playerShips.forEach(([row, col]) => {
        this.playerBoard[row][col] = { state: 'ship' };
      });

      // Simulando naves enemigas ocultas
      const enemyShips = [
        [1, 1], [1, 2], [1, 3],  // Barco 1
        [3, 4], [4, 4],          // Barco 2
        [6, 0], [6, 1], [6, 2],  // Barco 3
        [4, 6],                  // Barco 4
        [0, 5], [0, 6], [0, 7]   // Barco 5
      ];

      // En realidad no mostraríamos estas posiciones al jugador
      enemyShips.forEach(([row, col]) => {
        this.enemyBoard[row][col] = { state: 'hidden-ship' };
      });
      
      this.addBattleLog('» TODOS LOS BARCOS DESPLEGADOS');
      this.addBattleLog('» COMIENZA LA BATALLA');
    },
    handlePlayerBoardClick(row, col) {
      // Puede ser útil para colocar barcos inicialmente
      console.log(`Clic en tablero del jugador: ${row}, ${col}`);
    },
    handleEnemyBoardClick(row, col) {
      if (!this.isPlayerTurn) return;
      
      const cell = this.enemyBoard[row][col];
      
      // Evitar disparar dos veces al mismo lugar
      if (cell.state === 'hit' || cell.state === 'miss') {
        return;
      }
      
      // Comprobar si hay un barco
      if (cell.state === 'hidden-ship') {
        this.enemyBoard[row][col] = { state: 'hit' };
        this.hits++;
        this.enemyShipsRemaining--;
        this.lastResult = 'hit';
        this.addBattleLog(`» ¡IMPACTO CONFIRMADO EN [${String.fromCharCode(65 + col)}${row + 1}]!`);
        
        // Comprobar victoria
        if (this.enemyShipsRemaining === 0) {
          this.gameOver(true);
          return;
        }
      } else {
        this.enemyBoard[row][col] = { state: 'miss' };
        this.lastResult = 'miss';
        this.addBattleLog(`» Disparo fallido en [${String.fromCharCode(65 + col)}${row + 1}]`);
      }
      
      // Cambiar turno
      this.isPlayerTurn = false;
      setTimeout(this.enemyTurn, 1500);
    },
    enemyTurn() {
      // Simular ataque enemigo
      let row, col;
      let validMove = false;
      
      while (!validMove) {
        row = Math.floor(Math.random() * 8);
        col = Math.floor(Math.random() * 8);
        
        const cell = this.playerBoard[row][col];
        if (cell.state !== 'hit' && cell.state !== 'miss') {
          validMove = true;
        }
      }
      
      if (this.playerBoard[row][col].state === 'ship') {
        this.playerBoard[row][col] = { state: 'hit' };
        this.playerShipsRemaining--;
        this.addBattleLog(`» ¡IMPACTO ENEMIGO EN [${String.fromCharCode(65 + col)}${row + 1}]!`);
        
        // Comprobar derrota
        if (this.playerShipsRemaining === 0) {
          this.gameOver(false);
          return;
        }
      } else {
        this.playerBoard[row][col] = { state: 'miss' };
        this.addBattleLog(`» Ataque enemigo fallido en [${String.fromCharCode(65 + col)}${row + 1}]`);
      }
      
      this.turnCount++;
      this.isPlayerTurn = true;
    },
    surrender() {
      if (confirm("¿Estás seguro que deseas rendirte?")) {
        this.gameOver(false);
      }
    },
    gameOver(playerWon) {
      clearInterval(this.timer);
      if (playerWon) {
        this.addBattleLog('» ¡VICTORIA! TODOS LOS BARCOS ENEMIGOS DESTRUIDOS');
        alert("¡VICTORIA! Has hundido todos los barcos enemigos.");
      } else {
        this.addBattleLog('» DERROTA. TU FLOTA HA SIDO DESTRUIDA');
        alert("DERROTA. Tu flota ha sido destruida.");
      }
      // Aquí se podría redirigir a una pantalla de resultados o reiniciar
    },
    startTimer() {
      this.timer = setInterval(() => {
        this.seconds++;
        const minutes = Math.floor(this.seconds / 60);
        const secs = this.seconds % 60;
        this.gameTime = `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
      }, 1000);
    },
    addBattleLog(message) {
      this.battleLogs.push(message);
      this.$nextTick(() => {
        this.scrollToEndOfLogs();
      });
    },
    scrollToEndOfLogs() {
      if (this.$refs.logEnd) {
        this.$refs.logEnd.scrollIntoView({ behavior: 'smooth' });
      }
    }
  }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');

.font-pixel {
  font-family: 'Press Start 2P', cursive;
}

/* Layout con altura fija */
.fixed-height-container {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  grid-template-rows: 1fr;
  gap: 16px;
  height: calc(100vh - 120px);
  width: 100%;
  max-height: calc(100vh - 120px);
  overflow: hidden; /* Crítico: previene scroll en todo el contenedor */
}

.grid-col-left {
  grid-column: 1 / 2;
  grid-row: 1;
  min-width: 200px;
  max-width: 200px;
  height: 100%;
  overflow: hidden; /* Asegura que el contenedor padre no haga scroll */
}

.battle-log {
  max-height: 100%; /* Asegura que no exceda su contenedor padre */
  height: 100%;
}

.grid-col-center {
  grid-column: 2 / 3;
  grid-row: 1;
  height: 100%;
  overflow: hidden;
}

.grid-col-right {
  grid-column: 3 / 4;
  grid-row: 1;
  min-width: 200px;
  max-width: 200px;
  height: 100%;
  overflow: hidden;
}

.overlay {
  background: repeating-linear-gradient(
    180deg,
    rgba(0, 0, 0, 0) 0,
    rgba(0, 0, 0, 0.1) 1px,
    rgba(0, 0, 0, 0) 2px
  );
}

.battle-log::-webkit-scrollbar {
  width: 5px;
}

.battle-log::-webkit-scrollbar-track {
  background: #001800;
}

.battle-log::-webkit-scrollbar-thumb {
  background: #00FF00;
}

/* Para manejar textos largos */
.break-all {
  word-wrap: break-word;
  word-break: break-all;
  hyphens: auto;
  max-width: 100%;
}

/* Animaciones */
@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
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

.animate-blink {
  animation: blink 1s infinite;
}

.animate-moveLines {
  animation: moveLines 6s linear infinite;
}

/* Responsive */
@media (max-width: 1024px) {
  .fixed-height-container {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto auto auto;
    height: auto;
    max-height: none;
    overflow: visible;
  }
  
  .grid-col-left, .grid-col-center, .grid-col-right {
    grid-column: 1;
    width: 100%;
    min-width: 100%;
    max-width: 100%;
    margin-bottom: 16px;
  }
  
  .grid-col-left {
    grid-row: 2;
    height: 200px; /* Altura fija para el historial en móvil */
  }
  
  .grid-col-center {
    grid-row: 1;
  }
  
  .grid-col-right {
    grid-row: 3;
  }
  
  .battle-log {
    max-height: 150px;
  }
}
</style>
