# Use an official Node.js runtime as a base image
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Build the project for production
RUN npm run build

# Use a lightweight web server to serve the static files
FROM nginx:alpine AS production

# Copy the built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to make the application accessible
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]