# ---------- Stage 1: Build frontend ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Installa git per clonare il repo
RUN apk add --no-cache git

# Clona il repository
RUN git clone https://github.com/ggmm82/eigent.git .

# Installa le dipendenze Node
RUN npm install

# Compila il frontend in build statica
RUN npm run build

# ---------- Stage 2: Server statico ----------
FROM node:20-alpine

WORKDIR /app

# Installa serve per distribuire i file statici
RUN npm install -g serve

# Copia la build statica dal builder
COPY --from=builder /app/dist ./dist

# Espone la porta per il server
EXPOSE 5173

# Avvia il server statico sulla porta 5173
CMD ["serve", "-s", "dist", "-l", "5173"]
