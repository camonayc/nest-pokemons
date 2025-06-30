# Etapa 1: Instala solo dependencias necesarias
FROM node:20-alpine AS deps

# Agrega soporte para algunas dependencias nativas
RUN apk add --no-cache libc6-compat

# Establece el directorio de trabajo
WORKDIR /app

# Copia archivos clave para instalar dependencias
COPY package.json yarn.lock ./

# Instala dependencias completas en modo "frozen"
RUN yarn install --frozen-lockfile


# Etapa 2: Compila el proyecto NestJS
FROM node:20-alpine AS builder

WORKDIR /app

# Copia todo el proyecto y las dependencias
COPY . .
COPY --from=deps /app/node_modules ./node_modules

# Compila la app (NestJS -> dist/)
RUN yarn build


# Etapa 3: Imagen final para producción
FROM node:20-alpine AS runner

# Establece directorio de ejecución
WORKDIR /app

# Copia solo lo necesario para producción
COPY package.json yarn.lock ./
COPY --from=builder /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules

# Expone el puerto (Railway lo detecta automáticamente si está configurado en la app)
EXPOSE 3000

# Comando para iniciar la app NestJS
CMD ["node", "dist/main"]
