-- Drop the existing Zone table if it exists
DROP TABLE IF EXISTS "Zone";

-- Create a new Zone table
CREATE TABLE "Zone" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "country" TEXT,
  "city" TEXT,
  "descriptions" TEXT,
  "required_pass" TEXT,
  "minimum_euro" TEXT
);

-- Use INSERT INTO without table name in SQLite
INSERT INTO "Zone" ("country", "city", "descriptions", "required_pass", "minimum_euro")
VALUES 
  ('France', 'Paris', 'Beautiful city with many green spaces.', 'GreenPass123', '50'),
  ('Germany', 'Berlin', 'Capital city with parks and recreational areas.', 'EcoPass456', '40'),
  ('Italy', 'Rome', 'Historic city with parks and gardens.', 'NaturePass789', '55'),
  ('Spain', 'Madrid', 'Vibrant city with green zones and outdoor activities.', 'MadGreenPass', '45'),
  ('United Kingdom', 'London', 'Large city with various parks and green initiatives.', 'LondonGreen123', '60');
