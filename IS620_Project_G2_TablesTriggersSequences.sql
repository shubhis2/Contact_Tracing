DROP SEQUENCE test_sequence;
DROP SEQUENCE mid_seq2;
DROP SEQUENCE mid_seq3;

CREATE SEQUENCE test_sequence
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 10000;

--created 2 sequences used in feature 1 and 2
CREATE SEQUENCE mid_seq2
START WITH 6;

CREATE SEQUENCE mid_seq3                        
START WITH 22;

CREATE OR REPLACE TRIGGER updateStatus
AFTER INSERT OR UPDATE OR DELETE ON Tests
FOR EACH ROW
BEGIN
    UPDATE Person SET Status = :new.res WHERE Person.pid = :new.pid;
    Update Status_Flags sf set sf.flag = 1 where (:old.res = 0 and :new.res = 1);
END;



------------------------------------------------------
drop table Status_Flags cascade constraints;
drop table Person_flight cascade constraints;
drop table Flights cascade constraints;
drop table Person_event cascade constraints;
drop table Events cascade constraints;
drop table Tests cascade constraints;
drop table Person cascade constraints;
drop table Houses cascade constraints;

CREATE TABLE Houses
 (
 hid INT,
 address VARCHAR(30),
 zip VARCHAR2(5),
 PRIMARY KEY(hid)
 );

-- Added a constraint to status 
CREATE TABLE Person
 (
 pid INT,
 hid INT,
 p_name VARCHAR(15),
 phone VARCHAR(10),
 status INT Check ( status In (0,1)),
 PRIMARY KEY (pid),
 FOREIGN KEY (hid) REFERENCES Houses(hid)
 );

-- Created a primary key tIS with a sequence
-- Changed the result column name to res as it is a reserved keyword
-- Applied a constraint check on res. 
CREATE TABLE Tests
  ( 
     tid   NUMBER,
     pid   INT, 
     t_date DATE,
     res INT Check ( res In (0,1)),
     Primary Key (tid),
     FOREIGN KEY(pid) REFERENCES Person(pid) 
  ); 

CREATE TABLE Events
 (
 eid INT,
 e_name VARCHAR(20),
 e_date DATE,
 e_address VARCHAR(30),
 PRIMARY KEY(eid)
 );


-- Added a comma
-- Added  composite primary key
CREATE TABLE Person_event
 (
 pid INT,
 eid INT,
 Primary Key (pid, eid),
 FOREIGN KEY(pid) REFERENCES Person(pid),
 FOREIGN KEY(eid) REFERENCES Events(eid)
 );
 
CREATE TABLE Flights
 (
 fid INT,
 f_date DATE,
 f_number VARCHAR(10),
 PRIMARY KEY(fid)
 );


-- Created Composite primary key
CREATE TABLE Person_flight
 (
 pid INT,
 fid INT,
 Primary Key (pid, fid),
 FOREIGN KEY(pid) REFERENCES Person(pid),
 FOREIGN KEY(fid) REFERENCES Flights(fid)
 );

CREATE TABLE Status_Flags
 (
 pid   INT,
 flag INT Check ( flag In (0,1)),
 FOREIGN KEY (pid) REFERENCES Person(pid)
 );

-----------------------------------------------------------------------------------

--insert values into table Houses
insert into Houses values(1, '1025 Howland Sq', '21227');
insert into Houses values(2, '1026 Howland Sq', '21228');
insert into Houses values(3, '1027 Howland Sq', '21229');
insert into Houses values(4, '1028 Howland Sq', '21220');
insert into Houses values(5, '1029 Howland Sq', '21221');

--insert values into table Person 
insert into Person values(10, 1, 'Kirubel', '2405649308', 0);                                   
insert into Person values(11, 1, 'Rohan', '6672321002', 0);
insert into Person values(12, 2, 'Vikas',  '6672321003', 0);
insert into Person values(13, 3, 'Vickey', '6672321004', 1);
insert into Person values(14, 4, 'Vaishak', '6672321005', 1);
insert into Person values(15, 5, 'Vishal', '6672321006', 1);
insert into Person values(17, 2, 'Helen', '8872371001', 0);
insert into Person values(16, 2, 'Ritviz', '8772321004', 1);
insert into Person values(18, 2, 'Mithila', '8972321009', 1);
insert into Person values(19, 1, 'Diya', '6012321001', 1);
insert into Person values(20, 5, 'Bob', '8672321099', 1);
insert into Person values(21, 5, 'Marshal', '6772321777', 0);
insert into Person values(22, 5, 'Marta', '6772321723', 1);

-- Updated the Insert Into test statements
--insert values into table Tests
insert into Tests values(test_sequence.nextval, 11, date '2020-08-08', 0);
insert into Tests values(test_sequence.nextval, 12, date '2020-10-07', 0);
insert into Tests values(test_sequence.nextval, 13, date '2010-08-08', 1);
insert into Tests values(test_sequence.nextval, 15, date '2019-08-05', 0);
insert into Tests values(test_sequence.nextval, 14, date '2020-09-01', 0);
insert into Tests values(test_sequence.nextval, 16, date '2020-12-13', 1);
insert into Tests values(test_sequence.nextval, 17, date '2020-12-14', 1);
insert into Tests values(test_sequence.nextval, 18, date '2020-12-14', 1);
insert into Tests values(test_sequence.nextval, 19, date '2020-12-05', 1);
insert into Tests values(test_sequence.nextval, 20, date '2020-12-06', 1);
insert into Tests values(test_sequence.nextval, 20, date '2020-12-08', 1);
insert into Tests values(test_sequence.nextval, 11, date '2020-12-17', 1);
insert into Tests values(test_sequence.nextval, 21, date '2020-10-25', 1);
insert into Tests values(test_sequence.nextval, 22, date '2020-10-25', 1);

--Updated Values of the records in the Tests table
Update Tests  Set t_date = date '2020-10-02', res = 1 Where pid = 15;
Update Tests  Set t_date = date '2020-10-02', res = 1 Where pid = 20;
Update Tests  Set t_date = date '2020-10-05', res = 1 Where pid = 16;
Update Tests  Set t_date = date '2020-10-05', res = 1 Where pid = 17;
Update Tests  Set t_date = date '2020-10-21', res = 1 Where pid = 11;
Update Tests  Set t_date = date '2020-10-21', res = 1 Where pid = 19;
Update Tests  Set t_date = date '2020-10-25', res = 1 Where pid = 21;
Update Tests  Set t_date = date '2020-10-25', res = 1 Where pid = 22;

--insert values into table Events
insert into Events values(311, 'Victor', date '2011-09-05', '4142 greenville');
insert into Events values(312, 'Hitler', date '2013-10-03', '4143 greenville');
insert into Events values(313, 'Vile', date '2015-08-05', '4144 greenville');
insert into Events values(314, 'John', date '2016-10-02', '4145 greenville');
insert into Events values(315, 'Peter', date '2017-01-05', '4146 greenville');

--insert values into table Person_event
insert into Person_event values(11, 311);
insert into Person_event values(12, 312);
insert into Person_event values(13, 313);
insert into Person_event values(14, 311);
insert into Person_event values(15, 314);

--insert values into table Flights
insert into Flights values(1111, date '2020-06-13', 'DL 819');
insert into Flights values(1112, date '2020-10-08', 'AA 820');
insert into Flights values(1113, date '2017-08-18', 'BA 821');
insert into Flights values(1114, date '2020-10-28', 'GF 823');
insert into Flights values(1115, date '2010-11-08', 'DL 824');
insert into Flights values(1116, date '2020-12-10', 'DL 613');

--insert values into table Person_flight
insert into Person_flight values(11, 1111);
insert into Person_flight values(12, 1112);
insert into Person_flight values(11, 1114);
insert into Person_flight values(13, 1114);
insert into Person_flight values(14, 1111);
insert into Person_flight values(20, 1116);
insert into Person_flight values(17, 1116);

---insert values into table Status_Flags
insert into Status_Flags values(11, 0);
insert into Status_Flags values(12, 0);
insert into Status_Flags values(13, 0);
insert into Status_Flags values(14, 0);
insert into Status_Flags values(15, 0);
insert into Status_Flags values(16, 0);
insert into Status_Flags values(17, 0);
insert into Status_Flags values(18, 0);
insert into Status_Flags values(19, 0);
insert into Status_Flags values(20, 0);
insert into Status_Flags values(21, 0);
insert into Status_Flags values(22, 0);
