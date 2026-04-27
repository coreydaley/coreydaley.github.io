+++
author = "Claude Code (Claude Sonnet 4.6)"
date = "2026-04-27T14:25:00-04:00"
draft = false
title = "Catching Twilio SMS Locally: MessagePit Extends Mailpit"
description = "Mailpit solved local email testing years ago. SMS testing never got the same treatment — most teams either disable SMS in dev or eat the Twilio bill. MessagePit is a fork of Ralph Slooten's Mailpit that adds a Twilio-compatible ingest endpoint, an SMS inbox, and signature validation, so your existing Twilio SDK can point at localhost during development and CI without sending a single real message."
summary = """Most teams have a tidy local story for email and a weird one for SMS. Mailpit catches every transactional email in dev — clean web UI, nothing leaks. For SMS, the usual options are stub the Twilio client, disable sends in dev entirely, or eat the cost of real messages during CI runs. None of those are good.

MessagePit is a fork of Ralph Slooten's Mailpit that closes the gap. It exposes a Twilio-compatible HTTP endpoint at the real `/2010-04-01/Accounts/{AccountSid}/Messages.json` shape, validates `X-Twilio-Signature` if you opt into it, and surfaces every captured SMS in the same web UI Mailpit ships for email. Point your Twilio SDK at `http://localhost:1775` instead of `api.twilio.com` and the rest of your code stays exactly the same.

What other third-party integrations in your stack would get dramatically easier if you stopped mocking them and started catching them locally?

Read more at https://coreydaley.dev/posts/2026/04/messagepit-catching-twilio-sms-locally/"""
tags = ["messagepit", "mailpit", "twilio", "sms", "developer-tools", "testing", "go", "fork", "open-source", "local-development"]
categories = ["Tools", "Web Development", "Best Practices"]
image = "messagepit-catching-twilio-sms-locally.webp"
aliases = ["/posts/messagepit-catching-twilio-sms-locally/"]
+++

{{< figure-float src="messagepit-catching-twilio-sms-locally.webp" alt="Person at desk with laptop sending numerous email envelopes into wire baskets." >}}
Local email testing has been solved for years.

Run [Mailpit](https://github.com/axllent/mailpit) in Docker, point your app's SMTP client at `localhost:1025`, and every transactional email lands in a tidy web inbox at `localhost:8025`. CI runs the same setup as a sidecar. Nothing leaks, nothing costs anything.

Local SMS testing has not. The realistic options when your app uses Twilio are: stub the client, disable SMS in dev entirely, or let it talk to a real Twilio sandbox subaccount. The first hides integration bugs. The second means you stop dogfooding the actual feature. The third costs real money in CI and litters your Twilio console with junk.

So I built [MessagePit](https://github.com/coreydaley/messagepit) — a Mailpit fork that lets Twilio SMS land on localhost the same way Mailpit catches email, with no changes to your application code.

The whole fork was built with [Claude Code](https://www.anthropic.com/claude-code) as the pair: the Twilio handler, the SMS storage layer and SQLite migration, the Vue inbox views, the signature validation, the new CI workflows. Every commit in the repo carries a `Co-Authored-By: Claude Sonnet 4.6` trailer to match.

{{< figure-block src="messagepit-sms-inbox.webp" alt="MessagePit web UI showing the SMS inbox tab with around twenty test messages from senders like ClinicRx, RidesNow, DemoBank, and Delivery." width="100%" >}}

## Pointing the SDK at Localhost

Run MessagePit:

```bash
docker run -p 1025:1025 -p 1775:1775 -p 8025:8025 \
  ghcr.io/coreydaley/messagepit
```

Then point your Twilio client at it. In Python:

```python
from twilio.rest import Client

client = Client("ACtest", "fake_token")
client.http_client.base_url = "http://localhost:1775"

client.messages.create(
    from_="+15555550100",
    to="+15555550199",
    body="hello from local dev",
)
```

Other SDKs expose similar transport overrides — anything that lets you swap the base URL away from `api.twilio.com` will work. MessagePit responds with a JSON payload shaped like a real Twilio response (`sid`, `account_sid`, `status: "queued"`, `direction: "outbound-api"`, and friends), so the SDK parses it, hands your code back a Message object, and the rest of your app keeps moving.

Open `http://localhost:8025`, click the SMS tab, and the message is there with a live unread badge.

## The Right Layer to Fork

The honest version of this story: I almost wrote a new tool from scratch.

A standalone "Twilio sandbox" would have needed its own UI, storage, live-update plumbing, packaging, and ops surface — search, tagging, basic auth, Prometheus, multi-arch CI. All of that is real engineering. None of it is the part that makes the tool valuable.

Ralph Slooten's Mailpit had already solved every one of those problems for the email case. The SMTP server, POP3 server, REST API, and Vue-based UI are decoupled cleanly enough that adding a fourth ingest server (HTTP for Twilio) is a relatively local change. The storage layer maps almost perfectly to SMS.

The right question wasn't "how do I build an SMS Mailpit?" It was "where does Twilio plug into Mailpit?"

The answer: a new ingest server on port 1775 (mirroring SMTP's 1025), a new storage table, two new Vue views, and an unread badge in the nav. That's it.

The whole Twilio compatibility layer is small. Stripped down:

```go
func CreateMessage(w http.ResponseWriter, r *http.Request) {
    accountSID := mux.Vars(r)["AccountSid"]
    _ = r.ParseForm()

    from := strings.TrimSpace(r.FormValue("From"))
    to := strings.TrimSpace(r.FormValue("To"))
    body := strings.TrimSpace(r.FormValue("Body"))

    if from == "" || to == "" || body == "" {
        httpError(w, http.StatusBadRequest, "From, To and Body are required")
        return
    }

    id, _ := storage.StoreSMS(from, to, body, accountSID)
    json.NewEncoder(w).Encode(twilioResponse(id, accountSID, from, to, body))
}
```

`StoreSMS` writes to SQLite, broadcasts an event over Mailpit's existing WebSocket bus on a new `"sms"` channel, and triggers any configured webhooks. Open the inbox in two browser tabs and watch them update simultaneously when your app sends. None of that infrastructure is new; it all rides on Mailpit's existing socket layer.

## One Caveat: Signature Validation

MessagePit can validate `X-Twilio-Signature` on incoming requests if you set `--sms-auth-token`. The full HMAC-SHA1 algorithm is implemented: build the canonical URL, sort POST params, concatenate as `key+value` pairs, HMAC against your token, return `403` on mismatch.

The honest framing: `X-Twilio-Signature` is normally a *webhook* header — it appears on requests Twilio sends to your application, not on outbound API calls your app makes to Twilio. The standard outbound Messages API call uses HTTP Basic Auth, so the standard Twilio SDK will not naturally include `X-Twilio-Signature` on the requests it sends to MessagePit.

This validation mode is therefore an opt-in defense for the case where MessagePit is exposed beyond `localhost` — a shared dev cluster, a CI runner reachable on a private network. For "MessagePit on my laptop," leave the flag unset.

## A Good Fork Respects the Original Shape

Forking a project well is mostly about deciding what to leave alone. The MessagePit changes lean heavily toward "leave it alone":

- **Module path** changed to `github.com/coreydaley/messagepit`, but the internal package layout stays exactly as Ralph organized it.
- **Prometheus metric prefix** changed from `mailpit_` to `messagepit_` so a sidecar deployment doesn't collide with a real Mailpit instance.
- **About modal** in the UI explicitly attributes the upstream work to Ralph Slooten — fork etiquette, but also accurate.

What I deliberately *didn't* change: the storage abstractions, the SMTP/POP3 servers, the search engine, the tagging system, the basic auth implementation, the WebSocket protocol. That code is doing real work, and a fork that "modernizes" it for no reason is a fork that loses the ability to pull in useful upstream changes later.

## What's Not in MessagePit Yet

Three honest gaps:

- **Inbound SMS simulation** — Twilio's other half is the inbound webhook flow (a real number receives a message, Twilio POSTs to your app). A "send to your app" button that POSTs a properly signed request to a configured callback URL would close that loop. Not done yet.
- **MMS** — the Messages API also handles `MediaUrl` parameters. Storing them is easy; previewing them in the UI is the more interesting part.
- **WhatsApp via Twilio** — same API, different `From` prefix (`whatsapp:`). Mostly a UI concern.

None of these block the v1 use case, which is "send SMS from dev without paying Twilio or stubbing the SDK."

## The Pattern

The lesson, the one I keep relearning, is that the right unit of reuse is rarely the library. It's the *running system*. Mailpit isn't valuable because it has a great SMTP parser; it's valuable because it's a complete deployment that solves a complete problem. Forking that complete deployment and inserting a new ingest path was an order of magnitude less work than rebuilding the deployment around a hypothetically better SMS-first architecture.

If you've ever caught yourself writing the same Docker image, the same `/healthz` handler, and the same migration runner for the third project in a row — there's probably an existing tool you should be forking instead.

*Which API in your stack are you still mocking, when you could be catching the real traffic on localhost?*

