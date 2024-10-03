FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18
WORKDIR /app
COPY --from=build /app/package*.json ./
RUN npm install --production
COPY --from=build /app ./
EXPOSE 3000
CMD ["npm", "run", "start"]


# FROM node:16-alpine AS build
# WORKDIR /app
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile
# COPY . .
# RUN yarn build

# FROM node:16-alpine AS run
# WORKDIR /app
# COPY --from=build /app /app
# EXPOSE 3000
# CMD ["yarn", "start"]
