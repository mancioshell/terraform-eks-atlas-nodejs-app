FROM node:22.16.0-bullseye as BUILDER

WORKDIR /usr/src/app

COPY yarn.lock package.json ./
RUN corepack enable
RUN yarn config set nodeLinker node-modules
RUN yarn install

COPY src .
COPY tsconfig.json .
RUN yarn build

FROM node:22.16.0-bullseye as RUNTIME

WORKDIR /usr/src/app
COPY --from=BUILDER /usr/src/app/dist ./dist
COPY --from=BUILDER /usr/src/app/node_modules ./node_modules
COPY .env ./

EXPOSE 3000

CMD ["node", "dist/server.js"]