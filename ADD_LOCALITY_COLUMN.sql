-- Add locality column to reports table (if not exists)
ALTER TABLE reports ADD COLUMN IF NOT EXISTS locality TEXT;

-- Backfill locality from address for existing reports
-- This extracts the locality from the address field

-- Update reports where address contains "Arad"
UPDATE reports 
SET locality = 'Arad'
WHERE address ILIKE '%arad%' AND locality IS NULL;

-- Update reports where address contains "București" or "Bucharest"
UPDATE reports 
SET locality = CASE 
    WHEN address ILIKE '%sector 1%' THEN 'Sector 1'
    WHEN address ILIKE '%sector 2%' THEN 'Sector 2'
    WHEN address ILIKE '%sector 3%' THEN 'Sector 3'
    WHEN address ILIKE '%sector 4%' THEN 'Sector 4'
    WHEN address ILIKE '%sector 5%' THEN 'Sector 5'
    WHEN address ILIKE '%sector 6%' THEN 'Sector 6'
    ELSE 'București'
END
WHERE (address ILIKE '%bucurești%' OR address ILIKE '%bucharest%') AND locality IS NULL;

-- Update reports for other major cities
UPDATE reports 
SET locality = CASE 
    WHEN address ILIKE '%cluj-napoca%' OR address ILIKE '%cluj napoca%' THEN 'Cluj-Napoca'
    WHEN address ILIKE '%timișoara%' OR address ILIKE '%timisoara%' THEN 'Timișoara'
    WHEN address ILIKE '%iași%' OR address ILIKE '%iasi%' THEN 'Iași'
    WHEN address ILIKE '%constanța%' OR address ILIKE '%constanta%' THEN 'Constanța'
    WHEN address ILIKE '%craiova%' THEN 'Craiova'
    WHEN address ILIKE '%brașov%' OR address ILIKE '%brasov%' THEN 'Brașov'
    WHEN address ILIKE '%galați%' OR address ILIKE '%galati%' THEN 'Galați'
    WHEN address ILIKE '%ploiești%' OR address ILIKE '%ploiesti%' THEN 'Ploiești'
    WHEN address ILIKE '%oradea%' THEN 'Oradea'
    WHEN address ILIKE '%brăila%' OR address ILIKE '%braila%' THEN 'Brăila'
    WHEN address ILIKE '%pitești%' OR address ILIKE '%pitesti%' THEN 'Pitești'
    WHEN address ILIKE '%sibiu%' THEN 'Sibiu'
    WHEN address ILIKE '%bacău%' OR address ILIKE '%bacau%' THEN 'Bacău'
    WHEN address ILIKE '%târgu mureș%' OR address ILIKE '%targu mures%' THEN 'Târgu Mureș'
    WHEN address ILIKE '%baia mare%' THEN 'Baia Mare'
    WHEN address ILIKE '%buzău%' OR address ILIKE '%buzau%' THEN 'Buzău'
    WHEN address ILIKE '%botoșani%' OR address ILIKE '%botosani%' THEN 'Botoșani'
    WHEN address ILIKE '%satu mare%' THEN 'Satu Mare'
    WHEN address ILIKE '%suceava%' THEN 'Suceava'
    WHEN address ILIKE '%piatra neamț%' OR address ILIKE '%piatra neamt%' THEN 'Piatra Neamț'
END
WHERE locality IS NULL;

-- For remaining reports, try to extract locality from address
-- This assumes format: "Street, Locality, County"
UPDATE reports
SET locality = TRIM(SPLIT_PART(address, ',', 2))
WHERE locality IS NULL 
  AND address IS NOT NULL 
  AND address LIKE '%,%,%'
  AND LENGTH(TRIM(SPLIT_PART(address, ',', 2))) > 2;

-- Verify the update
SELECT 
    judet,
    locality,
    COUNT(*) as report_count
FROM reports
GROUP BY judet, locality
ORDER BY judet, locality;


-- Update specific localities in Timiș county
UPDATE reports 
SET locality = 'Bazoșu Nou'
WHERE (address ILIKE '%bazoșu nou%' OR address ILIKE '%bazosu nou%') 
  AND locality IS NULL;

-- Update other localities in Timiș
UPDATE reports 
SET locality = CASE 
    WHEN address ILIKE '%lugoj%' THEN 'Lugoj'
    WHEN address ILIKE '%sânnicolau mare%' OR address ILIKE '%sannicolau mare%' THEN 'Sânnicolau Mare'
    WHEN address ILIKE '%jimbolia%' THEN 'Jimbolia'
    WHEN address ILIKE '%făget%' OR address ILIKE '%faget%' THEN 'Făget'
    WHEN address ILIKE '%buziaș%' OR address ILIKE '%buzias%' THEN 'Buziaș'
    WHEN address ILIKE '%deta%' THEN 'Deta'
    WHEN address ILIKE '%recaș%' OR address ILIKE '%recas%' THEN 'Recaș'
    WHEN address ILIKE '%ciacova%' THEN 'Ciacova'
    WHEN address ILIKE '%gătaia%' OR address ILIKE '%gataia%' THEN 'Gătaia'
END
WHERE judet = 'Timiș' AND locality IS NULL;

-- Verify Timiș reports
SELECT 
    id,
    address,
    judet,
    locality
FROM reports
WHERE judet = 'Timiș'
ORDER BY locality;
