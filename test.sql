CREATE TABLE persons
(
  first_name character varying(50),
  last_name character varying(50),
  dob date,
  email character varying(255),
  CONSTRAINT persons_pkey PRIMARY KEY (first_name)
);