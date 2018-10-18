SELECT 
COUNT( DISTINCT (x_resultid2))	AS "Id",
x_surveydate		AS "Date",
x_long 	AS "Latitude",
x_lat	AS "Longitude"

FROM x_ext_responses
GROUP BY
x_surveydate,
x_long,
x_lat

SELECT * FROM x_ext_responses LIMIT 10