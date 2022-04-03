FROM node:14-alpine
WORKDIR /opt
COPY . /opt
RUN yarn install
RUN yarn build

FROM nginx:1.21-alpine
WORKDIR /usr/share/nginx/html
COPY --from=0 /opt/dist ./
RUN ls -la
EXPOSE 80
