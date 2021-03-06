## 0.0.29
- Add `discconect()` method to high level `MailClient` API
- Encode and decode mailbox names using Modified UTF7 encoding 
- Add [IMAP support for UTF-8](https://tools.ietf.org/html/rfc6855) 

## 0.0.28
- High level `MailClient` API supports IMAP IDLE, POP and SMTP.

## 0.0.27
- Downgraded crypto dependency to be compatible with flutter_test ons stable flutter channel again

## 0.0.26
- Added high level `MailClient` API
- Downgraded XML dependency to be compatible with flutter_test again
- Fixed `ImapClient`'s `eventBus` registration when this is specified outside of ImapClient.

## 0.0.25
- Add support to discover email settings using the `Discover` class.

## 0.0.24
- Improve parsing of IMAP `BODYSTRUCTURE` responses to FETCH commands.
- Add message media types.

## 0.0.23
- Provide [POP3](https://tools.ietf.org/html/rfc1939) support

## 0.0.22
- Breaking API change: use FETCH IMAP methods now return `FetchImapResult` instead of `List<MimeMessage>`
- Breaking API change: `ImapFetchEvent` now contains a full `MimeMessage` instead of just the sequence ID and flags
- Added `ImapVanishedEvent` that is called instead of `ImapExpungeEvent` when QRESYNC has been enabled
- Added support for [QRESYNC extension](https://tools.ietf.org/html/rfc7162)
- Added support for [ENABLE extension](https://tools.ietf.org/html/rfc5161)
- Fix handling STATUS responses (issue #56)

## 0.0.21
- Added support for ISO 8859-15 / latin9 encoding - based on UTF-8

## 0.0.20
- Breaking change: use `MessageSequence` for defining message ID or UID ranges instead of integer-based IDs

## 0.0.19
- Fix for fetching recent messages when the chunksize is larger than the existing messages - thanks to studiozocaro!

## 0.0.18
- Breaking API changes: `MimeMessage.body` API, get and set text/plain and text/html parts in MimeMessage
- Support nested BODY and BODYSTRUCTURE responeses when fetching message data
- Support [CONDSTORE IMAP extension](https://tools.ietf.org/html/rfc5161)
- Support [MOVE IMAP extension](https://tools.ietf.org/html/rfc6851)
- Support [UIDPLUS IMAP extension](https://tools.ietf.org/html/rfc6851)

## 0.0.17
- Supports parsing BODYSTRUCTURE responses when fetching message data
- Also eased API for accessing BODY and BODYSTRUCTURE response data

## 0.0.16
- Adding 'name' parameter with quotes to 'Content-Type' header when adding a file

## 0.0.15
- Adding 'name' parameter to 'Content-Type' header when adding a file

## 0.0.14

- Save messages to the server with `ImapClient.appendMessage()`.
- Store message flags using the `ImapClient.store()` method or use one of the mark-methods like `markFlagged()` or `markSeen()`.
- Copy message(s) using `ImapClient.copy()`.
- Copy, fetch, store or search message with UIDs using `ImapClient.uidCopy()`, `uidStore()`, etc.
- Remove messages marked with the \Deleted flag using `ImapClient.expunge()`
- Authenticate via OAUTH 2.0 using `ImapClient.authenticateWithOAuth2()` (AUTH=XOAUTH2) or `authenticateWithOAuthBearer()` (AUTH=OAUTHBEARER).
- You can now switch to TLS using `ImapClient.startTls()`.
- Query the capabilities using the `ImapClient.capability()` call.
- Let the server do some housekeeping using the `ImapClient.check()` method.

## 0.0.13

- Forward complex messages with `MessageBuilder.prepareForwardMessage()`, too  (issue #24)

## 0.0.12

- Forward messages with `MessageBuilder.prepareForwardMessage()` 

## 0.0.11

- Adding simple reply generation with `MessageBuilder.prepareReplyToMessage()` (issue #25)
- Improvement for adding larger files (issue #28)


## 0.0.10

- Fix for message sending via SMTP (issue #27)

## 0.0.9

- Introducing MessageBuilder for easy mime message creation
- Adapted example

## 0.0.8

- Ease access to text contents of a mime message
- Adapted example

## 0.0.7

- Parse MIME messages using MimeMessage.parse()
- Handle content encodings more reliably


## 0.0.6

- Supporting ASCII character character encodings and padding BASE64 headers if required

## 0.0.5

- Addressed health and syntax recommendations

## 0.0.4

- Support [IMAP METADATA Extension](https://tools.ietf.org/html/rfc5464)

## 0.0.3

- Always end lines with `\r\n` when communicating either with SMTP or IMAP server, parse iso-8859-1 encoded headers

## 0.0.2

- Cleaning architecture, adding support for `BODY[HEADER.FIELDS]` messages

## 0.0.1

- Initial alpha version
