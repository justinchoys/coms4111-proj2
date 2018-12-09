


CREATE TABLE agent_employed (
	agentID 		VARCHAR(20),
	name 			VARCHAR(20),
	licenseNo 		VARCHAR(20), 
	phoneNo 		VARCHAR(10),
	rating			REAL,
	agencyID 		VARCHAR(20) NOT NULL,
	since 			DATE,
	PRIMARY KEY (agentID),
	FOREIGN KEY(agencyID) REFERENCES realestateagency
		ON DELETE NO ACTION);