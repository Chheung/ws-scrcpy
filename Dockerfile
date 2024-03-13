FROM node:18.12-alpine AS builder

WORKDIR /builder
RUN apk update && \
    apt install ffmpeg libsdl2-2.0-0 adb wget \
                 gcc git pkg-config meson ninja-build libsdl2-dev \
                 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
                 libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

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