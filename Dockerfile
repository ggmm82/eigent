# Usa un'immagine ufficiale di Node.js
FROM node:20-alpine

# Imposta la directory di lavoro nel container
WORKDIR /app

# Installa git
RUN apk add --no-cache git

# Clona il repository
RUN git clone https://github.com/eigent-ai/eigent.git .

# Installa le dipendenze
RUN npm install

# Esponi la porta che l'app usa (di default 5173 per vite)
EXPOSE 5173

# Comando per avviare l'app in modalità sviluppo
CMD ["npm", "run", "dev"]
