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

# Build Babel durante la build del container
RUN npm run compile-babel

# Esponi la porta usata da Vite
EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
