FROM node:20 AS builder
WORKDIR /app
COPY *.json .
COPY *.js .
RUN npm install



FROM node:20.16.0-alpine3.20
EXPOSE 8080
ENV DB_HOST="mysql"
RUN addgroup -S expense && adduser -S expense -G expense && \
    mkdir /app && \
    chown -R expense:expense /app 
WORKDIR /app
COPY --from=builder /app /app
USER expense
CMD ["node", "index.js"]

#before changes
# FROM node:20
# EXPOSE 8080
# ENV DB_HOST="mysql"
# RUN useradd expense
# RUN mkdir /app
# WORKDIR /app
# COPY *.json .
# COPY *.js .
# RUN npm install
# CMD ["node", "index.js"]