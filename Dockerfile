FROM node:lts-alpine
LABEL authors="OpenHealth"

ARG DATABASE_URL=${DATABASE_URL}

RUN apk add -U graphicsmagick

WORKDIR /app

COPY package.json prisma/ .

RUN npm install

COPY . .

RUN npm run build && \
    adduser --disabled-password ohuser && \
    chown -R ohuser .

USER ohuser
EXPOSE 3000
ENTRYPOINT ["sh", "-c", "npx prisma db push --accept-data-loss && npx prisma db seed && npm start"]
