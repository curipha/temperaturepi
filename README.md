Temperature Pi
====================
Temperature logger platform with Raspberry Pi + Amazon Web Services.

It measures room temperature and CPU core temperature of Raspberry Pi, and sends them to AWS.
Saved records can be displayed graphically from your browser.

TEMPer is used to record room temperature.
This is a device that can be connected by USB.
Please refer to `temper/README.md` for more details.

Topology
--------------------
```
                               +------------------------------------------+
                               |            Amazon Web Services           |
+----------------+             |                                          |            +----------------+
|                |    HTTPS    |   +-------------+                        |   HTTPS    |                |
|  Raspberry Pi  +-----------------> API Gateway +------------------------------------->    Browser     |
|                | (JSON/POST) |   +-----+-+-----+                        | (JSON/XHR) |                |
+-------+--------+             |         | ^                              |            +--------+-------+
        |                      |         v |                              |                     ^
        |                      |   +-----+-+-----+      +-------------+   |                     |   HTTPS
    +---+----+                 |   |   Lambda    |      | CloudFront  +-------------------------+ (HTML/GET)
    | TEMPer |                 |   +-----+-+-----+      +------+------+   |                     |
    +--------+                 |         | ^                   ^          |                     |
                               |         v |                   |          |      or             |
                               |   +-----+-+-----+      +------+------+   |                     |
                               |   |  DynamoDB   |      |     S3      +-------------------------+
                               |   +-------------+      +-------------+   |
                               |                                          |
                               +------------------------------------------+
```

Note: Currently, API Gateway has a functionality (AWS Service Proxy) to store the record to DynamoDB directly without Lambda.

DynamoDB scheme
--------------------
| Device                | Timestamp                       | Air                     | Core                    |
| --------------------- | ------------------------------- | ----------------------- | ----------------------- |
| String                | Number                          | Number                  | Number                  |
| Primary partition key | Primary sort key                |                         |                         |
| Name of device        | Measured time in UNIX timestamp | Temperature of the room | Temperature of CPU core |

Files
--------------------
### `debug.rb`
Simple front-end tester for API Gateway and Lambda function.

You have to set up some variables to use this script:

- API key for API Gateway : [L4](https://github.com/curipha/temperaturepi/blob/master/debug.rb#L4)
- API endpoint : [L5](https://github.com/curipha/temperaturepi/blob/master/debug.rb#L5)
- Table name of DynamoDB : [L10](https://github.com/curipha/temperaturepi/blob/master/debug.rb#L10)
- Device name : [L17](https://github.com/curipha/temperaturepi/blob/master/debug.rb#L17)

### `s3/index.html`
Draw chart of logged temperature.
It gets records by XHR from the endpoint of API Gateway.

You can distribute this file both directly from S3 and through CloudFront.

An endpoint URI must be set on [L43](https://github.com/curipha/temperaturepi/blob/master/s3/index.html#L43) and a device name on [L49](https://github.com/curipha/temperaturepi/blob/master/s3/index.html#L49).

### `lambda/get.js`
Retrieve the records from DynamoDB.
To avoid change the data, some operations which cause a side-effect are removed from `lambda/post.js`.

It intends to allow open access to this Lambda function with API Gateway.

An table name of DynamoDB must be set on [L10](https://github.com/curipha/temperaturepi/blob/master/lambda/get.js#L10).

### `lambda/post.js`
Store the data which sent from Raspberry Pi to DynamoDB.
This file is the one provided as "blueprint" by AWS. (It is licensed under CC0.)

The API key should be required to call this Lambda function from API Gateway.

### `conf/*`
3G/LTE configuration files for Arch Linux installed on Raspberry Pi.
