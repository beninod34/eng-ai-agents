DROP TABLE IF EXISTS gold.coco_training;
CREATE TABLE gold.coco_training AS
SELECT image_uri, category, bbox_x, bbox_y, bbox_w, bbox_h, split
FROM silver.coco_annotations;

DROP TABLE IF EXISTS gold.visdrone_training;
CREATE TABLE gold.visdrone_training AS
SELECT clip_uri, fragment_id, frame_id, x, y, w, h, category
FROM silver.visdrone_annotations
WHERE category != 'ignored';
