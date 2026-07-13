FROM node:20.0
WORKDIR /app
COPY *.json .
COPY server.js .
RUN npm install 
EXPOSE 8080
CMD ["node" , "server.js"]    