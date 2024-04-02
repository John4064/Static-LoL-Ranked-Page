# Use Node.js 16 as the base image
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Next.js application
RUN npm run build

# Start a new stage for serving the application
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built files from previous stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY package.json package-lock.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port on which the application will run
EXPOSE 3000

# Set environment variable
ENV NODE_ENV=production

# Start the Next.js application
CMD ["npm", "run","start"]