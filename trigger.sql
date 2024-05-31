create table employees (
    employeeNumber int primary key,
    lastName varchar(50),
    firstName varchar(50),
    extension varchar(10),
    email varchar(100),
    officeCode varchar(10),
    reportsTo int,
    jobTitle varchar(50)
);

insert into employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
values 
    (1, 'lastName', 'firstName', '3098386289', 'email', '10', 2, 'boss'),
    (2, 'lastName1', 'firstName1', '3098386211', 'email1', '10', 3, 'guy')

create table employee_audit (
    id int primary key,
    employeeNumber int,
    lastName varchar(50),
    changedOn datetime,
    action varchar(50)
)

-- 3
create trigger employees_update
before update on employeeNumber
for each row
begin
    insert into employee_audit (employeeNumber, lastName, changedOn, action)
    values (old.employeeNumber, old.lastName, now(), 'update')
end;

-- 4
update employees
set lastName = 'updatedlastname'
where employeeNumber = 1;

-- 5
create trigger employee_insert
after insert on employees
for each row
begin 
    insert into employee_audit (employeeNumber, lastName, changedOn, action)
    values (new.employeeNumber, new.lastName, now(), 'insert')
end;

-- 6
insert into employees values (3, 'lastName3', 'firstName3', '30213386289', 'email5', '15', 2, 'boss2');