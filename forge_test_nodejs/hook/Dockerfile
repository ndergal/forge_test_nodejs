FROM node:carbon

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY hook.js ./

EXPOSE 80

ENTRYPOINT ["npm"]

CMD ["start"]

