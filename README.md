# Twine

A free, simple linktree: one link for everything you share. Made in Norway 🇳🇴

Sign up, pick a username, add your links, and share `twine.no/@yourname`.

## Inquiries?

This project is maintained by Tomas! Reach out to me on hey@twine.no

## How it works

- A **User** signs up with an email, a password and a username.
- The user gets one **Page**, with a name, a bio and a picture, served at `/@username`.
- The page has **Links**, which can be added, edited, deleted and dragged into order from the editor at `/page/edit`.
- A page can be unpublished, and a page with a `domain` is also served from the root of that domain.

The editor saves each field as soon as it changes, and then refreshes itself with a Turbo morph so the preview follows along.

## How to get the project up and running

It's a Ruby on Rails project, so install Ruby and run `bin/setup`. `bin/rails db:seed` loads the test fixtures, so
you can log in as `example@mail.com` with the password `password`.

Run the tests with `bin/run-tests`.

## Contribute

Feel free to explore the code and submit pull requests. It's early days, and proper processes will be formalised.
It's a good idea to reach out to Tomas first if you have a bigger idea you want to add to the project.

## License

Protected under the JGTHF (Just Give Tomas a Heads-up First) license, in case you want to use the code
for something radically different from the scope of this app/project.
