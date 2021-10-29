
# Create a folder
mkdir actions-runner || true 
cd actions-runner
pwd
# Download the latest runner package
curl -o actions-runner-linux-x64-2.283.3.tar.gz -L https://github.com/actions/runner/releases/download/v2.283.3/actions-runner-linux-x64-2.283.3.tar.gz
# Optional: Validate the hash
echo "09aa49b96a8cbe75878dfcdc4f6d313e430d9f92b1f4625116b117a21caaba89  actions-runner-linux-x64-2.283.3.tar.gz" | shasum -a 256 -c

# Extract the installer
tar xzf ./actions-runner-linux-x64-2.283.3.tar.gz

# Create the runner and start the configuration experience
./config.sh --url https://github.com/bicschneider/github-actions-katas --token AAZRESPHVG2MKTKH63C7G4LBPPMG6

# Last step, run it!
./run.sh