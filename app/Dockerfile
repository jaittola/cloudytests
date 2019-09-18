FROM node:12-alpine
EXPOSE 8000
USER node
ENV NODE_ENV=production
WORKDIR /home/node

COPY . .
RUN npm ci --only-production

CMD ["node", "index.js"]
