# develop stage
FROM node:lts-alpine as develop-stage
WORKDIR /src
COPY package*.json ./
RUN npm i -g @quasar/cli@latest
COPY . .

# local-deps
FROM develop-stage as local-deps-stage
RUN yarn

# build stage
FROM local-deps-stage as build-stage
RUN quasar build -m ssr

# production stage
FROM node:lts-alpine as production-stage
WORKDIR /app
COPY --from=build-stage /src/dist/ssr .
RUN yarn
EXPOSE 3000
CMD ["node", "index.js"]