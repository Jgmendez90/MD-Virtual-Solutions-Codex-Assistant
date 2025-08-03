-- Stored Procedures

DELIMITER ;;

CREATE PROCEDURE `load_daily_hierarchy_prod`()
BEGIN
    INSERT INTO bpo001_production.daily_hierarchy_prod (
        EEID, ECID, EMID, ESTATUSCODE, POSITION,
        PROFITCENTER, IO, DATE, EMPPHASE
    )
    SELECT
        s.EEID, s.ECID, s.EMID, s.ESTATUSCODE, s.POSITION,
        s.PROFITCENTER, s.IO, s.DATE, s.EMPPHASE
    FROM bpo001_staging.daily_hierarchy_staging s
    LEFT JOIN bpo001_production.daily_hierarchy_prod p
        ON s.EEID = p.EEID AND s.DATE = p.DATE
    WHERE p.EEID IS NULL;
END ;;

CREATE PROCEDURE `load_iex_raw_prod`()
BEGIN
    DELETE FROM bpo001_production.iex_raw_prod;

    INSERT INTO bpo001_production.iex_raw_prod (
        `date`, `eeid`, `code`, `duration`
    )
    SELECT
        `date`, `eeid`, `code`, `duration`
    FROM bpo001_staging.iex_raw_staging;
END ;;

DELIMITER ;
