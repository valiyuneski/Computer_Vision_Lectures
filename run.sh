#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

VENV=".venv"
PYTHON="${PYTHON:-python3}"

if [ ! -d "$VENV" ]; then
  echo "Creating virtual environment ($VENV)..."
  "$PYTHON" -m venv "$VENV"
else
  echo "Reusing existing virtual environment ($VENV)..."
fi

echo "Upgrading pip..."
"$VENV/bin/python" -m pip install --upgrade pip

echo "Installing requirements..."
"$VENV/bin/python" -m pip install -r requirements.txt

echo "Installing Jupyter..."
"$VENV/bin/python" -m pip install jupyter ipykernel

echo "Done. Activate with: source $VENV/bin/activate"