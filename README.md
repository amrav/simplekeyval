# simplekeyval

Node.js service that exposes a simple, string-based key value store as a RESTful API.

## API

To get the value of a key:
```
GET /:key

{
  "key": string,
  "value": string
}
```

To set the value of a key:
```
POST /:key

{
  "value": string,
  "readOnly": boolean,
  "secret": string
}
```
Here, `readOnly` and `secret` are optional. You need to provide a `secret` to store a new key as read only.

## Security

- The secrecy of your value depends on the obscurity of your key. Anyone can retrieve a value if they know the key.
- Least recently used keys expire once the backing Redis instance runs out of memory.
Anyone can expire all keys by sending a very large number of requests.
- Keys that have `readOnly` set cannot be overwritten except by supplying the `secret`. They can however expire.

## Installation

- Install Redis.
- `git clone` followed by `npm install`.
- `coffee app.coffee` starts the server.
- (Optional) This should also run on Heroku out of the box, and depends on Redistogo.
