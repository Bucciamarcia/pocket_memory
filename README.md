# pocket_memory

Codebase for PocketMemory app.

# Install

- Create `.env` file in `functions/` with these variables:

```dotenv
OPENAI_APIKEY
```

# Deploy functions

Scripts to deploy pubsub functions to gcloud because they don't upòload with `firebase deploy`:

```fish
gcloud functions deploy autoremove_guests \
  --gen2 \
  --region=europe-west3 \
  --runtime=python311 \
  --entry-point=autoremove_guests \
  --trigger-topic=delete_guest_users
  ```