#!/bin/bash
echo "Launching Jupyter Lab..."
id
pwd
sudo -u user /home/user/.venv/bin/jupyter lab --LabApp.token='' --allow-root --ip=0.0.0.0 --port=8889