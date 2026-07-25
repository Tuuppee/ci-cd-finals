# Stage 1: Build static assets
FROM node:22-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve static assets with Nginx
FROM nginx:alpine

# Copy built dist files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

# Start Nginx directly
CMD ["nginx", "-g", "daemon off;"]