FROM node:22-alpine AS node-with-deps
WORKDIR /usr/app

COPY package*.json ./
COPY ./src ./src
COPY ./public ./public

RUN npm i --quiet

RUN npm run build

FROM node:22-alpine
WORKDIR /usr/app

ENV NODE_ENV=production

COPY --from=node-with-deps /usr/app/package*.json ./
RUN npm ci --omit=dev --ignore-scripts
RUN npm i -g serve

COPY --from=node-with-deps /usr/app/build ./build
RUN ls -la

CMD ["serve", "-s", "build"]
