FROM node:22-alpine AS BUILD
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["npm" , "run", "dev", "--", "--host", "0.0.0.0"]