FROM nimlang/nim:2.2.6-alpine-regular AS build
WORKDIR /app
COPY . .
RUN nimble build -y

FROM alpine:3.21
WORKDIR /app
RUN apk add --no-cache chromium nss freetype harfbuzz ca-certificates ttf-freefont pcre
COPY --from=build /app/main /app/main
COPY --from=build /app/public /app/public
EXPOSE 8080
ENV PORT=8080
ENV CHROMIUM_PATH=/usr/bin/chromium-browser
CMD ["/app/main"]
