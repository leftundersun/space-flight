# syntax=docker/dockerfile:1

FROM node:17.3-stretch

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npx gulp

EXPOSE 3000

CMD npm run start