\copy realestateagency(agencyID, name) from 'realestateagency.csv' delimiter ',' csv header;
\copy agent_employed(agentID, name, licenseNo, phoneNo, rating, agencyID, since, address, rev_text) from 'agent_employed.csv' delimiter ',' csv header;
\copy seller(sellerID, sAge, sGender, sHHsize) from 'seller.csv' delimiter ',' csv header;
\copy buyer(buyerID, bGender, bAge, grossIncome, bHHsize) from 'buyer.csv' delimiter ',' csv header;
\copy property(propertyID, address, yearBuilt, type, size, baNo, brNo, des_text) from 'property.csv' delimiter ',' csv header;
\copy buy(buyerID, bAge, propertyID, dealDate, dealPrice) from 'buy.csv' delimiter ',' csv header;
\copy sell(sellerID, sAge, propertyID, listDate, askPrice) from 'sell.csv' delimiter ',' csv header;
\copy sell_hire(sellerID, sAge, listDate, propertyID, agentID, sCommision, sStartDate, sEndDate) from 'sell_hire.csv' delimiter ',' csv header;
\copy buy_hire(buyerID, bAge, dealDate, propertyID, agentID, bCommision, bStartDate, bEndDate) from 'buy_hire.csv' delimiter ',' csv header;
\copy lender(lenderID, lenderName) from 'lender.csv' delimiter ',' csv header;
\copy borrows(buyerID, bAge, dealDate, propertyID, lenderID, mortgageID, term, amount, interestRate, pmts) from 'borrows.csv' delimiter ',' csv header;

update agent_employed d1
set rev = to_tsvector(d1.rev_text)
from agent_employed d2;

update property p1
set des = to_tsvector(p1.des_text)
from property p2;
