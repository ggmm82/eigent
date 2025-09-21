import { readFileSync, rmSync } from 'node:fs'
import path from 'node:path'
import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import electron from 'vite-plugin-electron/simple'
import pkg from './package.json'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
  rmSync('dist-electron', { recursive: true, force: true })

  const isServe = command === 'serve'
  const isBuild = command === 'build'
  const sourcemap = isServe || !!process.env.VSCODE_DEBUG
  const env = loadEnv(mode, process.cwd(), '')

  return {
    resolve: {
      alias: {
        '@': path.join(__dirname, 'src')
      },
    },
    plugins: [
      react(),
      electron({
        main: {
          entry: 'electron/main/index.ts',
          onstart(args) {
            if (process.env.VSCODE_DEBUG) {
              console.log('[startup] Electron App')
            } else {
              args.startup()
            }
          },
          vite: {
            build: {
              sourcemap,
              minify: isBuild,
              outDir: 'dist-electron/main',
              rollupOptions: {
                external: Object.keys('dependencies' in pkg ? pkg.dependencies : {}),
              },
            },
          },
        },
        preload: {
          input: 'electron/preload/index.ts',
          vite: {
            build: {
              sourcemap: sourcemap ? 'inline' : undefined,
              minify: isBuild,
              outDir: 'dist-electron/preload',
              rollupOptions: {
                external: Object.keys('dependencies' in pkg ? pkg.dependencies : {}),
              },
            },
          },
        },
        renderer: {},
      }),
    ],
    server: {
      ...(process.env.VSCODE_DEBUG && (() => {
        const url = new URL(pkg.debug.env.VITE_DEV_SERVER_URL)
        return {
          host: url.hostname,
          port: +url.port,
          proxy: {
            '/api': {
              target: env.VITE_PROXY_URL,
              changeOrigin: true,
            },
          },
        }
      })()),
      watch: {
        // Ignora cartelle pesanti o non necessarie per evitare ENOSPC
        ignored: ['**/node_modules/**', '**/.venv/**', '**/dist-electron/**']
      }
    },
    clearScreen: false,
  }
})

process.on('SIGINT', () => {
  try {
    const backend = path.join(__dirname, 'backend')
    const pid = readFileSync(backend + '/runtime/run.pid', 'utf-8')
    process.kill(parseInt(pid), 'SIGINT')
  } catch (e) {
    console.log('no pid file')
    console.log(e)
  }
})
