GCLOUD_LOCATION=$(command -v gcloud)
echo "Using gcloud from $GCLOUD_LOCATION"
gcloud --version
gcloud compute forwarding-rules list --format="json" > lb_details.json