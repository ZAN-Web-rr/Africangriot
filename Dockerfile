# Use official Node.js runtime as base image
FROM node:18-alpine

# Set working directory in container
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Create uploads directory
RUN mkdir -p uploads

# Expose port (Google Cloud Run uses PORT environment variable)
EXPOSE 8080

# Set environment variable for production
ENV NODE_ENV=production

# Start the application
CMD ["node", "server.js"]
