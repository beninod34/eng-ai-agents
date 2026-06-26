# Lakehouse Project

A versioned medallion lakehouse built with DuckLake over a self-hosted RustFS S3 layer.
Image and video bytes are stored as objects in RustFS and only URIs and metadata are kept in DuckLake tables.

## Stack

- RustFS: self-hosted S3 compatible object store (API on port 9000, console on port 9001)
- DuckLake: SQL catalog with versioned Parquet data files on S3
- DuckDB: query engine
- Hugging Face Hub: data source (COCO) and sink (gold dataset)

## Datasets

- COCO: detection-datasets/coco, val and partial train splits via Hugging Face Hub
- VisDrone: VisDrone2019 MOT valset downloaded from official release, 7 sequences

## Lakehouse Layers

- raw: ingested from source with minimal changes, blobs in RustFS and URI tables in DuckLake
- silver: cleaned, deduplicated, typed, with schema evolution
- gold: ML ready tables for training and published back to Hugging Face Hub

## Requirements

- Docker and Docker Compose
- A Hugging Face write token set as HF_TOKEN in your .env file

## Setup

1. Add your Hugging Face token to .env:

HF_TOKEN=hf_your_token_here



2. Create the lakehouse bucket in RustFS. Bring up the stack first:

docker compose up -d



Then open the RustFS console at http://localhost:9001, log in with rustfsadmin / rustfsadmin, and create a bucket named lakehouse.

3. Place the VisDrone MOT valset under local-store/visdrone/ with this structure:

local-store/visdrone/
sequences/<seq_name>/0000001.jpg ...
annotations/<seq_name>.txt ...



## Running the Lakehouse

Run all notebooks in order using rebuild.sh:

./rebuild.sh



Or run each notebook manually inside the lab container:

docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/ingest_coco.ipynb
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/ingest_visdrone.ipynb
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/raw_to_silver.ipynb
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/silver_to_gold.ipynb
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/incremental_ingest.ipynb
docker compose exec lab jupyter nbconvert --to notebook --execute --inplace notebooks/push_to_hub.ipynb



## Running Jupyter for Interactive Use

docker compose exec lab pip install duckdb datasets huggingface_hub boto3 Pillow av jupyter
docker compose exec lab jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''



Then open http://localhost:8888 in your browser.

## Notebooks

| Notebook | Purpose |
|---|---|
| ingest_coco.ipynb | Load COCO val from Hugging Face, upload images to RustFS, land annotations in raw |
| ingest_visdrone.ipynb | Upload VisDrone frames to RustFS, build fragment index, land tables in raw |
| raw_to_silver.ipynb | Clean types, deduplicate, fix categories, add schema evolution columns |
| silver_to_gold.ipynb | Build ML ready gold tables, run fragment query and crowded scenes query |
| incremental_ingest.ipynb | Insert 100 new COCO train images into raw to demonstrate a new snapshot |
| version_control.ipynb | Time travel, snapshot comparison, bad transform and rollback demo |
| push_to_hub.ipynb | Export gold.coco_training to Hugging Face Hub |

## Gold Dataset on Hugging Face

https://huggingface.co/datasets/beninod-34/lakehouse-coco-gold

## Credentials

RustFS default credentials are rustfsadmin / rustfsadmin. Change these for any real deployment.