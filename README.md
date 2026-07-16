<div align="center">

# Glance Dashboard

  Personal [Glance](https://github.com/glanceapp/glance) dashboard config.

  [![Repo Size](https://img.shields.io/github/repo-size/adam01110/home?style=flat-square&label=repo%20size&labelColor=504945&color=3c3836)](https://github.com/adam01110/home)
  <br />
  [![Glance](https://img.shields.io/badge/Glance-dashboard-458588?style=flat-square&labelColor=504945)](https://github.com/glanceapp/glance)
</div>

## Automatic updates

The webhook service in [`deploy/webhook`](deploy/webhook) pulls this checkout
when Tangled sends a signed push event for `main`. Glance watches its config and
included files, so it reloads them without a container restart.

1. Ensure `/var/lib/glance` is a Git checkout whose current branch tracks the
   desired Tangled remote and that UID `1000` can write to it.
2. Add the contents of [`deploy/webhook/compose.yml`](deploy/webhook/compose.yml)
   to the Compose project containing Glance.
3. Generate a secret with `openssl rand -hex 32` and set the result as
   `GLANCE_WEBHOOK_SECRET` in the Compose environment.
4. Run `podman compose up -d --build glance-updater` once.
5. In Tangled, open **Settings > Hooks** and create an active push webhook:
   - Payload URL: `https://<your-glance-domain>/hooks/glance`
   - Secret: the same value as `GLANCE_WEBHOOK_SECRET`

The Glance route can keep its Authentik middleware. The more-specific webhook
route intentionally has no Authentik middleware because Tangled authenticates
with its HMAC signature instead.

The updater uses `git pull --ff-only`. If the server checkout has local changes
or has diverged, the update fails rather than discarding anything. For a private
repository, also mount read-only Git credentials into `glance-updater`; a public
HTTPS remote needs no credentials.
