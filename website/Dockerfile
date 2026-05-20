FROM nimlang/nim:2.2.6-alpine-regular AS build
WORKDIR /app
COPY src /app/src
COPY examples /app/examples
COPY website /app/website
WORKDIR /app/website
# Basolato の PORT_NUM / HOST_ADDR は .nim の const でコンパイル時に getEnv される。
# ビルド時に PORT が無いと 5000 が埋め込まれ、Cloud Run(8080) のプローブが失敗する。
# コンテナ PORT を変える場合はビルド引数で合わせること。
ARG PORT=8080
ARG HOST=0.0.0.0
ENV PORT=${PORT}
ENV HOST=${HOST}
RUN nimble build -d:release -y && strip /app/website/main

FROM alpine:3.21 AS runtime-libs
RUN apk add --no-cache pcre

FROM scratch
WORKDIR /app
COPY --from=runtime-libs /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=runtime-libs /usr/lib/libpcre.so.1* /usr/lib/
COPY --from=build /app/website/main /app/main
COPY --from=build /app/website/public /app/public
EXPOSE 8080
ENV PORT=8080
CMD ["/app/main"]
