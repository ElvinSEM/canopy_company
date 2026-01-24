import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";
import tailwindcss from "@tailwindcss/vite";
import autoprefixer from "autoprefixer";

export default defineConfig({
    plugins: [
        ViteRails({
            envVars: { RAILS_ENV: "development" },
            envOptions: { defineOn: "import.meta.env" },
            fullReload: {
                // Уменьшите отслеживаемые пути
                additionalPaths: ["config/routes.rb"],
                // Увеличьте задержку
                delay: 1000,
                // Отключите частую проверку
                always: false,
            },
        }),
        tailwindcss(),
    ],
    css: {
        postcss: {
            plugins: [autoprefixer()],
        },
    },
    build: {
        sourcemap: false,
    },
    server: {
        host: 'localhost',
        port: 3036,
        strictPort: true,
        open: false,  // Отключите авто-открытие
        // КРИТИЧНО: настройте watch
        watch: {
            // Игнорируем часто меняющиеся директории
            ignored: [
                '**/log/**',
                '**/tmp/**',
                '**/node_modules/**',
                '**/.git/**',
                '**/public/vite-dev/**',
                '**/storage/**'
            ],
            // Увеличиваем интервалы проверки
            interval: 2000,  // 2 секунды вместо 100мс
            binaryInterval: 5000,
            usePolling: false,
        },
        hmr: {
            // Настройка HMR
            overlay: true,
            clientPort: 3036,
            timeout: 30000,
        }
    },
});