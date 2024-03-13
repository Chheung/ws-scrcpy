FROM node:18.12-alpine AS builder

WORKDIR /builder
RUN apk update && \
    apt install scrcpy

COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM node:16-alpine AS production
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production
COPY --from=builder ./builder/dist ./dist

CMD ["yarn", "start"]