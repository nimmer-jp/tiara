FROM nimlang/nim:2.2.6-alpine-regular AS build
WORKDIR /app
COPY . .
RUN nimble build -d:release -y && strip /app/main

FROM alpine:3.21 AS runtime-libs
RUN apk add --no-cache pcre

FROM scratch
WORKDIR /app
COPY --from=runtime-libs /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=runtime-libs /usr/lib/libpcre.so.1* /usr/lib/
COPY --from=build /app/main /app/main
COPY --from=build /app/public /app/public
EXPOSE 8080
ENV PORT=8080
CMD ["/app/main"]
