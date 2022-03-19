-- ex 1
SELECT
    'XPath example' AS 'head/title',
    'This example demonstrates ' AS 'body/p',
    'https://www.w3.org/TR/xpath/' AS 'body/p/a/@href',
    'XPath expressions' AS 'body/p/a'
FOR XML PATH('html');
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

SELECT * FROM CITY_EMPL_COUNT
DROP VIEW v_city_office_count
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
-- ex 2
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

----- create views ----
CREATE VIEW v_office_count AS
SELECT COUNT(EMPL_NUM) AS Employee_Count FROM SALESREPS;

SELECT * FROM v_office_count;

CREATE VIEW v_region_office_count AS
SELECT	REGION,
		COUNT(EMPL_NUM) as Region_Employee_Count 
FROM OFFICES o join SALESREPS s 
ON o.OFFICE = s.REP_OFFICE
GROUP BY REGION;

SELECT * FROM v_region_office_count;

CREATE VIEW v_office_heads AS
SELECT	o.city AS City,
		o.region AS Region,
		s.name AS City_Chef,
		o.office AS Office
FROM OFFICES o JOIN SALESREPS s 
ON o.mgr = s.empl_num;

SELECT * FROM v_office_heads;

CREATE VIEW v_city_office_count AS
SELECT	o.City,
		COUNT(s.EMPL_NUM) AS City_Employee_Count,
		MIN(o.Region) AS Region,
		MIN(o.City_Chef) AS City_Chef,
		MIN(o.Office) AS Office
FROM v_office_heads o JOIN SALESREPS s 
ON o.OFFICE = s.REP_OFFICE
GROUP BY city;

SELECT * FROM v_city_office_count;

------------------------ select for xml ------------------
SELECT 	
		Employee_Count AS '@Employee_Count',
		(SELECT 
			o1.Region AS '@Region',
			Region_Employee_Count as '@Region_Employee_Count',
			(SELECT o2.city AS '@City_Name',
					o2.City_Employee_Count AS '@City_Employee_Count',
					o2.City_Chef AS '@City_Chef',
					(SELECT s.NAME AS '@Employee_Name',
							s.TITLE AS '@Employee_Title',
							s.HIRE_DATE AS '@Hire_Date'
						FROM SALESREPS s
						WHERE s.REP_OFFICE = o2.OFFICE
						ORDER BY s.NAME
						FOR XML PATH ('Employee'), TYPE)
				FROM v_city_office_count o2
				WHERE o2.REGION = o1.REGION
				ORDER BY o2.city
				FOR XML PATH('City'), TYPE)
		FROM v_region_office_count o1 
		ORDER BY o1.region
		FOR XML PATH('Region'), TYPE)
	FROM v_office_count v
	FOR XML PATH ('Office_List');

--2.	�������������� ���������� XML ����.
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


DECLARE @DOC XML
SET @DOC = '
<OFFICE_LIST EMPLOYEE_COUNT="12">
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
</OFFICE_LIST>
'
SELECT @DOC
EXEC sp_xml_preparedocument @DOC

3.	������������ ����������������� XML ���� � ������� ���� ������.
4.	�������� XML-����� �� ���������� 1, �������������� ������� �����-������ ���������.
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
