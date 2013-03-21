coffeeMiddleware = require('coffee-middleware')
express = require('express')
app = express()

publicDir = __dirname + '/../public'
appDir = __dirname + '/../app'
app.use coffeeMiddleware(src: appDir, dest: publicDir, force: true)
app.use express.static(publicDir)

app.listen(3000)
console.log('Listening on port 3000')

app.use (req, res) ->
  res.send('Hello')