DROP TABLE IF EXISTS silver.coco_annotations;
CREATE TABLE silver.coco_annotations AS
SELECT DISTINCT ON (bbox_id)
    image_uri,
    image_id,
    width,
    height,
    bbox_id,
    CASE category
        WHEN 0 THEN 'person' WHEN 1 THEN 'bicycle' WHEN 2 THEN 'car'
        WHEN 3 THEN 'motorcycle' WHEN 4 THEN 'airplane' WHEN 5 THEN 'bus'
        WHEN 6 THEN 'train' WHEN 7 THEN 'truck' WHEN 8 THEN 'boat'
        WHEN 9 THEN 'traffic light' WHEN 10 THEN 'fire hydrant'
        WHEN 11 THEN 'stop sign' WHEN 12 THEN 'parking meter'
        WHEN 13 THEN 'bench' WHEN 14 THEN 'bird' WHEN 15 THEN 'cat'
        WHEN 16 THEN 'dog' WHEN 17 THEN 'horse' WHEN 18 THEN 'sheep'
        WHEN 19 THEN 'cow' WHEN 20 THEN 'elephant' WHEN 21 THEN 'bear'
        WHEN 22 THEN 'zebra' WHEN 23 THEN 'giraffe' WHEN 24 THEN 'backpack'
        WHEN 25 THEN 'umbrella' WHEN 26 THEN 'handbag' WHEN 27 THEN 'tie'
        WHEN 28 THEN 'suitcase' WHEN 29 THEN 'frisbee' WHEN 30 THEN 'skis'
        WHEN 31 THEN 'snowboard' WHEN 32 THEN 'sports ball' WHEN 33 THEN 'kite'
        WHEN 34 THEN 'baseball bat' WHEN 35 THEN 'baseball glove'
        WHEN 36 THEN 'skateboard' WHEN 37 THEN 'surfboard'
        WHEN 38 THEN 'tennis racket' WHEN 39 THEN 'bottle'
        WHEN 40 THEN 'wine glass' WHEN 41 THEN 'cup' WHEN 42 THEN 'fork'
        WHEN 43 THEN 'knife' WHEN 44 THEN 'spoon' WHEN 45 THEN 'bowl'
        WHEN 46 THEN 'banana' WHEN 47 THEN 'apple' WHEN 48 THEN 'sandwich'
        WHEN 49 THEN 'orange' WHEN 50 THEN 'broccoli' WHEN 51 THEN 'carrot'
        WHEN 52 THEN 'hot dog' WHEN 53 THEN 'pizza' WHEN 54 THEN 'donut'
        WHEN 55 THEN 'cake' WHEN 56 THEN 'chair' WHEN 57 THEN 'couch'
        WHEN 58 THEN 'potted plant' WHEN 59 THEN 'bed'
        WHEN 60 THEN 'dining table' WHEN 61 THEN 'toilet' WHEN 62 THEN 'tv'
        WHEN 63 THEN 'laptop' WHEN 64 THEN 'mouse' WHEN 65 THEN 'remote'
        WHEN 66 THEN 'keyboard' WHEN 67 THEN 'cell phone'
        WHEN 68 THEN 'microwave' WHEN 69 THEN 'oven' WHEN 70 THEN 'toaster'
        WHEN 71 THEN 'sink' WHEN 72 THEN 'refrigerator' WHEN 73 THEN 'book'
        WHEN 74 THEN 'clock' WHEN 75 THEN 'vase' WHEN 76 THEN 'scissors'
        WHEN 77 THEN 'teddy bear' WHEN 78 THEN 'hair drier'
        WHEN 79 THEN 'toothbrush'
    END AS category,
    CAST(regexp_extract(bbox, '\[([0-9.]+),', 1) AS DOUBLE) AS bbox_x,
    CAST(regexp_extract(bbox, '\[[0-9.]+,\s*([0-9.]+),', 1) AS DOUBLE) AS bbox_y,
    CAST(regexp_extract(bbox, '\[[0-9.]+,\s*[0-9.]+,\s*([0-9.]+),', 1) AS DOUBLE) AS bbox_w,
    CAST(regexp_extract(bbox, '\[[0-9.]+,\s*[0-9.]+,\s*[0-9.]+,\s*([0-9.]+)\]', 1) AS DOUBLE) AS bbox_h,
    area,
    'val' AS split
FROM raw.coco_annotations
WHERE area > 0;

DROP TABLE IF EXISTS silver.visdrone_annotations;
CREATE TABLE silver.visdrone_annotations AS
SELECT DISTINCT ON (clip_uri, frame_id, target_id)
    clip_uri,
    sequence,
    fragment_id,
    frame_id,
    target_id,
    x, y, w, h,
    (w * h) AS area,
    category,
    truncation,
    occlusion
FROM raw.visdrone_annotations
WHERE category != 'ignored';

DROP TABLE IF EXISTS silver.visdrone_fragments;
CREATE TABLE silver.visdrone_fragments AS
SELECT * FROM raw.visdrone_fragments;
