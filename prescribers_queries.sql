--  Tennessee Prescribers Database


-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

SELECT npi, SUM(total_claim_count) as total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC

-- The npi number 1881634483 had the highest total number of claims, with 99707

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT npi,
       MAX(doc.nppes_provider_first_name) as first_name, 
       MAX(doc.nppes_provider_last_org_name) as last_name,  
       MAX(doc.specialty_description) as specialty, 
	   SUM(total_claim_count) as total_claims
FROM prescription as rx
LEFT JOIN prescriber as doc
USING(npi)
GROUP BY npi
ORDER BY total_claims DESC


-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT 	specialty_description,
		SUM(total_claim_count) AS total_claims
	
FROM prescription as rx
LEFT JOIN prescriber as doc
USING(npi)
GROUP BY specialty_description
ORDER BY total_claims DESC

-- Family Practice had the highest number of total claims with 9752347 claims. 

--     b. Which specialty had the most total number of claims for opioids?

SELECT 	specialty_description,
		SUM(total_claim_count) AS total_claims
FROM(
	SELECT *
	FROM prescription as rx
	LEFT JOIN prescriber as doc
	USING(npi)
	) AS t1
LEFT JOIN drug AS t2
USING(drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_claims DESC

-- Nurse Practitioner specialty had the most number of opioid prescription claims with a total of 900845.


--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

SELECT *
FROM (SELECT DISTINCT specialty_description
	  FROM prescriber -- There are 107 specialites here
	 ) AS all_specialties
WHERE specialty_description NOT IN (SELECT DISTINCT specialty_description
									FROM prescription as rx
									LEFT JOIN prescriber as doc
									USING(npi) -- There are 92 specialites here
								   )
-- Here's a list of all the specialties not included in the precriptions table 

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?


--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.