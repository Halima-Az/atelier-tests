
# --- étape 1 : installer les dépendances de production
FROM node:26-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# --- étape 2 : image finale minimale
FROM node:26-alpine

ENV NODE_ENV=production
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
COPY src ./src

# Supprimer npm et npx uniquement de l'image finale
RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/bin/npm \
    /usr/local/bin/npx

USER node
EXPOSE 3000

CMD ["node", "src/server.js"]
