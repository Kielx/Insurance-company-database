DROP TABLE branch CASCADE CONSTRAINTS;

DROP TABLE city CASCADE CONSTRAINTS;

DROP TABLE claim CASCADE CONSTRAINTS;

DROP TABLE claimstatus CASCADE CONSTRAINTS;

DROP TABLE client CASCADE CONSTRAINTS;

DROP TABLE clienttype CASCADE CONSTRAINTS;

DROP TABLE employee CASCADE CONSTRAINTS;

DROP TABLE housenr CASCADE CONSTRAINTS;

DROP TABLE insurance CASCADE CONSTRAINTS;

DROP TABLE insurancetype CASCADE CONSTRAINTS;

DROP TABLE payment CASCADE CONSTRAINTS;

DROP TABLE phone CASCADE CONSTRAINTS;

DROP TABLE phonetype CASCADE CONSTRAINTS;

DROP TABLE region CASCADE CONSTRAINTS;

DROP TABLE street CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE branch (
    branch_id   INTEGER NOT NULL,
    branch_name VARCHAR2(50) NOT NULL,
    region_id   INTEGER NOT NULL,
    city_id     INTEGER NOT NULL,
    street_id   INTEGER NOT NULL,
    housenr_id  INTEGER NOT NULL
);

ALTER TABLE branch ADD CONSTRAINT branch_pk PRIMARY KEY ( branch_id );

CREATE TABLE city (
    city_id   INTEGER NOT NULL,
    city_name VARCHAR2(50) NOT NULL
);

ALTER TABLE city ADD CONSTRAINT city_pk PRIMARY KEY ( city_id );

CREATE TABLE claim (
    claim_id     INTEGER NOT NULL,
    claim_name   VARCHAR2(50) NOT NULL,
    insurance_id INTEGER NOT NULL,
    claim_amount INTEGER,
    cs_id        INTEGER NOT NULL
);

ALTER TABLE claim ADD CONSTRAINT claim_pk PRIMARY KEY ( claim_id );

CREATE TABLE claimstatus (
    cs_id     INTEGER NOT NULL,
    cs_status VARCHAR2(50) NOT NULL
);

ALTER TABLE claimstatus ADD CONSTRAINT claimstatus_pk PRIMARY KEY ( cs_id );

CREATE TABLE client (
    client_id     INTEGER NOT NULL,
    first_name    VARCHAR2(50) NOT NULL,
    last_name     VARCHAR2(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    region_id     INTEGER NOT NULL,
    city_id       INTEGER NOT NULL,
    street_id     INTEGER NOT NULL,
    housenr_id    INTEGER NOT NULL,
    clienttype_id INTEGER NOT NULL,
    discount      INTEGER
);

ALTER TABLE client ADD CONSTRAINT client_pk PRIMARY KEY ( client_id );

CREATE TABLE clienttype (
    clienttype_id   INTEGER NOT NULL,
    clienttype_name VARCHAR2(50) NOT NULL
);

ALTER TABLE clienttype ADD CONSTRAINT clienttype_pk PRIMARY KEY ( clienttype_id );

CREATE TABLE employee (
    employee_id        INTEGER NOT NULL,
    first_name         VARCHAR2(50) NOT NULL,
    last_name          VARCHAR2(50) NOT NULL,
    date_of_birth      DATE NOT NULL,
    region_id          INTEGER NOT NULL,
    city_id            INTEGER NOT NULL,
    street_id          INTEGER NOT NULL,
    housenr_id         INTEGER NOT NULL,
    date_of_employment DATE,
    salary             INTEGER
);

ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY ( employee_id );

CREATE TABLE housenr (
    housenr_id INTEGER NOT NULL,
    housenr_nr VARCHAR2(10) NOT NULL
);

ALTER TABLE housenr ADD CONSTRAINT housenr_pk PRIMARY KEY ( housenr_id );

CREATE TABLE insurance (
    insurance_id     INTEGER NOT NULL,
    insurance_number VARCHAR2(50) NOT NULL,
    client_id        INTEGER NOT NULL,
    employee_id      INTEGER NOT NULL,
    begin_date       DATE NOT NULL,
    expiration_date  DATE NOT NULL,
    insurancetype_id INTEGER NOT NULL,
    payment_id       INTEGER NOT NULL,
    branch_id        INTEGER NOT NULL,
    price            INTEGER
);

ALTER TABLE insurance ADD CONSTRAINT insurance_pk PRIMARY KEY ( insurance_id );

CREATE TABLE insurancetype (
    insurancetype_id INTEGER NOT NULL,
    insurance_type   VARCHAR2(50) NOT NULL
);

ALTER TABLE insurancetype ADD CONSTRAINT insurancetype_pk PRIMARY KEY ( insurancetype_id );

CREATE TABLE payment (
    payment_id     INTEGER NOT NULL,
    payment_type   VARCHAR2(50) NOT NULL,
    payment_amount INTEGER,
    payment_date   DATE
);

ALTER TABLE payment ADD CONSTRAINT payment_pk PRIMARY KEY ( payment_id );

CREATE TABLE phone (
    phone_id     INTEGER NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    client_id    INTEGER,
    phonetype_id INTEGER NOT NULL,
    employee_id  INTEGER,
    branch_id    INTEGER
);

ALTER TABLE phone ADD CONSTRAINT phone_pk PRIMARY KEY ( phone_id );

CREATE TABLE phonetype (
    phonetype_id INTEGER NOT NULL,
    type_name    VARCHAR2(50) NOT NULL
);

ALTER TABLE phonetype ADD CONSTRAINT phonetype_pk PRIMARY KEY ( phonetype_id );

CREATE TABLE region (
    region_id   INTEGER NOT NULL,
    region_name VARCHAR2(50) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT region_pk PRIMARY KEY ( region_id );

CREATE TABLE street (
    street_id   INTEGER NOT NULL,
    street_name VARCHAR2(50) NOT NULL
);

ALTER TABLE street ADD CONSTRAINT street_pk PRIMARY KEY ( street_id );

ALTER TABLE branch
    ADD CONSTRAINT branch_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( city_id );

ALTER TABLE branch
    ADD CONSTRAINT branch_housenr_fk FOREIGN KEY ( housenr_id )
        REFERENCES housenr ( housenr_id );

ALTER TABLE branch
    ADD CONSTRAINT branch_region_fk FOREIGN KEY ( region_id )
        REFERENCES region ( region_id );

ALTER TABLE branch
    ADD CONSTRAINT branch_street_fk FOREIGN KEY ( street_id )
        REFERENCES street ( street_id );

ALTER TABLE claim
    ADD CONSTRAINT claim_claimstatus_fk FOREIGN KEY ( cs_id )
        REFERENCES claimstatus ( cs_id );

ALTER TABLE claim
    ADD CONSTRAINT claim_insurance_fk FOREIGN KEY ( insurance_id )
        REFERENCES insurance ( insurance_id );

ALTER TABLE client
    ADD CONSTRAINT client_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( city_id );

ALTER TABLE client
    ADD CONSTRAINT client_clienttype_fk FOREIGN KEY ( clienttype_id )
        REFERENCES clienttype ( clienttype_id );

ALTER TABLE client
    ADD CONSTRAINT client_housenr_fk FOREIGN KEY ( housenr_id )
        REFERENCES housenr ( housenr_id );

ALTER TABLE client
    ADD CONSTRAINT client_region_fk FOREIGN KEY ( region_id )
        REFERENCES region ( region_id );

ALTER TABLE client
    ADD CONSTRAINT client_street_fk FOREIGN KEY ( street_id )
        REFERENCES street ( street_id );

ALTER TABLE employee
    ADD CONSTRAINT employee_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( city_id );

ALTER TABLE employee
    ADD CONSTRAINT employee_housenr_fk FOREIGN KEY ( housenr_id )
        REFERENCES housenr ( housenr_id );

ALTER TABLE employee
    ADD CONSTRAINT employee_region_fk FOREIGN KEY ( region_id )
        REFERENCES region ( region_id );

ALTER TABLE employee
    ADD CONSTRAINT employee_street_fk FOREIGN KEY ( street_id )
        REFERENCES street ( street_id );

ALTER TABLE insurance
    ADD CONSTRAINT insurance_branch_fk FOREIGN KEY ( branch_id )
        REFERENCES branch ( branch_id );

ALTER TABLE insurance
    ADD CONSTRAINT insurance_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( client_id )
            ON DELETE CASCADE;

ALTER TABLE insurance
    ADD CONSTRAINT insurance_employee_fk FOREIGN KEY ( employee_id )
        REFERENCES employee ( employee_id )
            ON DELETE CASCADE;

ALTER TABLE insurance
    ADD CONSTRAINT insurance_insurancetype_fk FOREIGN KEY ( insurancetype_id )
        REFERENCES insurancetype ( insurancetype_id );

ALTER TABLE insurance
    ADD CONSTRAINT insurance_payment_fk FOREIGN KEY ( payment_id )
        REFERENCES payment ( payment_id );

ALTER TABLE phone
    ADD CONSTRAINT phone_branch_fk FOREIGN KEY ( branch_id )
        REFERENCES branch ( branch_id );

ALTER TABLE phone
    ADD CONSTRAINT phone_client_fk FOREIGN KEY ( client_id )
        REFERENCES client ( client_id )
            ON DELETE CASCADE;

ALTER TABLE phone
    ADD CONSTRAINT phone_employee_fk FOREIGN KEY ( employee_id )
        REFERENCES employee ( employee_id )
            ON DELETE CASCADE;

ALTER TABLE phone
    ADD CONSTRAINT phone_phonetype_fk FOREIGN KEY ( phonetype_id )
        REFERENCES phonetype ( phonetype_id );



