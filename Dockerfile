# Build stage
FROM node:20-alpine AS build
WORKDIR /frontend

# Copy package.json and yarn.lock to install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy the entire frontend code
COPY . .

# Build the React app for production
RUN yarn build

# Run stage: Serve the built app using Nginx
FROM nginx:alpine AS run

# Set the environment variable for the port (default to 80)
ENV PORT=80

# Copy the build files from the build stage
COPY --from=build /frontend/build /usr/share/nginx/html

# Expose the port (configured through the ENV variable)
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
