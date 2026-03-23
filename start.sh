#!/bin/bash

# Configuration from your images
REPO_ID=
HF_TOKEN=""

echo "--- System Starting ---"

# 
echo "Restoring files from $REPO_ID..."
huggingface-cli download $REPO_ID --local-dir /home/user/storage --repo-type dataset --token $HF_TOKEN

# 
cat <<EOF > /home/user/auto_backup.sh
#!/bin/bash
while true; do
  sleep 300
  echo "Backing up data to Hugging Face..."
  huggingface-cli upload $REPO_ID /home/user/storage . --repo-type=dataset --token=$HF_TOKEN
done
EOF
chmod +x /home/user/auto_backup.sh
./auto_backup.sh &

# 
cat <<EOF > /home/user/final_backup.sh
#!/bin/bash
# 
sleep 172200
echo "Hugging Face is about to restart soon. Taking final backup..."
huggingface-cli upload $REPO_ID /home/user/storage . --repo-type=dataset --token=$HF_TOKEN
EOF
chmod +x /home/user/final_backup.sh
./final_backup.sh &

# à§ª. 
echo "--- System is Ready. Access via Web Terminal ---"
ttyd -p 7860 -W bash