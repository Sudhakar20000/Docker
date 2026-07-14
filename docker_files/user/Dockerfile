# -------------------------------
# Stage 1: Build Stage
# -------------------------------

# Use a lightweight official Node.js Alpine image as the builder
FROM node:20.20.2-alpine3.22 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy dependency definition file first
# This helps Docker cache the npm install layer
COPY package.json .

# Copy application source files
COPY *.js .

# Install application dependencies
RUN npm install


# -------------------------------
# Stage 2: Runtime Stage
# -------------------------------

# Use a fresh lightweight Node.js image for the final container
FROM node:20.20.2-alpine3.22

# Set the working directory
WORKDIR /app

# Expose the application port
EXPOSE 8080

# Create a non-root user and group for better security
# Change ownership of the application directory
RUN addgroup -S flipkart && \
    adduser -S -G flipkart flipkart && \
    chown -R flipkart:flipkart /app

# Copy only the built application from the builder stage
# This keeps the final image smaller and excludes unnecessary build files
COPY --from=builder /app /app

# Switch to the non-root user
USER flipkart

# Start the Node.js application
CMD ["node", "server.js"]

#before implementing docker best practices

# FROM node:20.0
# WORKDIR /app
# COPY package.json .
# COPY *.js .
# RUN npm install 
# EXPOSE 8080
# CMD ["node" , "server.js"]    