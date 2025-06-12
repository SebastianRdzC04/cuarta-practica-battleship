<template>
    <div class="min-h-screen bg-[#001428] flex justify-center items-center font-pixel relative overflow-hidden">
        <div class="w-11/12 max-w-4xl border-8 border-[#00FF00] bg-[#00112b] p-5 shadow-[0_0_40px_rgba(0,255,0,0.4)]" style="border-image: repeating-linear-gradient(45deg, #00FF00, #00FF00 10px, #007700 10px, #007700 20px) 8;">
            <div class="text-center text-[#00FF00] p-5 animate-scanline">
                <h1 class="text-5xl mb-5 tracking-widest animate-pulse" style="text-shadow: 5px 5px 0px #00334d, -2px -2px 0px #00FFFF;">BATALLA NAVAL</h1>
                <div class="w-[100px] h-[50px] mx-auto my-5 bg-no-repeat scale-[2] transform pixel-ship"></div>
                <div class="my-8">
                    <p class="text-xs leading-loose">PREPÁRATE PARA LA GUERRA NAVAL</p>
                    <p class="text-xs leading-loose">HUNDE LA FLOTA ENEMIGA</p>
                </div>
                <button @click="startGame" class="bg-[#00334d] text-[#00FF00] border-3 border-[#00FF00] font-pixel py-4 px-8 text-base cursor-pointer my-5 transition-all duration-200 hover:bg-[#004d73] hover:-translate-x-0.5 hover:-translate-y-0.5 hover:shadow-[7px_7px_0px_#003300] active:translate-x-0.5 active:translate-y-0.5 active:shadow-[3px_3px_0px_#003300]" style="text-shadow: 2px 2px #003300; box-shadow: 5px 5px 0px #003300;">INICIAR JUEGO</button>
                <div class="mt-10">
                    <p class="text-xs leading-relaxed">CÓMO JUGAR:</p>
                    <p class="text-xs leading-relaxed">1. COLOCA TUS BARCOS</p>
                    <p class="text-xs leading-relaxed">2. TURNA DISPAROS</p>
                    <p class="text-xs leading-relaxed">3. HUNDE TODOS LOS BARCOS ENEMIGOS PARA GANAR</p>
                </div>
                <div class="mt-10">
                    <p class="animate-blink mb-5 text-xs">INSERTA MONEDA PARA CONTINUAR</p>
                    <p class="text-[8px] text-[#007700]">© 2023 BATALLA NAVAL RETRO</p>
                </div>
            </div>
        </div>
        <div class="absolute inset-0 pointer-events-none animate-moveLines overlay"></div>
    </div>
</template>

<script>
export default {
    name: 'Welcome',
    data() {
        return {
            playerName: '',
            gameReady: false
        }
    },
    methods: {
        startGame() {
            console.log('Iniciando juego...');
            // Agregar lógica de navegación aquí cuando la página del juego esté lista
        }
    }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');

.font-pixel {
    font-family: 'Press Start 2P', cursive;
}

.pixel-ship {
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50" viewBox="0 0 100 50"><rect x="40" y="20" width="60" height="10" fill="%2300FF00"/><rect x="30" y="30" width="60" height="10" fill="%2300FF00"/><rect x="20" y="40" width="70" height="10" fill="%2300FF00"/><rect x="80" y="10" width="10" height="10" fill="%2300FF00"/></svg>');
    image-rendering: pixelated;
}

.overlay {
    background: repeating-linear-gradient(
        180deg,
        rgba(0, 0, 0, 0) 0,
        rgba(0, 0, 0, 0.1) 1px,
        rgba(0, 0, 0, 0) 2px
    );
}

/* Animations */
@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0; }
}

@keyframes scanline {
    0% { background-position: 0 0; }
    100% { background-position: 0 100%; }
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

.animate-scanline {
    animation: scanline 4s linear infinite;
}

.animate-moveLines {
    animation: moveLines 6s linear infinite;
}

/* Responsive */
@media (max-width: 768px) {
    .text-5xl {
        font-size: 2rem;
    }
}
</style>