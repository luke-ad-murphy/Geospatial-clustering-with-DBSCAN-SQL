/* ================================================================================================= */
/* CREATE A SAMPLE DATASET FOR DEPLOYMENT RECOMMENDATION ALGORITHM TESTING */
/* ================================================================================================= */


## Declare area of interest
DECLARE AOI STRING;

# CENTRAL FLORIDA AREA
SET AOI = "POLYGON ((-0.20200393952245577 51.56017678043207, -0.20200393952245577 51.44098055358543, 0.1380627839724582 51.44098055358543, 0.1380627839724582 51.56017678043207, -0.20200393952245577 51.56017678043207))";



#####################################################################################################################
#####################################################################################################################
#####################################################################################################################

#### DATA COLLECTION AND PROCESSING

-- GENERATE SOME POINTS DATA THAT FALLS WITHIN THE BOUNDING BOX ABOVE
-- THE BOUDING BOX RELATES TO THE SAMPLE GRID (HEXBIN) DATA PROVIDED

-- YOUR SAMPLE SHOULD BE CALLED 'Sample_measurements' AND INCLUDE ATTRIBUTES:

--             MNO
--             ,RSRP
--             ,RSSNR
--             ,ST_GEOGPOINT(CAST(Longitude AS float64), CAST(Latitude AS float64)) AS POINT
--             ,ROW_NUMBER() OVER (ORDER BY Latitude DESC) AS urn,



###########################################################################################
###########################################################################################
###########################################################################################

-- LOAD IN THE SAMPLE GRID as 'Grid'
# Apply grid ref to point data
CREATE OR REPLACE TEMP TABLE `Sample_measurements` as (
SELECT      meas.*
            ,grid.grid_id
FROM        `Sample_measurements` AS meas
            ,`Grid` AS grid
WHERE       1 = 1
AND         ST_INTERSECTS(meas.POINT, grid.boundary)
);


###########################################################################################
###########################################################################################
###########################################################################################

# Analysis by grid
CREATE OR REPLACE TABLE `YOUR-PROJECT.SUMMARY` as (
SELECT  grid_id
        ,MNO
        ,count(*) AS Measurements
         -- Create 25th percentile of key metrics
        ,APPROX_QUANTILES(RSSNR, 100)[OFFSET(25)] AS RSSNR_25
        ,APPROX_QUANTILES(RSRP, 100)[OFFSET(25)] AS RSRP_25
         -- Create mean of key metrics
        ,AVG(RSSNR) AS RSSNR_MEAN
        ,AVG(RSRP) AS RSRP_MEAN
FROM    `Sample_measurements`
GROUP BY  grid_id
          ,MNO
);



#####################################################################################################################
#####################################################################################################################
#####################################################################################################################


#### RETRIEVE GEOGRAPHY FOR GRID
CREATE OR REPLACE TABLE `YOUR-PROJECT.SAMPLE` as (
SELECT dps.*
      ,grid.boundary
from `YOUR-PROJECT.SAMPLE`as dps
LEFT JOIN `Grid` as grid
ON dps.grid_id = grid.grid_id
);



#####################################################################################################################
#####################################################################################################################
############################################# END OF PRGOGRAM #######################################################
#####################################################################################################################
#####################################################################################################################
