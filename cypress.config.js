const { defineConfig } = require("cypress");

module.exports = defineConfig({
  experimentalInteractiveRunEvents: true,
  reporter: 'cypress-multi-reporters',
  reporterOptions: {
    reporterEnabled: 'mochawesome',
    mochawesomeReporterOptions: {
      reportDir: 'cypress/reports/mocha',
      reportFilename: '[status]_[datetime]-[name]-report',
      quite: true,
      overwrite: false,
      html: false,
      json: true,
    },
  },
  e2e: {
    baseUrl: 'https://www.saucedemo.com',
    blockHosts: [
      "*backtrace.io"
    ],
    failOnStatusCode: false,
    chromeWebSecurity: false,
    setupNodeEvents(on, config) {
    },
  },
});
