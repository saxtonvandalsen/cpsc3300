-- Saxton Van Dalsen

-- Start transaction
start transaction;

-- 1) Getting latest sales order number
set @latestOrderNumber = (select max(orderNumber) as lastestOrderNumber from orders);

-- Using next sales order number as new sales order number
set @newOrderNumber = @latestOrderNumber + 1;

-- 2) Inserting new sales for customerNumber 145
insert into orders (orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber)
values (@newOrderNumber, now(), date_add(now(), interval 5 day), date_add(now(), interval 2 day), "in process", 145);

-- 3) Inserting new sale order items into orderdetails table
insert into orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
values (@newOrderNumber, 'S18_1749', 30, 136, 1),
       (@newOrderNumber, 'S18_2248', 50, 55.09, 2);

commit;

-- 2 
delimiter //

create procedure setRelocationFee(in p_employeeID int(11), out p_relocationFee decimal(10, 2))
begin
    declare officeLocation varchar(50);

    select o.city into officeLocation
    from employees e
    join offices o on e.officeCode = o.officeCode
    where e.employeeNumber = p_employeeID;

    if officeLocation = 'San Francisco' then
        set p_relocationFee = 10000;
    elseif officeLocation = 'Boston' then
        set p_relocationFee = 8000;
    elseif officeLocation = 'London' then
        set p_relocationFee = 20000;
    else
        set p_relocationFee = 15000;
    end if;
end //

delimiter ;

-- 3
delimiter //

create procedure changeCreditLimit (in p_customerNumber int, in p_totalPayment double)
begin
    declare totalPayments double;

    select sum(amount) into totalPayments
    from payments
    where customerNumber = p_customerNumber;

    if totalPayments >= p_totalPayment then
        update customers
        set creditLimit = creditLimit + 2000
        where customerNumber = p_customerNumber;
    end if;
end //

delimiter ;

-- 4 
create table odd (number int primary key);

delimiter //

create procedure insertOdd ()
begin
    declare oddNumber;
    set oddNumber = 1;
    
		odd_loop: while oddNumber <= 20 do
        if oddNumber = 5 or oddNumber = 15 then
            set oddNumber = oddNumber + 2;
            iterate odd_loop;
        end if;

        insert into odd (number) values (oddNumber);
        set oddNumber = oddNumber + 2;
    end while odd_loop;
end //

delimiter ;