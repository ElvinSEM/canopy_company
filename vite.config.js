import { defineConfig } from "vite"
import ViteRails from "vite-plugin-rails"
import tailwindcss from "@tailwindcss/vite"
import autoprefixer from "autoprefixer"

export default defineConfig(({ mode }) => {
    const isDev = mode === "development"

    return {
        plugins: [
            ViteRails(),
            tailwindcss(),
        ],

        css: {
            postcss: {
                plugins: [autoprefixer()],
            },
        },

        build: {
            sourcemap: false,
            outDir: "public/vite",  // ✅ ключевая настройка для Rails production
            emptyOutDir: true,      // очищает папку перед сборкой
        },

        // ⚠️ server / hmr ТОЛЬКО для development
        ...(isDev && {
            server: {
                host: "localhost",
                port: 3036,
                strictPort: true,
                open: false,
                watch: {
                    ignored: [
                        "**/log/**",
                        "**/tmp/**",
                        "**/node_modules/**",
                        "**/.git/**",
                        "**/public/vite-dev/**",
                        "**/storage/**",
                    ],
                    interval: 2000,
                    binaryInterval: 5000,
                    usePolling: false,
                },
                hmr: {
                    overlay: true,
                    clientPort: 3036,
                    timeout: 30000,
                },
            },
        }),
    }
})
