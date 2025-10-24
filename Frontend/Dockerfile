FROM node:18

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy app code
COPY . .

# Build Next.js
RUN npm run build

# Expose port and start
EXPOSE 3000
CMD ["npm", "start"]
