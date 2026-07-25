# Stage 1: Build static assets
FROM node:22-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve static assets with Nginx
FROM nginx:alpine

# Copy built dist files
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the configs folder into Nginx html directory
COPY --from=build /app/configs /usr/share/nginx/html/configs

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]