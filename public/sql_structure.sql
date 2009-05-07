CREATE TABLE sessions
(
  id serial unique primary key,
  session_id varchar(255) NOT NULL,
  data text,
  created_at timestamp,
  updated_at timestamp
) 
WITH OIDS;
CREATE TABLE roles
(
  id serial unique primary key,
  created_at timestamp,
  updated_at timestamp,
  name text,
  code text,
  active bool default true
);
CREATE TABLE users
(
  id SERIAL UNIQUE PRIMARY KEY,
  created_at timestamp,
  updated_at timestamp,
  name text,
  address text,
  mobile int8,
  email text,
  salt text,
  hashed_password text,
  active bool default true,
  allow_online_access bool default false,
  last_login timestamp
); 