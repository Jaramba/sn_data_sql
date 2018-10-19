WITH TablesAndRowCounts
AS (
    SELECT SCHEMA_NAME(sc.schema_id) SchemaName
        ,sc.NAME + '.' + ta.NAME TableName
        ,SUM(pa.rows) RowCnt
    FROM systables ta
    INNER JOIN sys.partitions pa ON pa.OBJECT_ID = ta.OBJECT_ID
    INNER JOIN sys.schemas sc ON ta.schema_id = sc.schema_id
    WHERE ta.is_ms_shipped = 0
        AND pa.index_id IN (1,0)
    GROUP BY sc.schema_id
        ,sc.NAME
        ,ta.NAME
    )
SELECT *
FROM TablesAndRowCounts
WHERE rowcnt = 0
and SchemaName = 'public'

SELECT *FROM  fleet_vehicle_model

SELECT 
	relname,
	seq_tup_read,
	idx_tup_fetch,
	cast(idx_tup_fetch AS numeric) / (idx_tup_fetch + seq_tup_read) AS idx_tup_pct
FROM pg_stat_user_tables 
WHERE 
(idx_tup_fetch + seq_tup_read)>0
ORDER BY idx_tup_pct;