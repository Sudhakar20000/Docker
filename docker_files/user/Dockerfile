FROM node:20.0
WORKDIR /app
COPY *.json .
COPY server.js .
RUN npm install 
ENV MONGO="true" \
    REDIS_URL="redis://redis:6379" \
    MONGO_URL="mongodb://mongodb:27017/users"
EXPOSE 8080
CMD ["node" , "service.js"]    