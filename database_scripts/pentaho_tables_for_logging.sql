-- Transformation log table
--

CREATE TABLE colfusion_pentaho_log_transformaion
(
  ID_BATCH INT
, CHANNEL_ID VARCHAR(255)
, TRANSNAME VARCHAR(255)
, STATUS VARCHAR(15)
, LINES_READ BIGINT
, LINES_WRITTEN BIGINT
, LINES_UPDATED BIGINT
, LINES_INPUT BIGINT
, LINES_OUTPUT BIGINT
, LINES_REJECTED BIGINT
, ERRORS BIGINT
, STARTDATE DATETIME
, ENDDATE DATETIME
, LOGDATE DATETIME
, DEPDATE DATETIME
, REPLAYDATE DATETIME
, LOG_FIELD MEDIUMTEXT
)
;
CREATE INDEX IDX_colfusion_pentaho_log_transformaion_1
 ON colfusion_pentaho_log_transformaion
( 
  ID_BATCH
)
;
CREATE INDEX IDX_colfusion_pentaho_log_transformaion_2
 ON colfusion_pentaho_log_transformaion
( 
  ERRORS
, STATUS
, TRANSNAME
)
;


-- Step log table
--

CREATE TABLE colfusion_pentaho_log_step
(
  ID_BATCH INT
, CHANNEL_ID VARCHAR(255)
, LOG_DATE DATETIME
, TRANSNAME VARCHAR(255)
, STEPNAME VARCHAR(255)
, STEP_COPY INT
, LINES_READ BIGINT
, LINES_WRITTEN BIGINT
, LINES_UPDATED BIGINT
, LINES_INPUT BIGINT
, LINES_OUTPUT BIGINT
, LINES_REJECTED BIGINT
, ERRORS BIGINT
, LOG_FIELD MEDIUMTEXT
)
;

-- Step performance log table
--

CREATE TABLE colfusion_pentaho_log_performance
(
  ID_BATCH INT
, SEQ_NR INT
, LOGDATE DATETIME
, TRANSNAME VARCHAR(255)
, STEPNAME VARCHAR(255)
, STEP_COPY INT
, LINES_READ BIGINT
, LINES_WRITTEN BIGINT
, LINES_UPDATED BIGINT
, LINES_INPUT BIGINT
, LINES_OUTPUT BIGINT
, LINES_REJECTED BIGINT
, ERRORS BIGINT
, INPUT_BUFFER_ROWS BIGINT
, OUTPUT_BUFFER_ROWS BIGINT
)
;

-- Logging channel log table
--

CREATE TABLE colfusion_pentaho_log_logging_channels
(
  ID_BATCH INT
, CHANNEL_ID VARCHAR(255)
, LOG_DATE DATETIME
, LOGGING_OBJECT_TYPE VARCHAR(255)
, OBJECT_NAME VARCHAR(255)
, OBJECT_COPY VARCHAR(255)
, REPOSITORY_DIRECTORY VARCHAR(255)
, FILENAME VARCHAR(255)
, OBJECT_ID VARCHAR(255)
, OBJECT_REVISION VARCHAR(255)
, PARENT_CHANNEL_ID VARCHAR(255)
, ROOT_CHANNEL_ID VARCHAR(255)
)
;