FROM node:20.20.2-alpine3.22 AS builder
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install 

FROM node:20.20.2-alpine3.22
WORKDIR /app
EXPOSE 8080
RUN addgroup -S flipkart && adduser -S -G flipkart flipkart && \
    chown -R flipkart:flipkart /app
COPY --from=builder /app /app
USER flipkart
CMD ["node", "server.js"]


#before implementing docker best practices

# FROM node:20.0
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# RUN npm install 
# EXPOSE 8080
# CMD ["node" , "server.js"]    