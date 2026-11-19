# Security and privacy

Twine lets anyone sign up and publish a page of links, so everything a user types ends up in front of strangers.

## Accounts

- Anyone can sign up. Email addresses are not verified.
- Passwords use `has_secure_password` and must be at least 8 characters.
- A login is a `Session` row, referenced from a signed, http-only, `SameSite=Lax` cookie.
- Signing up, logging in and asking for a password reset are each rate limited to 10 attempts per 3 minutes.

## Who can change what

- An account has one page. Controllers reach pages and links through `Current.user.page`, never by id alone,
  so somebody else's link returns 404.
- Pages from before accounts were limited to one page can lack an owner. Nobody can edit those until an owner
  is assigned by hand.

## What visitors are shown

- Only pages with `published: true` are served, at `/@handle` or at the root of the page's own `domain`.
- Link addresses must match `Link::WEB_ADDRESS` (http or https, no credentials in the address) or be a `mailto:`
  address. Anything else, such as `javascript:` or `data:`, is refused, because visitors open these addresses with a click.
- Links open with `rel="noopener nofollow ugc"`.
- Names, bios and link titles are escaped by ERB. Never mark user content as `html_safe`.
- A page's `color` goes into a `style` attribute, and is validated as a hex color first.
- Public pages load no JavaScript.

## Uploads

- A page's picture must be a PNG, JPEG, WebP or GIF of at most 5 MB.
- Active Storage reads the type from the file's content, but falls back to the type the browser declared when
  the content has no signature it recognises. Such a file is stored, but can't be turned into the thumbnail that pages show.
