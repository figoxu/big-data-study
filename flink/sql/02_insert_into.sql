CREATE TABLE server_logs ( 
    client_ip STRING,
    client_identity STRING, 
    userid STRING, 
    user_agent STRING,
    log_time TIMESTAMP(3),
    request_line STRING, 
    status_code STRING, 
    size INT
) WITH (
  'connector' = 'faker', 
  'fields.client_ip.expression' = '#{Internet.ipV4Address}',
  'fields.client_identity.expression' =  '-',
  'fields.userid.expression' =  '-',
  'fields.user_agent.expression' = '#{Internet.userAgent}',
  'fields.log_time.expression' =  '#{date.past ''15'',''SECONDS''}',
  'fields.request_line.expression' = '#{options.option ''GET'',''POST'',''PUT'',''PATCH''} #{options.option ''/search.html'',''/login.html'',''/prod.html'',''/cart.html'',''/order.html''} #{options.option ''HTTP/1.1'',''HTTP/2'',''HTTP/1.0''}',
  'fields.status_code.expression' = '#{options.option ''200'',''201'',''204'',''400'',''401'',''403'',''301''}',
  'fields.size.expression' = '#{number.numberBetween ''100'',''10000000''}'
);

CREATE TABLE client_errors (
  log_time TIMESTAMP(3),
  request_line STRING,
  status_code STRING,
  size INT
)
WITH (
  'connector' = 'blackhole'
);

INSERT INTO client_errors
SELECT 
  log_time,
  request_line,
  status_code,
  size
FROM server_logs
WHERE 
  status_code SIMILAR TO '4[0-9][0-9]';

SET 'sql-client.execution.result-mode' = 'tableau';


  