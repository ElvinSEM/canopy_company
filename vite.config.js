import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
    plugins: [
        RubyPlugin(),
    ],
    css: {
        devSourcemap: true
    },
    resolve: {
        alias: {
            '@': '/app/javascript'
        }
    }
})
