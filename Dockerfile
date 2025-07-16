FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

RUN apt-get update && \
    apt-get install -y curl build-essential pkg-config libssl-dev git

# Install Rust and just
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:$PATH"

# RUN cargo install just

# # Clone the repo and checkout branch
# RUN git clone https://github.com/LuukSuurmeijer/modernbert-finetune.git
# RUN git checkout test

WORKDIR /modernbert-finetune

COPY . .

# Upgrade pip and install uv
RUN pip install --upgrade pip
RUN pip install uv

# Install dependencies one by one with uv
RUN uv pip install --system torch
RUN uv pip install --system hatchling
RUN uv pip install --system ".[cuda]"

# Run your script to catch errors during build
RUN python -m -u src.modernbert-finetune.train || echo "Training failed (expected on CPU-only build)"
