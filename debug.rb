#!/usr/bin/env ruby
require 'json'

API_KEY = '(YOUR_API_KEY)'
DEPLOY  = 'https://(YOUR_API_ENDPOINT).execute-api.ap-northeast-1.amazonaws.com/(YOUR_API_STAGE)/(YOUR_API_RESOURCE)'

payload = {
  "operation" => "query",
  "payload"   => {
    "TableName" => "(YOUR_DYNAMO_TABLE_NAME)",
#   "Limit"     => 10,
    "KeyConditionExpression" => "Device = :dev and #ts between :from and :to",
    "ExpressionAttributeNames" => {
      "#ts"   => "Timestamp"
    },
    "ExpressionAttributeValues" => {
      ":dev"  => "(YOUR_DEVICE_NAME)",
      ":from" => Time.now.to_i - 180 ,
      ":to"   => Time.now.to_i
    }
  }
}

warn payload

curl = "curl --silent -X POST -d '#{payload.to_json}' -H 'x-api-key: #{API_KEY}' #{DEPLOY}"
puts `#{curl}`

