#!/bin/bash
sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output blocks.csv
select * from document_system_block;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output categories.csv
select * from document_system_issuetype;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output issue_type.csv
select * from document_system_issue_issue_types;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output issues.csv
select * from document_system_issue;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output meetings.csv
select * from document_system_meeting;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output notes.csv
select * from document_system_note;
!

sqlite3 ./db.sqlite3 <<!
.headers on
.mode csv
.output tables.csv
select * from document_system_table;
!
