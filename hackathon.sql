create database hackathon;
use hackathon;

-- Tạo 4 bảng Passengers, Airlines, Flights, Bookings 
create table passengers (
	passenger_id varchar(5) not null primary key,
    full_name varchar(100) not null,
	email varchar(100) not null unique,
    phone varchar(15) not null unique
);

create table airlines (
	airline_id varchar(5) not null primary key,
    airline_name varchar(100) not null unique
);

create table flights (
	flight_id varchar(5) primary key not null,
    route_name varchar(100) not null unique,
    airline_id varchar(5) not null,
    foreign key (airline_id) references airlines(airline_id),
    ticket_price decimal(10,2) check(ticket_price > 0),
    available_seats int check (available_seats >= 0)
);

create table bookings (
	booking_id int not null auto_increment primary key,
    passenger_id varchar(5) not null,
    foreign key (passenger_id) references passengers(passenger_id),
    flight_id varchar(5) not null,
    foreign key (flight_id) references flights(flight_id),
    booking_status varchar(20) not null,
    booking_date date not null
);

-- Thêm dữ liệu vào 4 bảng đã tạo
insert into passengers(passenger_id, full_name, email, phone)
values
('P01','Trần Văn Bình','binh.tv@gmail.com','0981111111'),
('P02','Lê Thị Hoa','hoa.lt@gmail.com','0982222222'),
('P03','Nguyễn Trọng Tuấn','tuan.nt@gmail.com','0983333333'),
('P04','Hoàng Minh Châu','cha.hm@gmail.com','0984444444'),
('P05','Đinh Kiều Oanh','oanh.dk@gmail.com','0985555555');

insert into airlines(airline_id, airline_name) 
values
('A01','Vietnam Airlines'),
('A02','Vietjet Air'),
('A03','Bamboo Airways'),
('A04','Pacific Airlines');

insert into flights(flight_id, route_name, airline_id, ticket_price, available_seats)
values 
('F01', 'HN-HCM', 'A01', '2500000', 50),
('F02', 'HN-DN', 'A01', '1500000', 30),
('F03', 'HCM-DN', 'A02', '1200000', 40),
('F04', 'HN-PQ', 'A03', '3000000', 20),
('F05', 'HCM-DL', 'A04', '1000000', 15);

insert into bookings(passenger_id, flight_id, booking_status, booking_date)
values
('P01', 'F01', 'Booked', '2025-10-01'),
('P02', 'F03', 'Boarded', '2025-10-02'),
('P01', 'F02', 'Boarded', '2025-10-03'),
('P04', 'F05', 'Cancelled', '2025-10-04'),
('P05', 'F01', 'Booked', '2025-10-05');

-- Chuyến bay 'HN-PQ' vừa được tăng cường tàu bay lớn hơn, hãy tăng available_seats thêm 10 ghế và tăng ticket_price lên 5%.
update flights 
set available_seats = available_seats + 10, ticket_price = ticket_price * 1.05
where route_name = 'HN-PQ';

-- Cập nhật số điện thoại của hành khách có passenger_id = 'P03' thành '0999999999'.
update passengers 
set phone = '0999999999'
where passenger_id = 'P03';

-- Xóa tất cả các bản ghi đặt vé trong bảng Bookings có trạng thái là 'Cancelled' và được đặt trước ngày '2025-10-03'.
delete from bookings 
where booking_status = 'Cancelled' and booking_date < '2025-10-03';

-- Liệt kê các chuyến bay gồm flight_id, route_name, ticket_price có giá vé từ 1,200,000 đến 2,500,000 và đang có available_seats > 0. 
select flight_id, route_name, ticket_price 
from flights
where ticket_price between 1200000 and 2500000 and available_seats > 0;

-- Lấy thông tin full_name, email của những hành khách có họ là 'Trần'.
select full_name, email 
from passengers 
where full_name like 'Trần%';

-- Hiển thị danh sách các vé đã đặt gồm booking_id, passenger_id, booking_date. Sắp xếp theo booking_date giảm dần.
select booking_id, passenger_id, booking_date
from bookings
order by booking_date desc;

-- Lấy ra 3 chuyến bay có giá vé (ticket_price) đắt nhất trong hệ thống.
select *
from flights
order by ticket_price desc
limit 3;

-- Hiển thị danh sách route_name, available_seats từ bảng Flights, bỏ qua 2 chuyến bay đầu tiên và lấy 2 chuyến bay tiếp theo (Phân trang).
select route_name, available_seats
from flights
limit 2 offset 2;

-- Hiển thị danh sách gồm: booking_id, full_name (của hành khách), route_name (của chuyến bay) và booking_date. 
-- Chỉ lấy những vé đang có trạng thái 'Booked'.
select b.booking_id, p.full_name, f.route_name, b.booking_date
from bookings b
join passengers p on b.passenger_id = p.passenger_id
join flights f on b.flight_id = f.flight_id
where b.booking_status = 'Booked';

-- Liệt kê tất cả các Hãng hàng không (Airlines) và tên chặng bay (route_name) thuộc hãng đó. 
-- Hiển thị cả những hãng chưa có chuyến bay nào khai thác.
select a.airline_name, f.route_name
from airlines a
left join flights f on a.airline_id = f.airline_id;