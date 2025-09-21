# Base image con Node e Python
FROM node:20-bullseye

# Imposta la directory di lavoro
WORKDIR /app

# Installa git, Python e strumenti di build
RUN apt-get update && \
    apt-get install -y git python3 python3-pip build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installa uv e Babel (per pybabel)
RUN pip3 install uv Babel

# Clona il repository
RUN git clone https://github.com/ggmm82/eigent.git .

# Installa dipendenze Node
RUN npm install

# Compila Babel durante la build
RUN npm run compile-babel

# Build frontend statico
RUN npm run build

# Installa serve per servire la build
RUN npm install -g serve

# Esponi porta Vite/frontend
EXPOSE 5173

# Avvia server statico sulla porta 5173 accessibile da 0.0.0.0
CMD ["serve", "-s", "dist", "-l", "5173"]
