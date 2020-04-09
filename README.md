# instabotlol
Just an instagram bot

## Deploy with Docker Compose

```bash
git clone https://github.com/kenmoini/instabotlol
cd instabotlol
cp bot-variables.env.example bot-variables.env
# modify the bot-variables.env file
sudo docker-compose up -d
```

## Deploy to Google Cloud Run

1. Create a Project in GCP
2. Ensure Billing is enabled
3. Enable the ***Cloud Build*** and ***Cloud Run*** APIs
4. Open the Google Cloud Shell (via GCP Dashboard, click the Terminal button four icons to the left of your Profile Picture in the upper-right corner of the screen)
5. Run:

```bash
git clone https://github.com/kenmoini/instabotlol #from the GCP SCM really or won't work
cd instabotlol

# get the project ID, the second line of the following output
gcloud config get-value project 

# build the container image
gcloud builds submit --tag gcr.io/PROJECT-ID/instagrambot

# deploy to cloud run
gcloud run deploy --image gcr.io/PROJECT-ID/instagrambot --platform managed --set-env-vars USER=bar,PASS=boo,SIMULATION=False
```
