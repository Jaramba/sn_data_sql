WITH all_targets as (

SELECT 
	targets.*,
	DATEDIFF(DAY, targets.startdate, targets.enddate)+1 AS DaysBetween,
    CAST (time_db."Date" AS DATE) As TargetDate
FROM dbo.SalesTargets AS targets
LEFT JOIN Auxiliary.Calendar AS time_db ON 
time_db.Date BETWEEN targets.StartDate AND targets.EndDate )

   SELECT all_targets.* ,
   all_targets.Targets/all_targets.DaysBetween AS DailyTarget
  
   FROM all_targets
   
   DROP TABLE MonthlyBranchTargets