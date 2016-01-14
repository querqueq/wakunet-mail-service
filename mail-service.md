## POST /mails

#### Request:

- Supported content types are:

    - `application/json`

- Example: `application/json`

```javascript
{"subject":"Invitation to event","to":["john@example.org","jane@example.org"],"transactionalData":{"salutation":"Dear Family Doe,"},"template":"InvitationFormal"}
```

#### Response:

- Status code 201
- Headers: []

- Supported content types are:

    - `application/json`

- No response body

## GET /templates

#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- Response body as below.

```javascript
["invitation","reminder","notification"]
```

## GET /templates/:name

#### Captures:

- *name*: name of template

#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `text/plain;charset=utf-8`

- Response body as below.

```
Hello $receiver,

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

Regards, 
$sender

```

