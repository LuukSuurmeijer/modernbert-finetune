# CONFIG
SERVER_USER := "ubuntu"
SERVER_HOST := "your.gpu.vm.ip"
SERVER := "{{SERVER_USER}}@{{SERVER_HOST}}"
REPO_URL := "https://github.com/LuukSuurmeijer/modernbert-finetune.git"
REPO_NAME := "modernbert-finetune"
REMOTE_DIR := "/home/{{SERVER_USER}}/{{REPO_NAME}}"
LOCAL_ENV := ".env"

# Step 1: SSH and clone repo
ssh-clone:
    bash -euxo pipefail -c "\
      if [ ! -d {{REPO_NAME}} ]; then \
        git clone {{REPO_URL}}; \
      fi; \
      cd {{REPO_NAME}}; \
      git checkout test; \
      git pull"'

# Step 2: Copy .env file to remote
copy-env:
    scp {{LOCAL_ENV}} {{SERVER}}:{{REMOTE_DIR}}/.env

# Step 3: Build Docker image on remote
remote-build:
    ssh {{SERVER}} 'bash -euxo pipefail -c "\
      cd {{REPO_NAME}}; \
      docker build -t {{REPO_NAME}} ."'

# Step 4: Run container with env file and GPU
remote-run:
    ssh {{SERVER}} 'bash -euxo pipefail -c "\
      cd {{REPO_NAME}}; \
      docker run --rm --gpus all --env-file .env {{REPO_NAME}}"'

# Orchestrate everything
deploy: ssh-clone copy-env remote-build remote-run

ssh-test: 
    ssh -tt quineserver@192.168.178.208 copy-env

run-docker:
    docker run --rm --gpus all --env-file .env {{REPO_NAME}}