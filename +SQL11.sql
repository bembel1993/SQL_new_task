-- ex 1
SELECT
    'XPath example' AS 'head/title',
    'This example demonstrates ' AS 'body/p',
    'https://www.w3.org/TR/xpath/' AS 'body/p/a/@href',
    'XPath expressions' AS 'body/p/a'
FOR XML PATH('html');
--Bembel_lab4
--1.	???????? XML ???? ?? ?????? ???? ?????? ?????????? ????:
--1.1.	???????? XML: Office List ? Region ? City ? Employee.
--1.2.	???????? ????????? ???????? ?Office List?, ??????? ? Employee_Count (????? ?????????? ???????????).
CREATE VIEW EMPL_COUNT AS
SELECT COUNT(EMPL_NUM) AS EMPLOYEE_COUNT 
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.MANAGER = O.MGR

SELECT * FROM EMPL_COUNT

--1.3.	??????? Region, ???????? ? Region_Name (???????????? ???????), Region_Employee_Count (????? ?????????? ??????????? ? ???????).
CREATE VIEW REGION_EMPL_COUNT AS
SELECT O.REGION, 
	   COUNT(MGR) AS REGION_EMPLOYEE_COUNT
FROM OFFICES O LEFT JOIN SALESREPS S 
ON O.OFFICE = S.REP_OFFICE
GROUP BY REGION

SELECT * FROM REGION_EMPL_COUNT

DROP VIEW EMPL_COUNT
SELECT * FROM SALESREPS
SELECT * FROM OFFICES

--1.4.	??????? City, ???????? ? City_Name (???????????? ??????), City_Employee_Count (????? ?????????? ??????????? ? ??????), 
--City_Chef (??????? ???????????? ?????????????).
CREATE VIEW CITY_OFFICE_COUNT AS
SELECT	o.City,
		COUNT(s.EMPL_NUM) AS City_Employee_Count,
		MIN(o.Region) AS Region,
		MIN(o.City_Chef) AS City_Chef,
		MIN(o.Office) AS Office
FROM office_heads o JOIN SALESREPS s 
ON o.OFFICE = s.REP_OFFICE
GROUP BY city;

SELECT * FROM CITY_OFFICE_COUNT
DROP VIEW CITY_OFFICE_COUNT
DROP VIEW OFFICE_HEADS
--//////////////////////////////////////////
CREATE VIEW OFFICE_HEADS AS
SELECT	o.city AS City,
		o.region AS Region,
		s.name AS City_Chef,
		o.office AS Office
FROM OFFICES o LEFT JOIN SALESREPS s 
ON o.mgr = s.empl_num;

SELECT * FROM OFFICE_HEADS;
--//////////////////////////////////////////
--1.5.	??????? Employee, ???????? ? Employee_Name (??? ??????????), Employee_Title (????????? ??????????), Hire_Date (???? ?????).
--1.5.	??????? Employee, ???????? ? Employee_Name (??? ??????????), Employee_Title (????????? ??????????), Hire_Date (???? ?????).
--1.6.	???????? ?????? ???? ????????????? ?? ????????.

SELECT EMPLOYEE_COUNT AS '@EMPLOYEE_COUNT',
	(SELECT R1.REGION AS '@REGION_NAME',
			REGION_EMPLOYEE_COUNT AS '@REGION_EMPLOYEE_COUNT',
			(SELECT R2.CITY AS '@CITY',
					R2.CITY_EMPLOYEE_COUNT AS '@CITY_EMPLOYEE_COUNT',
					R2.CITY_CHEF AS '@CITY_CHEF',
					(SELECT S.NAME AS '@Employee_Name',
							S.TITLE AS '@Employee_Title',
							S.HIRE_DATE AS '@Hire_Date'
					 FROM SALESREPS S
					 WHERE S.REP_OFFICE = R2.OFFICE
					 ORDER BY S.NAME
					 FOR XML PATH ('Employee'), TYPE)
			 FROM CITY_OFFICE_COUNT R2
			 WHERE R1.REGION = R2.Region
			 ORDER BY R2.CITY
			 FOR XML PATH('CITY'), TYPE)
	 FROM REGION_EMPL_COUNT R1
	 ORDER BY R1.REGION
	 FOR XML PATH('REGION'), TYPE)	
FROM EMPL_COUNT
FOR XML PATH('OFFICE_LIST')
--//////////////////////////////////////////////////////////////////////////////
/*-- ex 2
SELECT  CITY as '@City',
		REGION as '@Region',
		(SELECT NAME AS '@Name'
				FROM SALESREPS
				WHERE SALESREPS.REP_OFFICE = OFFICES.OFFICE
				FOR XML PATH ('Emp'))
	FROM OFFICES
	FOR XML PATH ('Office');

-- ex 3
SELECT  CITY as '@City',
		REGION as '@Region',
		(SELECT NAME AS '@Name'
				FROM SALESREPS
				WHERE SALESREPS.REP_OFFICE = OFFICES.OFFICE
				FOR XML PATH ('Emp'), TYPE)
	FROM OFFICES
	FOR XML PATH ('Office');
	*/

--2.	?????????????? ?????????? XML ????.
DECLARE @HTDOC INT
DECLARE @DOC XML
SET @DOC = 
'<OFFICE_LIST EMPLOYEE_COUNT="12">
  <REGION REGION_NAME="Eastern" REGION_EMPLOYEE_COUNT="6">
    <CITY CITY="Atlanta" CITY_EMPLOYEE_COUNT="1" CITY_CHEF="Bill Adams">
      <Employee Employee_Name="Bill Adams" Employee_Title="Sales Rep" Hire_Date="2006-02-12" />
    </CITY>
    <CITY CITY="Chicago" CITY_EMPLOYEE_COUNT="3" CITY_CHEF="Bob Smith">
      <Employee Employee_Name="Bob Smith" Employee_Title="Sales Mgr" Hire_Date="2005-05-19" />
      <Employee Employee_Name="Dan Roberts" Employee_Title="Sales Rep" Hire_Date="2004-10-20" />
      <Employee Employee_Name="Paul Cruz" Employee_Title="Sales Rep" Hire_Date="2005-03-01" />
    </CITY>
    <CITY CITY="New York" CITY_EMPLOYEE_COUNT="2" CITY_CHEF="Sam Clark">
      <Employee Employee_Name="Mary Jones" Employee_Title="Sales Rep" Hire_Date="2007-10-12" />
      <Employee Employee_Name="Sam Clark" Employee_Title="VP Sales" Hire_Date="2006-06-14" />
    </CITY>
  </REGION>
  <REGION REGION_NAME="Western" REGION_EMPLOYEE_COUNT="3">
    <CITY CITY="Denver" CITY_EMPLOYEE_COUNT="1" CITY_CHEF="Larry Fitch">
      <Employee Employee_Name="Nancy Angelli" Employee_Title="Sales Rep" Hire_Date="2006-11-14" />
    </CITY>
    <CITY CITY="Los Angeles" CITY_EMPLOYEE_COUNT="2" CITY_CHEF="Larry Fitch">
      <Employee Employee_Name="Larry Fitch" Employee_Title="Sales Mgr" Hire_Date="2007-10-12" />
      <Employee Employee_Name="Sue Smith" Employee_Title="Sales Rep" Hire_Date="2004-12-10" />
    </CITY>
  </REGION>
</OFFICE_LIST>'
--SELECT @DOC

EXEC sp_xml_preparedocument @HTDOC OUTPUT, @DOC

SET @DOC.modify('
insert <Accounting>COUNTED</Accounting> 
into (/OFFICE_LIST)[1]')
SELECT @DOC

SELECT EMPLOYEE_COUNT AS '@EMPLOYEE_COUNT',
	(SELECT R1.REGION AS '@REGION_NAME',
			REGION_EMPLOYEE_COUNT AS '@REGION_EMPLOYEE_COUNT',
			(SELECT R2.CITY AS '@CITY',
					R2.CITY_EMPLOYEE_COUNT AS '@CITY_EMPLOYEE_COUNT',
					R2.CITY_CHEF AS '@CITY_CHEF',
					(SELECT S.NAME AS '@Employee_Name',
							S.TITLE AS '@Employee_Title',
							S.HIRE_DATE AS '@Hire_Date'
					 FROM SALESREPS S
					 WHERE S.REP_OFFICE = R2.OFFICE
					 ORDER BY S.NAME
					 FOR XML PATH ('Employee'), TYPE)
			 FROM CITY_OFFICE_COUNT R2
			 WHERE R1.REGION = R2.Region
			 ORDER BY R2.CITY
			 FOR XML PATH('CITY'), TYPE)
	 FROM REGION_EMPL_COUNT R1
	 ORDER BY R1.REGION
	 FOR XML PATH('REGION'), TYPE)	
FROM EMPL_COUNT
FOR XML PATH('OFFICE_LIST')

--3.	???????????? ????????????????? XML ???? ? ??????? ???? ??????.
DECLARE @HTDOC INT
DECLARE @DOC XML
SET @DOC = 
'<OFFICE_LIST EMPLOYEE_COUNT="12">
  <REGION REGION_NAME="Eastern" REGION_EMPLOYEE_COUNT="6">
    <CITY CITY="Atlanta" CITY_EMPLOYEE_COUNT="1" CITY_CHEF="Bill Adams">
      <Employee Employee_Name="Bill Adams" Employee_Title="Sales Rep" Hire_Date="2006-02-12" />
    </CITY>
    <CITY CITY="Chicago" CITY_EMPLOYEE_COUNT="3" CITY_CHEF="Bob Smith">
      <Employee Employee_Name="Bob Smith" Employee_Title="Sales Mgr" Hire_Date="2005-05-19" />
      <Employee Employee_Name="Dan Roberts" Employee_Title="Sales Rep" Hire_Date="2004-10-20" />
      <Employee Employee_Name="Paul Cruz" Employee_Title="Sales Rep" Hire_Date="2005-03-01" />
    </CITY>
    <CITY CITY="New York" CITY_EMPLOYEE_COUNT="2" CITY_CHEF="Sam Clark">
      <Employee Employee_Name="Mary Jones" Employee_Title="Sales Rep" Hire_Date="2007-10-12" />
      <Employee Employee_Name="Sam Clark" Employee_Title="VP Sales" Hire_Date="2006-06-14" />
    </CITY>
  </REGION>
  <REGION REGION_NAME="Western" REGION_EMPLOYEE_COUNT="3">
    <CITY CITY="Denver" CITY_EMPLOYEE_COUNT="1" CITY_CHEF="Larry Fitch">
      <Employee Employee_Name="Nancy Angelli" Employee_Title="Sales Rep" Hire_Date="2006-11-14" />
    </CITY>
    <CITY CITY="Los Angeles" CITY_EMPLOYEE_COUNT="2" CITY_CHEF="Larry Fitch">
      <Employee Employee_Name="Larry Fitch" Employee_Title="Sales Mgr" Hire_Date="2007-10-12" />
      <Employee Employee_Name="Sue Smith" Employee_Title="Sales Rep" Hire_Date="2004-12-10" />
    </CITY>
  </REGION>
</OFFICE_LIST>'
--SELECT @DOC

EXEC sp_xml_preparedocument @HTDOC OUTPUT, @DOC

SELECT *
FROM OPENXML(@HTDOC, '/OFFICE_LIST/REGION', 1)  
    WITH (
    REGION_NAME VARCHAR(30),
	REGION_EMPLOYEE_COUNT INT)

SELECT *
FROM OPENXML(@HTDOC, '/OFFICE_LIST/REGION/CITY', 1)  
    WITH (
    CITY VARCHAR(30),
	CITY_EMPLOYEE_COUNT INT,
    CITY_CHEF VARCHAR(50))

/*SELECT *
FROM OPENXML(@HTDOC, '/OFFICE_LIST/REGION/CITY', 1)  
    WITH (
	EMPLOYEE_COUNT INT,
    REGION_NAME VARCHAR(30),
	REGION_EMPLOYEE_COUNT INT,
    CITY VARCHAR(30),
	CITY_EMPLOYEE_COUNT INT,
    CITY_CHEF VARCHAR(50))*/

--4.	???????? XML-????? ?? ?????????? 1, ?????????????? ??????? ?????-?????? ?????????.
--XML Schema ? ???? ???????? ????????? XML-????????? ? ???????????? ??? ??????????? ??????, ??????? ?????? ??????????? ????????
--????????? ?????? ?????? ?????????:
----??????? (???????? ????????? ? ?????????)
----?????? ?????????? (????????? ????? ?????????? ? ?????????? ? ?? ?????????)
----???? ??????

CREATE XML SCHEMA COLLECTION SCHEMAFORTASK AS
N'<?xml version="1.0" encoding="UTF-16" ?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="order">
      <xs:complexType>
         <xs:sequence>
            <xs:element name="customer" type="xs:string"/>
            <xs:element name="address">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="factaddress" type="xs:string"/>
                     <xs:element name="city" type="xs:string"/>
                     <xs:element name="country" type="xs:string"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
            <xs:element name="item" maxOccurs="unbounded">
               <xs:complexType>
                  <xs:sequence>
                     <xs:element name="partnumber" type="xs:string"/>
                     <xs:element name="description" type="xs:string" minOccurs="0"/>
                     <xs:element name="quantity" type="xs:positiveInteger"/>
                     <xs:element name="price" type="xs:decimal"/>
                  </xs:sequence>
               </xs:complexType>
            </xs:element>
         </xs:sequence>
         <xs:attribute name="orderid" type="xs:string" use="required"/>
         <xs:attribute name="orderdate" type="xs:date" use="required"/>
      </xs:complexType>
   </xs:element>
</xs:schema>'

DROP XML SCHEMA COLLECTION SCHEMAFORTASK 

--5.	???????? ??????? Imported_XML (??????? ? Id, Import_Date, XML_Text). ????????? ????????? ????? ??? XML-???????.
CREATE TABLE Imported_XML(
	ID INT PRIMARY KEY,
	IMPORT_DATE DATE,
	XML_TEXT XML)

SELECT * FROM Imported_XML

/*SELECT ID AS '@ID',
	   IMPORT_DATE AS '@DATE',
	   XML_TEXT AS '@XML_TEXT'
FROM Imported_XML
FOR XML PATH('ROOT')*/

--6.	???????? ??? XML ????? ((1), (2), (3)), ??? ?? ??????? ?????? ??????????????? ?????, ? ???? ?? ?????????????.
--7.	????????? ????????? XML ????? (1), (2) ? ??????? XML_Text ??????? Imported_XML. ???????? ?????? ??? ???????? ????? (3), ?? ???????????????? ?????. 
--8.	????????? XML ???? (3) ? ????????? ??? ? ??????? XML_Text ??????? Imported_XML.
---------FILE_1------------
DECLARE @XML_ONE XML 
SET @XML_ONE = '
   <order>
      <customer>customer_ONE</customer>
        <address>
             <factaddress>factaddress_ONE</factaddress>
             <city>city_ONE</city>
             <country>country_ONE</country>
        </address>
            <item>
               <partnumber>partnumber_ONE</partnumber>
               <description>description_ONE</description>
               <quantity>1</quantity>
               <price>13.05</price>
            </item>
         <orderid>1</orderid>
         <orderdate>22/02/2022</orderdate>
   </order>'
--SELECT @XML_ONE
INSERT INTO Imported_XML VALUES(1, GETDATE(), @XML_ONE)

---------FILE_2------------
DECLARE @XML_TWO XML
SET @XML_TWO = '
   <order>
      <customer>customer_TWO</customer>
        <address>
             <factaddress>factaddress_TWO</factaddress>
             <city>city_TWO</city>
             <country>country_TWO</country>
        </address>
            <item>
               <partnumber>partnumber_TWO</partnumber>
               <description>description_TWO</description>
               <quantity>2</quantity>
               <price>46.11</price>
            </item>
         <orderid>2</orderid>
         <orderdate>12/05/2021</orderdate>
   </order>'
--SELECT @XML_TWO
INSERT INTO Imported_XML VALUES(2, GETDATE(), @XML_TWO)

---------FILE_3------------
DECLARE @XML_THREE XML
SET @XML_THREE = '
   <order>
      <customer>customer_THREE</customer>
        <address>
             <factaddress>factaddress_THREE</factaddress>
             <city>city_THREE</city>
             <country>country_THREE</country>
        </address>
            <item>
               <partnumber>partnumber_THRE</partnumber>
               <description>description_THREE</description>
               <quantity>3</quantity>
               <price>20.90</price>
            </item>
         <orderid>3</orderid>
         <orderdate>11/05/2022</orderdate>
		 <root>ROOT</root>
   </order>'

INSERT INTO Imported_XML VALUES(3, GETDATE(), @XML_THREE)

SELECT * FROM Imported_XML

DROP TABLE Imported_XML

--9.	???????? ?????? ?? XML-??????? ??? ??????? Imported_XML.
CREATE PRIMARY XML INDEX IMPORTED_XML_IDX ON Imported_XML(XML_TEXT)
--USING XML INDEX IMPORTTED_XML_IDX FOR PATH
EXEC SP_HELPINDEX 'Imported_XML'

SELECT * FROM Imported_XML

DROP INDEX IMPORTED_XML_IDX ON Imported_XML

--10.	???????: 
10.1.	???????? ????????????? ???? ??? (3).
SELECT ID, XML_TEXT.value('/ID[1]/FIRST_NAME/LAST_NAME/', 'VARCHAR(MAX)') AS NAME
FROM Imported_XML
WHERE ID = 3
FOR XML AUTO, TYPE

10.2.	???????? ????????????? ???? ??? ???? ??????.
SELECT ID, XML_TEXT.VALUE('/ID[1]/IMPORT_DATE', 'VARCHAR(MAX)') AS RESULT
FROM Imported_XML
FOR XML AUTO, TYPE

--10.3.	???????? ????????????? ???????? ??? (1), (2).
SELECT ID, XML_TEXT.query('/ID/IMPORT_DATE')
FROM Imported_XML
WHERE ID IN (1, 2) 
FOR XML AUTO, TYPE

--10.4.	???????? ????????????? ???????? ??? ???? ??????.
SELECT ID, IMPORT_DATE, XML_TEXT.query('/ID/IMPORT_DATE')
FROM Imported_XML 
FOR XML AUTO, TYPE

--11.	???????? ???????? XML ???? (1), ??????? ???? ? ???????. 
DECLARE @XML_ONE XML = '
<EMP_NAME>
  <ROOT>
	<ID>01</ID>
	<FIRST_NAME>ALEX</FIRST_NAME>
	<LAST_NAME>WALTER</LAST_NAME>
  </ROOT>
</EMP_NAME>'
--SELECT @XML_ONE

SET @XML_ONE.modify('
insert <HIRE_DATE>22/02/2022</HIRE_DATE>
into (/EMP_NAME/ROOT)[1]')
SELECT @XML_ONE
/*
--------EXAMPLE-1-INSERT-----------------
DECLARE @myXMLDoc XML;
SET @myXMLDoc = '
<ROOT>
	<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
		<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
</ROOT>' ;
--SELECT @myXMLDoc
SET @myXMLDoc.modify('
insert <MAINTENANCE>3 YEAR parts and labor extended maintance</MAINTENANCE>
into (/ROOT/PRODUCTDESCRIPTION/FEATURES)[1]');
SELECT @myXMLDoc
*/

--12.	???????? ???????? XML ???? (2), ?????? ???? ??? ???????.
---------FILE_2------------
DECLARE @XML_TWO XML 
SET @XML_TWO = '
<EMP_NAME>
  <ROOT>
	<ID>02</ID>
	<FIRST_NAME>JHON</FIRST_NAME>
	<LAST_NAME>SNOW</LAST_NAME>
  </ROOT>
</EMP_NAME>'

SET @XML_TWO.modify('
delete /EMP_NUM/ROOT/ID')  --?? ???????
SELECT @XML_TWO

--------EXAMPLE-2-DELETE------------------
DECLARE @myXMLDoc XML;
SET @myXMLDoc = '
<ROOT>
	<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
		<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
</ROOT>' ;
--SELECT @myXMLDoc
SET @myXMLDoc.modify('
delete /ROOT/PRODUCTDESCRIPTION')
SELECT @myXMLDoc

--13.	???????? ???????? XML ???? (3), ??????? ???????? ???? ??? ????????.
---------FILE_3------------
DECLARE @XML_THREE XML = '
<EMP_NAME>
  <ROOT>
	<ID CATEGORY = "EMPLOYEE">03</ID>
	<FIRST_NAME>NIK</FIRST_NAME>
	<LAST_NAME>ROBERTS</LAST_NAME>
	<AGE>20</AGE>
  </ROOT>
</EMP_NAME>'
--SELECT @XML_THREE

SET @XML_THREE.modify('
replace value of (/EMP_NUM/ROOT/ID/@CATEGORY)[1] 
with   "FIRED"')   --?? ?????????
SELECT @XML_THREE

--------EXAMPLE-3-UPDATE------------------
DECLARE @myXMLDoc XML;
SET @myXMLDoc = '
<ROOT>
	<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
		<PRODUCTDESCRIPTION RPODUCTID="1" PRODUCTNAME="ROAD BIKE">
		<FEATURES>
		</FEATURES>
    </PRODUCTDESCRIPTION>
</ROOT>' ;
--SELECT @myXMLDoc
SET @myXMLDoc.modify('
replace value of (/ROOT/PRODUCTDESCRIPTION/@PRODUCTNAME)[1]
with   "THE NEW BIKE"
')
SELECT @myXMLDoc