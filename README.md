Name: Yong Sik Cho (yc3522), Mendy Xu (mx2207)

PostgreSQL Account: yc3522

Description:

From our original schema we have added the following attributes:

Composite type: address (address attribute for Property and agent_employed tables)
	- This composite type holds three subfields in the following order: (street, city, state, zipcode, zone)
	- an example of this would be ("100 Madison Ave", "New York", "NY", 10016, "Nomad")
	- this allows users to query to specific states (if we expand our database to include New Jersey, Boston and other states) as well as with respect to zones (e.g. Midtown East, Upper West Side)

Array type: pmts (loan payment record to date for borrows table)
	- This represents an integer array of variable length that records the monthly mortgage payment for all buyers who took out a loan to purchase the property
	- Note that monthly payment amounts are equal installments over the 'term' field in years, with the interest rate included in the payments
	- This allows users to check the payment records of individuals who have taken out a mortgage and check if 

Document type: rev, des (review and description for agent_employed and property tables)
	- There are text fields (rev_text and des_text) which have been converted into tsvector fields for both agent reviews and property descriptions
	- Agent review represent a brief overview of customer reviews for each agent, which allows users to query for specific features (i.e. "professional", "fast")
	- Property descriptions represent a quick overview of the property and its features, which allows users to query for specific features of the property (i.e. "laundry", "washer", "luxury")


Total (attributes, table name)[type] added:

(address, property)[composite] ***
(address, agent_employed)[composite] ***
(pmts, borrows)[array] ***
(rev, agent_employed)[document] ***
(des, property)[document]

*** denotes attributes we are using for our query examples

Please see below for the three queries we have created to test out the new attributes.

########################################################################

Query 1:

select yearbuilt, (address).street, (address).zip, type, bano, brno, askprice, listdate
from property, sell
where (address).zone = 'Upper West Side' and property.propertyID = sell.propertyid
order by listdate desc;


OUTPUT:

 yearbuilt |           street            |  zip  | type  | bano | brno | askprice |  listdate  
-----------+-----------------------------+-------+-------+------+------+----------+------------
      2018 | 173-175 Riverside Drive 11D | 10024 | co-op |    4 |    3 | 12000000 | 2016-10-18
      2007 | 15 Central Park West 3C     | 10023 | condo |    3 |    2 | 15800000 | 2016-02-29
      1988 | 21 S End Ave Apt 629        | 10023 | condo |    1 |    1 |  1250000 | 2013-09-28
      2012 | 100 Riverside Blvd 9B       | 10069 | condo |    1 |    1 |  5450000 | 2012-03-30
(4 rows)

This query searches for key information for properties in the Upper West Side which is a subfield attribute for the address field (adrs composite type).
This is a useful feature for users who want to look up locations and prices by neighborhoods, which is easier to query than zipcode or street addresses.


########################################################################


Query 2:

select buyer.grossincome, buyer.bage, buy.dealdate, buy.dealprice, borrows.amount, borrows.interestrate, borrows.term, borrows.pmts[1:5]
from buy full outer join borrows
		on (buy.buyerid = borrows.buyerid AND buy.bage = borrows.bage AND buy.dealdate = borrows.dealdate AND buy.propertyid = borrows.propertyid), property, buyer
where buy.propertyid = property.propertyid AND buy.buyerid = buyer.buyerid AND buy.bage = buyer.bage
order by buy.dealdate desc;


OUTPUT:

 grossincome | bage |  dealdate  | dealprice |  amount   | interestrate | term |              pmts               
-------------+------+------------+-----------+-----------+--------------+------+---------------------------------
      145000 |   34 | 2017-12-28 |    675000 |           |              |      | 
      375000 |   26 | 2017-05-19 |  13500000 |   8.1e+06 |          4.5 |   30 | {41042,41042,41042,41042,41042}
      350000 |   35 | 2017-02-15 |  11750000 |   9.4e+06 |            4 |   15 | {69531,69531,69531,69531,69531}
      250000 |   43 | 2017-01-01 |   3150000 |  1.26e+06 |          4.5 |   10 | {13058,13058,13058,13058,13058}
      285000 |   42 | 2016-12-22 |   1875000 |    750000 |          4.6 |   15 | {5776,5776,5776,5776,5776}
      225000 |   39 | 2016-12-21 |   1550000 | 1.085e+06 |          3.7 |   15 | {7863,7863,7863,7863,7863}
      700000 |   34 | 2016-12-20 |  15650000 | 7.825e+06 |          4.7 |   30 | {40583,40583,40583,40583,40583}
      250000 |   44 | 2016-11-17 |    975000 |    682500 |          4.2 |   30 | {3338,3338,3338,3338,3338}
      230000 |   33 | 2015-12-17 |   2375000 |           |              |      | 
       90000 |   32 | 2015-12-16 |    495000 |           |              |      | 
      150000 |   33 | 2015-07-10 |    600000 |           |              |      | 
      120000 |   32 | 2015-06-19 |    450000 |           |              |      | 
      150000 |   23 | 2015-04-08 |    739000 |           |              |      | 
      375000 |   28 | 2014-12-13 |   5250000 | 2.625e+06 |          3.7 |   30 | {12082,12082,12082,12082,12082}
      280000 |   28 | 2014-04-04 |   1575000 |    945000 |         4.32 |   30 | {4688,4688,4688,4688,4688}
      135000 |   23 | 2014-03-01 |   1250000 |    750000 |         4.34 |   30 | {3729,3729,3729,3729,3729}
      165000 |   28 | 2014-02-03 |    978000 |    586800 |          4.3 |   30 | {2904,2904,2904,2904,2904}
      185000 |   30 | 2013-12-03 |    865000 |    519000 |         4.46 |   30 | {2617,2617,2617,2617,2617}
(18 rows)

This query provides an overview of all real estate purchases and displays key information about the finances and timing of the purchases.
For example, a buyer can use this information to gauge the types of people who took out mortgages based on income, age.
The table also provides very useful information about the interate rate, term and what those variables mean for monthly payments (pmts)
Note that we have only chosen to display the first 5 payments in the pmts array in this example for formatting purposes.
A user can choose to display all payment records or even limit the search to instances where array_length(pmts) < 24 to find mortgages that have been paid for less than two years.


########################################################################


Query 3:

select agent_employed.agentid, agent_employed.name, agent_employed.licenseno, agent_employed.rating, realestateagency.name as agencyname, (agent_employed.address).zone , agent_employed.phoneno 
from agent_employed, realestateagency
where agent_employed.agencyid = realestateagency.agencyid and rev @@ to_tsquery('professional & fast');


OUTPUT:

 agentid |      name       | licenseno | rating | agencyname |      zone      |  phoneno   
---------+-----------------+-----------+--------+------------+----------------+------------
 sc8642  | Steve Cohen     | 786423154 |    4.5 | Corcoran   | Nomad          | 2128361029
 rv9302  | Robert Vessey   | 245468712 |    4.9 | Corcoran   | Midtown East   | 2126452111
 sf4309  | Stacey Froelich | 145461212 |    4.6 | Compass    | Manhattanville | 8554238964
(3 rows)

 This query is a neat feature that allows users to query reviews for agents and see which agents have reviews that contain certain keywords.
 In this example, the user queries for agent's who have been described as "professional" and "fast", most likely because the user is looking for a high quality agent who likely has high reviews too.


 ########################################################################

