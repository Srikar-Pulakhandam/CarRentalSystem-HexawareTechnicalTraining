create database CarRentalSystem;
use CarRentalSystem;

create table if not exists Vehicle(
vehicleID int primary key,
make varchar(20),
model varchar(20),
year int,
dailyRate decimal,
available bit,
passengerCapacity int,
engineCapacity int);

insert into Vehicle values
(1,"Toyota","Camry",2022,50.00,1,4,1450),
(2,"Honda","Civic",2023,45.00,1,7,1500),
(3,"Ford","Focus",2022,48.00,0,4,1400),
(4,"Nissan","Altima",2023,52.00,1,7,1200),
(5,"Chevrolet","Malibu",2022,47.00,1,4,1800),
(6,"Hyundai","Sonata",2023,49.00,0,7,1400),
(7,"BMW","3 Series",2023,60.00,1,7,2499),
(8,"Mercedes","C-Class",2022,58.00,1,8,2599),
(9,"Audi","A4",2022,55.00,0,4,2500),
(10,"Lexus","ES",2023,54.00,1,4,2500);

create table if not exists Customer(
customerID int primary key,
firstName varchar(20),
lastName varchar(20),
email varchar(60),
phoneNumber varchar(15));

insert into Customer values
(1,"John","Doe","johndoe@example.com","555-555-5555"),
(2,"Jane","Smith","robert@example.com","555-123-4567"),
(3,"Robert","Johnson","robert@example.com","555-789-1234"),
(4,"Sarah","Brown","sarah@example.com","555-456-7890"),
(5,"David","Lee","david@example.com","555-987-6543"),
(6,"Laura","Hall","laura@example.com","555-234-5678"),
(7,"Michael","Davis","michael@example.com","555-876-5432"),
(8,"Emma","Wilson","emma@example.com","555-532-1098"),
(9,"William","Taylor","william@example.com","555-321-6547"),
(10,"Olivia","Adams","olivia@example.com","555-765-4321"),
(11,'John','Doe','johndoe@example.com',555-555-5555);

create table if not exists Lease(
leaseID int primary key,
vehicleID int,
customerID int,
startDate date,
endDate date,
type varchar(10),
foreign key(vehicleID) references Vehicle(vehicleID) on delete cascade,
foreign key(customerID) references Customer(customerID)on delete cascade);

insert into Lease values
(1,1,1,'2023-01-01','2023-01-05','Daily'),
(2,2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,5,'2023-05-05','2023-05-10','Daily'),
(6,4,3,'2023-06-15','2023-06-30','Monthly'),
(7,7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,8,'2023-08-12','2023-08-15','Monthly'),
(9,3,3,'2023-09-07','2023-09-10','Daily'),
(10,10,10,'2023-10-10','2023-10-31','Monthly'),
(11,4,1,'2023-01-01','2023-01-05','Daily'),
(12,1,1,'2024-03-01','2024-04-01','Monthly');

create table if not exists Payment(
paymentID int primary key,
leaseID int,
paymentDate date,
amount  decimal,
foreign key(leaseID) references Lease(leaseID) on delete cascade);

insert into Payment values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7,'2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-25',1500.00);

-- 1. Update the daily rate for a Mercedes car to 68
update vehicle set dailyRate=68.00 where make='Mercedes';

-- 2. Delete a specific customer and all associated leases and payments
delete from customer where customerID=4;

-- 3. Rename the "paymentDate" column in the Payment table to "transactionDate"
alter table Payment rename column paymentDate to transactionDate;

-- 4. Find a specific customer by email
select * from Customer where email='emma@example.com';

-- 5. Get active leases for a specific customer
select l.* from lease l left join customer c on c.customerID=l.customerID where endDate>curdate() order by c.customerID;

-- 6. Find all payments made by a customer with a specific phone number
select c.customerID,p.amount from customer c inner join lease l on c.customerID=l.customerID join payment p on l.leaseID=p.leaseID where phoneNumber='555-555-5555';

-- 7. Calculate the average daily rate of all available cars
select avg(dailyRate) from Vehicle where available=1;

-- 8. Find the car with the highest daily rate
select * from Vehicle where dailyRate = (select max(dailyRate) from Vehicle);

-- 9. Retrieve all cars leased by a specific customer
select customerID,l.vehicleID,make,model,year,dailyRate,passengerCapacity,engineCapacity from Lease l left join Vehicle v on l.vehicleID = v.vehicleID where customerID=1;

-- 10. Find the details of the most recent lease
select * from Lease order by startDate desc limit 1;

-- 11. List all payments made in the year 2023
select * from Payment where extract(year from transactionDate) = 2023;
 
 -- 12. Retrieve customers who have not made any payments
select * from customer cu where cu.customerID not in (select l.customerID from lease l left join payment p on l.leaseID=p.leaseID);

-- 13. Retrieve Car Details and Their Total Payments
select * from vehicle v join(select vehicleID,sum(p.amount) as TotalSales from lease l right join payment p on l.leaseID=p.leaseID group by vehicleID) vl on v.vehicleID=vl.vehicleID;

-- 14. Calculate Total Payments for Each Customer
select c.customerId,sum(p.amount) TotalPayments from customer c join lease l on c.customerId=l.customerID join payment p on l.leaseID=p.leaseID group by customerID;

-- 15. List Car Details for Each Lease
select leaseID,v.* from vehicle v inner join lease l on v.vehicleID = l.vehicleID order by leaseID;

-- 16. Retrieve Details of Active Leases with Customer and Car Information
select l.*,v.*,c.* from lease l join customer c on l.customerID=c.customerID join vehicle v on l.vehicleID=v.vehicleID where endDate>curdate();

-- 17. Find the Customer Who Has Spent the Most on Leases
select l.customerID,sum(amount) TotalAmount from lease l right join payment p on l.leaseID=p.leaseID group by l.customerID order by TotalAmount desc limit 1;

-- 18. List All Cars with Their Current Lease Information
select leaseID,customerID,v.*,startDate,endDate from vehicle v inner join lease l on v.vehicleID=l.vehicleID;