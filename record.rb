#!/usr/bin/env ruby
require 'json'

API_KEY = '(YOUR_API_KEY)'
DEPLOY  = 'https://(YOUR_API_ENDPOINT).execute-api.ap-northeast-1.amazonaws.com/(YOUR_API_STAGE)/(YOUR_API_RESOURCE)'

AIR_TEMP  = '/usr/local/bin/temper'
CORE_TEMP = 'cat /sys/class/thermal/thermal_zone0/temp' # This value needs to divide by 1,000

air  = `#{AIR_TEMP}`.to_f
core = `#{CORE_TEMP}`.to_f / 1000

puts "[#{Time.now.to_s}] air = #{air}, core = #{core}"

payload = {
  "operation" => "create",
  "payload"   => {
    "TableName" => "(YOUR_DYNAMO_TABLE_NAME)",
    "Item"      => {
      "Device"    => "(YOUR_DEVICE_NAME)",
      "Timestamp" => Time.now.to_i,
      "Air"       => air.to_s,
      "Core"      => core.to_s
    }
  }
}

curl = "curl --silent -X POST -d '#{payload.to_json}' -H 'x-api-key: #{API_KEY}' #{DEPLOY}"
`#{curl}`

