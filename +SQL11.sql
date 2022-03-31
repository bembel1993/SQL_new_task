-- ex 1
SELECT
    'XPath example' AS 'head/title',
    'This example demonstrates ' AS 'body/p',
    'https://www.w3.org/TR/xpath/' AS 'body/p/a/@href',
    'XPath expressions' AS 'body/p/a'
FOR XML PATH('html');
--Bembel_lab4
--1.	�������� XML ���� �� ������ ���� ������ ���������� ����:
--1.1.	�������� XML: Office List � Region � City � Employee.
--1.2.	�������� ��������� �������� �Office List�, ������� � Employee_Count (����� ���������� �����������).
CREATE VIEW EMPL_COUNT AS
SELECT COUNT(EMPL_NUM) AS EMPLOYEE_COUNT 
FROM SALESREPS S LEFT JOIN OFFICES O
ON S.MANAGER = O.MGR

SELECT * FROM EMPL_COUNT

--1.3.	������� Region, �������� � Region_Name (������������ �������), Region_Employee_Count (����� ���������� ����������� � �������).
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

--1.4.	������� City, �������� � City_Name (������������ ������), City_Employee_Count (����� ���������� ����������� � ������), 
--City_Chef (������� ������������ �������������).
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
--1.5.	������� Employee, �������� � Employee_Name (��� ����������), Employee_Title (��������� ����������), Hire_Date (���� �����).
--1.5.	������� Employee, �������� � Employee_Name (��� ����������), Employee_Title (��������� ����������), Hire_Date (���� �����).
--1.6.	�������� ������ ���� ������������� �� ��������.

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

--2.	�������������� ���������� XML ����.
DECLARE @HTDOC INT
DECLARE @DOC VARCHAR(5000)
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

UPDATE OFFICE_LIST
SET OFFICE_LIST.modify('insert <Accounting /> into (/OFFICE_LIST)[1]')


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

--3.	������������ ����������������� XML ���� � ������� ���� ������.
DECLARE @HTDOC INT
DECLARE @DOC VARCHAR(5000)
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

SELECT *
FROM OPENXML(@HTDOC, '/OFFICE_LIST/REGION/CITY', 1)  
    WITH (
	EMPLOYEE_COUNT INT,
    REGION_NAME VARCHAR(30),
	REGION_EMPLOYEE_COUNT INT,
    CITY VARCHAR(30),
	CITY_EMPLOYEE_COUNT INT,
    CITY_CHEF VARCHAR(50))

--4.	�������� XML-����� �� ���������� 1, �������������� ������� �����-������ ���������.
--XML Schema � ���� �������� ��������� XML-��������� � ������������ ��� ����������� ������, ������� ������ ����������� ��������
--��������� ������ ������ ���������:
----������� (�������� ��������� � ���������)
----������ ���������� (��������� ����� ���������� � ���������� � �� ���������)
----���� ������

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

5.	�������� ������� Imported_XML (������� � Id, Import_Date, XML_Text). ��������� ��������� ����� ��� XML-�������.
6.	�������� ��� XML ����� ((1), (2), (3)), ��� �� ������� ������ ��������������� �����, � ���� �� �������������.
7.	��������� ��������� XML ����� (1), (2) � ������� XML_Text ������� Imported_XML. �������� ������ ��� �������� ����� (3), �� ���������������� �����. 
8.	��������� XML ���� (3) � ��������� ��� � ������� XML_Text ������� Imported_XML.
9.	�������� ������ �� XML-������� ��� ������� Imported_XML.
10.	�������: 
10.1.	�������� ������������� ���� ��� (3).
10.2.	�������� ������������� ���� ��� ���� ������.
10.3.	�������� ������������� �������� ��� (1), (2).
10.4.	�������� ������������� �������� ��� ���� ������.
11.	�������� �������� XML ���� (1), ������� ���� � �������. 
12.	�������� �������� XML ���� (2), ������ ���� ��� �������.
13.	�������� �������� XML ���� (3), ������� �������� ���� ��� ��������.
