Temperature Pi
====================
Temperature logger platform with Raspberry Pi + Amazon Web Services.

It measures room temperature and CPU core temperature of Raspberry Pi, and sends them to AWS.
Saved records can be displayed graphically from your browser.

TEMPer is used to record room temperature.
This is a device that can be connected by USB.

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

Files
--------------------
### `s3/index.html`
Draw chart of logged temperature.
It gets records by XHR from the endpoint of API Gateway.

You can distribute this file both directly from S3 and through CloudFront.

An endpoint URI must be set on [L43](https://github.com/curipha/temperaturepi/blob/master/s3/index.html#L43).

