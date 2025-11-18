# build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# runtime stage: nginx
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
# optional: custom nginx conf if you use client-side routing (SPA)
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
