FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common curl build-essential pkg-config libssl-dev git && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y python3.10 python3.10-venv python3.10-dev python3.10-distutils && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.10 get-pip.py && \
    rm get-pip.py

# Install Rust and just
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:$PATH"

# RUN cargo install just

# # Clone the repo and checkout branch
# RUN git clone https://github.com/LuukSuurmeijer/modernbert-finetune.git
# RUN git checkout test

WORKDIR /modernbert-finetune

COPY . .

RUN apt-get install git-lfs && git lfs update --force && git lfs install


# Upgrade pip and install uv
RUN pip install --upgrade pip
RUN pip install uv

# Install dependencies one by one with uv
RUN uv pip install --system torch
RUN uv pip install --system hatchling
RUN uv pip install --system ".[cuda]" --no-build-isolation

# Run your script to catch errors during build
CMD ["python3", "-u", "-m", "src.modernbert-finetune.train"]
