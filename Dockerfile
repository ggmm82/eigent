# Base image con Node
FROM node:20-bullseye

# Imposta directory di lavoro
WORKDIR /app

# Aggiorna e installa git, python3, pip e strumenti di build
RUN apt-get update && \
    apt-get install -y git python3 python3-pip build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installa il pacchetto uv (che fornisce il comando `uv`)
RUN pip3 install uv Babel

# Clona il repository
RUN git clone https://github.com/eigent-ai/eigent.git .

# Installa le dipendenze Node
RUN npm install

# Esponi la porta Vite di default
EXPOSE 5173

# Comando per avviare l'app in modalità sviluppo
CMD ["npm", "run", "dev"]
