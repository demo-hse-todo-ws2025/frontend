# Build-Stage
FROM node:20-alpine AS build

WORKDIR /app

# Abhängigkeiten kopieren und installieren
COPY package*.json ./
RUN npm ci

# Restlichen Code kopieren und App builden
COPY . .
RUN npm run build

# Production-Stage
FROM nginx:stable-alpine AS production

# Gebaute Dateien aus der Build-Stage übernehmen
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: eigene nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]