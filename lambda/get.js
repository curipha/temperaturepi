'use strict';
console.log('Loading function');

let doc = require('dynamodb-doc');
let dynamo = new doc.DynamoDB();

exports.handler = (event, context, callback) => {
  const operation = event.operation;

  event.payload.TableName = '(YOUR_DYNAMO_TABLE_NAME)';

  switch (operation) {
    case 'read':
      dynamo.getItem(event.payload, callback);
      break;
    case 'query':
      dynamo.query(event.payload, callback);
      break;
    default:
      callback(new Error(`Unrecognized operation "${operation}"`));
  }
};
