# Stage 1: Build the application
FROM node:18 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files from the host machine to the container
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the built application
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy the build output and dependencies from the builder stage
COPY --from=builder /app ./

# Expose the port the app runs on
EXPOSE 3333

# Start the application
CMD ["npm", "run", "start"]