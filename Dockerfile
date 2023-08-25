# Build dist folder
FROM --platform=linux/amd64 node:18-alpine AS dist
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN yarn build

# Install node_modules for production mode
FROM --platform=linux/amd64 node:18-alpine AS node_modules
COPY package.json yarn.lock ./
RUN yarn install --prodpac

# Create serverPath(/usr/src/app)
FROM --platform=linux/amd64 node:18-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy dist & node_modules & package.json to serverPath
COPY --from=dist dist /usr/src/app/dist
COPY --from=node_modules node_modules /usr/src/app/node_modules
COPY package.json /usr/src/app

# Start server
CMD [ "yarn", "start:prod" ]

