FROM node:12-alpine
EXPOSE 8000
USER node
WORKDIR /home/node

COPY . .
RUN npm ci
RUN npm run build

CMD ["node", "dist/app.js"]
