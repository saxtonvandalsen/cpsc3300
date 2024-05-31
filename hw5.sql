-- 1
select c.courseName, c.credits
from Courses c
join Registration r on c.courseCode = r.courseCode
where r.studentID = '861103-2438';

-- 2
select s.studentID, s.firstName, s.lastName, sum(c.credits) as totalCredits
from Students as s
join Registration as r on s.studentID = r.studentID
join Courses as c on r.courseCode = c.courseCode
group by s.studentID, s.firstName, s.lastName;

-- 3
create view StudentGradeAverage as
select s.studentID, s.lastName, s.firstName, avg(r.grade) as gradeAverage
from Students as s
join Registration as r on s.studentID = r.studentID
group by s.studentID, s.lastName, s.firstName;

-- finding the students with the highest grade average
select studentID, lastName, firstName, gradeAverage
from StudentGradeAverage
where gradeAverage = (
    select max(gradeAverage) from StudentGradeAverage
);

-- 4
select s.firstName, s.lastName
from Students as s
join Registration as r on s.studentID = r.studentID
join Courses as c on r.courseCode = c.courseCode
where c.courseName = 'Database Systems';

-- 5
SELECT s.firstName, s.lastName
FROM Students AS s
JOIN Registration AS r1 ON s.studentID = r1.studentID
JOIN Courses AS c1 ON r1.courseCode = c1.courseCode
JOIN Registration AS r2 ON s.studentID = r2.studentID
JOIN Courses AS c2 ON r2.courseCode = c2.courseCode
WHERE c1.courseName = 'Database Systems' AND c2.courseName = 'C++';

-- 6
select s.studentID, s.firstName, s.lastName, c.courseName, r.grade
from Students as s
left join Registration as r on s.studentID = r.studentID
left join Courses as c on r.courseCode = c.courseCode;

-- 7
SELECT s.firstName, s.lastName, c.courseName
FROM Students AS s
JOIN Registration AS r ON s.studentID = r.studentID
JOIN Courses AS c ON r.courseCode = c.courseCode
WHERE c.courseCode LIKE 'CS%';

-- 2.
create table Inventory (
    itemid varchar(20) primary key,
    name varchar(30),
    price decimal(6,2),
    quantity int
);

create table Transaction (
    transid int auto_increment primary key,
    itemid varchar(20),
    quantity int,
    time datetime,
    foreign key (itemid) references Inventory(itemid)
);

create table Inventory_history (
    id int auto_increment primary key,
    itemid varchar(20),
    action varchar(20),
    oldprice decimal(6,2),
    time datetime,
    foreign key (itemid) references Inventory(itemid)
);

-- 1
DELIMITER //

CREATE TRIGGER insert_inventory
AFTER INSERT
ON Inventory
FOR EACH ROW
BEGIN
    INSERT INTO Inventory_history (itemid, action, oldprice, time)
    VALUES (NEW.itemid, 'add an item', NULL, NOW());
END//

DELIMITER;

-- 2
DELIMITER //

create trigger change_quantity
after insert
on Transaction
for each row
begin
    update Inventory
    set quantity = quantity - new.quantity
    where itemid = new.itemid;
end//

DELIMITER ;

-- 3
DELIMITER //

create trigger change_price
before update
on Inventory
for each row
begin
    if old.price <> new.price then
        insert into Inventory_history (itemID, action, oldprice, time)
        values (new.itemID, "price change", old.price, now());
    end if;
end//

DELIMITER ;