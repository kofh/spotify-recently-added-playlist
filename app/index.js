exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      hello: 'world',
      success: true,
      number: 4
    }),
  }
  callback(null, response)
}
