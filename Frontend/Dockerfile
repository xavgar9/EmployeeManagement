# Use an official Node.js runtime as a parent image
FROM node:14

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose a port (if your app listens on a specific port)
# EXPOSE 3000

# Define the command to run your application
CMD [ "npm", "start" ]
