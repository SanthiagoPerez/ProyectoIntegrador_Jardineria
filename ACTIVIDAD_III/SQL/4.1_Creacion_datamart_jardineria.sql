IF DB_ID('datamart_jardineria') IS NOT NULL
BEGIN
    ALTER DATABASE datamart_jardineria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE datamart_jardineria;
END
CREATE DATABASE datamart_jardineria;