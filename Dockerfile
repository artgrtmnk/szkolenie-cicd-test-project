FROM cypress/included:latest

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN rm -rf /app/cypress/reports
RUN npm install
RUN npm install cypress
RUN npm install mochawesome-merge
RUN npx cypress verify