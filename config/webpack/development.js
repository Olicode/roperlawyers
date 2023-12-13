process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.config.merge({
  node: {
    __dirname: true,
    __filename: true,
    global: true,
  },
});

module.exports = environment.toWebpackConfig()
