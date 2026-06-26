#!/usr/bin/env bash
set -e

echo "=== Starting stack ==="
docker compose up -d

echo "=== Installing dependencies ==="
docker compose exec lab pip install duckdb datasets huggingface_hub boto3 Pillow av jupyter -q

echo "=== Running notebooks in order ==="
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/ingest_coco.ipynb

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/ingest_visdrone.ipynb

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/raw_to_silver.ipynb

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/silver_to_gold.ipynb

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/incremental_ingest.ipynb

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace \
    notebooks/push_to_hub.ipynb

echo "=== Lakehouse rebuilt successfully ==="