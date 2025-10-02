FROM node:22.16.0-bullseye as BUILDER

WORKDIR /usr/app

#COPY yarn.lock package.json ./
COPY package.json ./
RUN corepack enable
RUN yarn config set nodeLinker node-modules
RUN yarn install

COPY src src
COPY tsconfig.json .
RUN yarn build

FROM node:22.16.0-bullseye as RUNTIME

WORKDIR /usr/app
COPY --from=BUILDER /usr/app/dist ./dist
COPY --from=BUILDER /usr/app/node_modules ./node_modules
COPY .env ./

EXPOSE 3000

CMD ["node", "dist/server.js"]