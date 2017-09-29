'use strict';
var AWS = require('aws-sdk');
AWS.config.update({region:'us-east-1'});
var docClient = new AWS.DynamoDB.DocumentClient();
var noop = function(){};

exports.handler = (event, context, callback) => {
  const response = event.Records[0].cf.response;
  const header = response.headers['x-waf-tip'][0].value;
  const clientIp = event.Records[0].cf.request.clientIp;
  const triggerDate = Date.now();

  if (header == "bad") {
    var params = {
      TableName:"waf",
      Key:{
        "IP": clientIp
      },
      UpdateExpression:"add triggercount :val set triggerdate = :triggerdate",
      ExpressionAttributeValues:{
        ":val": 1,
        ":triggerdate": triggerDate
      },
      ReturnValues:"UPDATED_NEW"
    };


    console.log("Updating the item...");
    docClient.update(params, function(err, data) {
      if (err) {
        console.error("Unable to update item. Error JSON:", JSON.stringify(err, null, 2));
        callback(new Error("Something went wrong"), response);
      } else {
        console.log("UpdateItem succeeded");
        callback(null, response);
      }
    })
  } else {
    callback(null, response);
  }
};
