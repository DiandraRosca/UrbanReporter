-- =====================================================
-- ADD JUDEȚ (COUNTY) COLUMNS FOR ADMIN FILTERING
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Add judet column to reports table
ALTER TABLE reports 
ADD COLUMN IF NOT EXISTS judet TEXT;

-- 2. Add assigned_judet column to profiles table (for admin filtering preference)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS assigned_judet TEXT;

-- 3. Create index for faster filtering by judet
CREATE INDEX IF NOT EXISTS idx_reports_judet ON reports(judet);

-- 4. Optional: Backfill existing reports by extracting judet from address
-- This attempts to extract the county name from the address field
-- Romanian addresses typically contain the county name

-- Common Romanian județe patterns to look for in addresses
-- Note: This is a best-effort extraction - some may need manual correction

UPDATE reports
SET judet = 
  CASE
    -- Extract județ from address if it contains "Județul" or "jud."
    WHEN address ILIKE '%Județul Alba%' OR address ILIKE '%jud. Alba%' OR address ILIKE '%, Alba,%' THEN 'Alba'
    WHEN address ILIKE '%Județul Arad%' OR address ILIKE '%jud. Arad%' OR address ILIKE '%, Arad,%' THEN 'Arad'
    WHEN address ILIKE '%Județul Argeș%' OR address ILIKE '%jud. Argeș%' OR address ILIKE '%, Argeș,%' THEN 'Argeș'
    WHEN address ILIKE '%Județul Bacău%' OR address ILIKE '%jud. Bacău%' OR address ILIKE '%, Bacău,%' THEN 'Bacău'
    WHEN address ILIKE '%Județul Bihor%' OR address ILIKE '%jud. Bihor%' OR address ILIKE '%, Bihor,%' THEN 'Bihor'
    WHEN address ILIKE '%Județul Bistrița-Năsăud%' OR address ILIKE '%jud. Bistrița%' OR address ILIKE '%, Bistrița%' THEN 'Bistrița-Năsăud'
    WHEN address ILIKE '%Județul Botoșani%' OR address ILIKE '%jud. Botoșani%' OR address ILIKE '%, Botoșani,%' THEN 'Botoșani'
    WHEN address ILIKE '%Județul Brașov%' OR address ILIKE '%jud. Brașov%' OR address ILIKE '%, Brașov,%' THEN 'Brașov'
    WHEN address ILIKE '%Județul Brăila%' OR address ILIKE '%jud. Brăila%' OR address ILIKE '%, Brăila,%' THEN 'Brăila'
    WHEN address ILIKE '%București%' OR address ILIKE '%Bucharest%' THEN 'București'
    WHEN address ILIKE '%Județul Buzău%' OR address ILIKE '%jud. Buzău%' OR address ILIKE '%, Buzău,%' THEN 'Buzău'
    WHEN address ILIKE '%Județul Caraș-Severin%' OR address ILIKE '%jud. Caraș%' OR address ILIKE '%, Caraș%' THEN 'Caraș-Severin'
    WHEN address ILIKE '%Județul Călărași%' OR address ILIKE '%jud. Călărași%' OR address ILIKE '%, Călărași,%' THEN 'Călărași'
    WHEN address ILIKE '%Județul Cluj%' OR address ILIKE '%jud. Cluj%' OR address ILIKE '%, Cluj,%' THEN 'Cluj'
    WHEN address ILIKE '%Județul Constanța%' OR address ILIKE '%jud. Constanța%' OR address ILIKE '%, Constanța,%' THEN 'Constanța'
    WHEN address ILIKE '%Județul Covasna%' OR address ILIKE '%jud. Covasna%' OR address ILIKE '%, Covasna,%' THEN 'Covasna'
    WHEN address ILIKE '%Județul Dâmbovița%' OR address ILIKE '%jud. Dâmbovița%' OR address ILIKE '%, Dâmbovița,%' THEN 'Dâmbovița'
    WHEN address ILIKE '%Județul Dolj%' OR address ILIKE '%jud. Dolj%' OR address ILIKE '%, Dolj,%' THEN 'Dolj'
    WHEN address ILIKE '%Județul Galați%' OR address ILIKE '%jud. Galați%' OR address ILIKE '%, Galați,%' THEN 'Galați'
    WHEN address ILIKE '%Județul Giurgiu%' OR address ILIKE '%jud. Giurgiu%' OR address ILIKE '%, Giurgiu,%' THEN 'Giurgiu'
    WHEN address ILIKE '%Județul Gorj%' OR address ILIKE '%jud. Gorj%' OR address ILIKE '%, Gorj,%' THEN 'Gorj'
    WHEN address ILIKE '%Județul Harghita%' OR address ILIKE '%jud. Harghita%' OR address ILIKE '%, Harghita,%' THEN 'Harghita'
    WHEN address ILIKE '%Județul Hunedoara%' OR address ILIKE '%jud. Hunedoara%' OR address ILIKE '%, Hunedoara,%' THEN 'Hunedoara'
    WHEN address ILIKE '%Județul Ialomița%' OR address ILIKE '%jud. Ialomița%' OR address ILIKE '%, Ialomița,%' THEN 'Ialomița'
    WHEN address ILIKE '%Județul Iași%' OR address ILIKE '%jud. Iași%' OR address ILIKE '%, Iași,%' THEN 'Iași'
    WHEN address ILIKE '%Județul Ilfov%' OR address ILIKE '%jud. Ilfov%' OR address ILIKE '%, Ilfov,%' THEN 'Ilfov'
    WHEN address ILIKE '%Județul Maramureș%' OR address ILIKE '%jud. Maramureș%' OR address ILIKE '%, Maramureș,%' THEN 'Maramureș'
    WHEN address ILIKE '%Județul Mehedinți%' OR address ILIKE '%jud. Mehedinți%' OR address ILIKE '%, Mehedinți,%' THEN 'Mehedinți'
    WHEN address ILIKE '%Județul Mureș%' OR address ILIKE '%jud. Mureș%' OR address ILIKE '%, Mureș,%' THEN 'Mureș'
    WHEN address ILIKE '%Județul Neamț%' OR address ILIKE '%jud. Neamț%' OR address ILIKE '%, Neamț,%' THEN 'Neamț'
    WHEN address ILIKE '%Județul Olt%' OR address ILIKE '%jud. Olt%' OR address ILIKE '%, Olt,%' THEN 'Olt'
    WHEN address ILIKE '%Județul Prahova%' OR address ILIKE '%jud. Prahova%' OR address ILIKE '%, Prahova,%' THEN 'Prahova'
    WHEN address ILIKE '%Județul Satu Mare%' OR address ILIKE '%jud. Satu Mare%' OR address ILIKE '%, Satu Mare,%' THEN 'Satu Mare'
    WHEN address ILIKE '%Județul Sălaj%' OR address ILIKE '%jud. Sălaj%' OR address ILIKE '%, Sălaj,%' THEN 'Sălaj'
    WHEN address ILIKE '%Județul Sibiu%' OR address ILIKE '%jud. Sibiu%' OR address ILIKE '%, Sibiu,%' THEN 'Sibiu'
    WHEN address ILIKE '%Județul Suceava%' OR address ILIKE '%jud. Suceava%' OR address ILIKE '%, Suceava,%' THEN 'Suceava'
    WHEN address ILIKE '%Județul Teleorman%' OR address ILIKE '%jud. Teleorman%' OR address ILIKE '%, Teleorman,%' THEN 'Teleorman'
    WHEN address ILIKE '%Județul Timiș%' OR address ILIKE '%jud. Timiș%' OR address ILIKE '%, Timiș,%' OR address ILIKE '%Timișoara%' THEN 'Timiș'
    WHEN address ILIKE '%Județul Tulcea%' OR address ILIKE '%jud. Tulcea%' OR address ILIKE '%, Tulcea,%' THEN 'Tulcea'
    WHEN address ILIKE '%Județul Vaslui%' OR address ILIKE '%jud. Vaslui%' OR address ILIKE '%, Vaslui,%' THEN 'Vaslui'
    WHEN address ILIKE '%Județul Vâlcea%' OR address ILIKE '%jud. Vâlcea%' OR address ILIKE '%, Vâlcea,%' THEN 'Vâlcea'
    WHEN address ILIKE '%Județul Vrancea%' OR address ILIKE '%jud. Vrancea%' OR address ILIKE '%, Vrancea,%' THEN 'Vrancea'
    ELSE NULL -- Will show as 'Necunoscut' in the app
  END
WHERE judet IS NULL AND address IS NOT NULL;

-- 5. Verify the changes
SELECT 
  'Reports with judet' as info,
  COUNT(*) FILTER (WHERE judet IS NOT NULL) as with_judet,
  COUNT(*) FILTER (WHERE judet IS NULL) as without_judet,
  COUNT(*) as total
FROM reports;

-- Show distribution by judet
SELECT judet, COUNT(*) as count 
FROM reports 
WHERE judet IS NOT NULL 
GROUP BY judet 
ORDER BY count DESC;
