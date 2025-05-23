# Docker container for science

This container is GPU enabled and comes with it common libraries for running ML workflows
and other scientific analysis. A JupyterLab instance is launched on port 8889. Kernels for
Python, R, and Julia are provided.

## Example docker-compose.yml file
```yaml
services:
  science:
    container_name: science
    build:
      context: ./science/science
      dockerfile: ./Dockerfile
    environment:
      - JUPYTER_TOKEN=""
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    user: "1000:1000"
    volumes:
      - $HOME/projects:/home/user/projects
      - ./science/config:/home/user/.jupyter
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    restart: unless-stopped
    ipc: "host"
    ulimits:
      memlock: -1
      stack: 67108864
```