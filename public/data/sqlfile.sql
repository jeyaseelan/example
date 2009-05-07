CREATE TABLE dollars
(
  id serial NOT NULL,
  updated_at timestamp without time zone,
  "name" text,
  mobile text,
  email text,
  active boolean DEFAULT true,
  CONSTRAINT dollars_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE);
ALTER TABLE dollars OWNER TO postgres;
