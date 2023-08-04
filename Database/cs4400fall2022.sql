-- CS4400: Introduction to Database Systems (Fall 2022)
-- Project Phase II: Database Schema SOLUTION [v2] Wednesday, November 30, 2022
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

drop database if exists cs4400fall2022;
create database if not exists cs4400fall2022;
use cs4400fall2022;
-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table cs4400fall2022.users (
username varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date not null,
primary key (username)
) engine = innodb;

create table cs4400fall2022.employees (
username varchar(40) not null,
taxID varchar(40) not null,
hired date not null,
experience integer not null,
salary integer not null,
primary key (username),
unique key (taxID)
) engine = innodb;

create table cs4400fall2022.restaurant_owners (
username varchar(40) not null,
primary key (username)
) engine = innodb;

create table cs4400fall2022.pilots (
username varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (username),
unique key (licenseID)
) engine = innodb;

create table cs4400fall2022.workers (
username varchar(40) not null,
primary key (username)
) engine = innodb;

create table cs4400fall2022.ingredients (
barcode varchar(40) not null,
iname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table cs4400fall2022.locations (
label varchar(40) not null,
x_coord integer not null,
y_coord integer not null,
space integer not null,
primary key (label)
) engine = innodb;

create table cs4400fall2022.restaurants (
long_name varchar(40) not null,
rating integer not null,
spent integer not null,
location varchar(40) not null,
funded_by varchar(40) default null,
primary key (long_name)
) engine = innodb;

create table cs4400fall2022.delivery_services (
id varchar(40) not null,
long_name varchar(100) not null,
home_base varchar(40) not null,
manager varchar(40) not null,
primary key (id),
unique key (manager)
) engine = innodb;

create table cs4400fall2022.drones (
id varchar(40) not null,
tag integer not null,
fuel integer not null,
capacity integer not null,
sales integer not null,
flown_by varchar(40) default null,
swarm_id varchar(40) default null,
swarm_tag integer default null,
hover varchar(40) not null,
primary key (id, tag)
) engine = innodb;

create table cs4400fall2022.payload (
id varchar(40) not null,
tag integer not null,
barcode varchar(40) not null,
quantity integer not null,
price integer not null,
primary key (id, tag, barcode)
) engine = innodb;

create table cs4400fall2022.work_for (
username varchar(40) not null,
id varchar(40) not null,
primary key (username, id)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table employees add constraint fk1 foreign key (username) references users (username)
	on update cascade on delete cascade;
alter table restaurant_owners add constraint fk2 foreign key (username)
	references users (username) on update cascade on delete cascade;
alter table pilots add constraint fk3 foreign key (username) references employees (username)
	on update cascade on delete cascade;
alter table workers add constraint fk4 foreign key (username) references employees (username)
	on update cascade on delete cascade;
alter table restaurants add constraint fk10 foreign key (location) references locations (label)
	on update cascade;
alter table restaurants add constraint fk12 foreign key (funded_by)
	references restaurant_owners (username);
alter table delivery_services add constraint fk11 foreign key (home_base)
	references locations (label) on update cascade;
alter table delivery_services add constraint fk15 foreign key (manager)
	references workers (username);
alter table drones add constraint fk5 foreign key (id) references delivery_services (id);
alter table drones add constraint fk13 foreign key (flown_by) references pilots (username);
alter table drones add constraint fk14 foreign key (swarm_id, swarm_tag)
	references drones (id, tag) on update cascade on delete cascade;
alter table drones add constraint fk16 foreign key (hover) references locations (label)
	on update cascade;
alter table payload add constraint fk6 foreign key (id, tag) references drones (id, tag);
alter table payload add constraint fk7 foreign key (barcode) references ingredients (barcode);
alter table work_for add constraint fk8 foreign key (username) references employees (username);
alter table work_for add constraint fk9 foreign key (id) references delivery_services (id);

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into cs4400fall2022.users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28'),
('mrobot1', 'Mister', 'Robot', '10 Autonomy Trace', '1988-11-02'),
('mrobot2', 'Mister', 'Robot', '10 Clone Me Circle', '1988-11-02'),
('ckann5', 'Carrot', 'Kann', '64 Knights Square Trail', '1972-09-01'),
('rlopez6', 'Radish', 'Lopez', '8 Queens Route', '1999-09-03');

insert into cs4400fall2022.employees values
('awilson5', '111-11-1111', '2020-03-15', 9, 46000),
('lrodriguez5', '222-22-2222', '2019-04-15', 20, 58000),
('tmccall5', '333-33-3333', '2018-10-17', 29, 33000),
('eross10', '444-44-4444', '2020-04-17', 10, 61000),
('hstark16', '555-55-5555', '2018-07-23', 20, 59000),
('echarles19', '777-77-7777', '2021-01-02', 3, 27000),
('csoares8', '888-88-8888', '2019-02-25', 26, 57000),
('agarcia7', '999-99-9999', '2019-03-17', 24, 41000),
('bsummers4', '000-00-0000', '2018-12-06', 17, 35000),
('fprefontaine6', '121-21-2121', '2020-04-19', 5, 20000),
('mrobot1', '101-01-0101', '2015-05-27', 8, 38000),
('mrobot2', '010-10-1010', '2015-05-27', 8, 38000),
('ckann5', '640-81-2357', '2019-08-03', 27, 46000),
('rlopez6', '123-58-1321', '2017-02-05', 51, 64000);

insert into cs4400fall2022.restaurant_owners values
('jstone5'), ('sprince6'), ('cjordan5');

insert into cs4400fall2022.pilots values
('awilson5', '314159', 41), ('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10), ('agarcia7', '610623', 38),
('bsummers4', '411911', 35), ('fprefontaine6', '657483', 2),
('echarles19', '236001', 10), ('csoares8', '343563', 7),
('mrobot1', '101010', 18), ('rlopez6', '235711', 58);

insert into cs4400fall2022.workers values
('tmccall5'), ('eross10'), ('hstark16'), ('echarles19'),
('csoares8'), ('mrobot2'), ('ckann5');

insert into cs4400fall2022.ingredients values
('pr_3C6A9R', 'prosciutto', 6), ('ss_2D4E6L', 'saffron', 3),
('hs_5E7L23M', 'truffles', 3), ('clc_4T9U25X', 'caviar', 5),
('ap_9T25E36L', 'foie gras', 4), ('bv_4U5L7M', 'balsamic vinegar', 4);

insert into cs4400fall2022.locations values
('plaza', 5, 12, 20), ('midtown', 1, 4, 3), ('highpoint', 7, 0, 2),
('southside', 3, -6, 3), ('mercedes', 1, 1, 2), ('avalon', 2, 16, 5),
('airport', -2, -9, 4), ('buckhead', 3, 8, 4);

insert into cs4400fall2022.restaurants values
('Lure', 5, 20, 'midtown', 'jstone5'), ('Ecco', 3, 0, 'buckhead', 'jstone5'),
('South City Kitchen', 5, 30, 'midtown', 'jstone5'), ('Tre Vele', 4, 10, 'plaza', null),
('Fogo de Chao', 4, 30, 'buckhead', null), ('Hearth', 4, 0, 'avalon', null),
('Il Giallo', 4, 10, 'mercedes', 'sprince6'), ('Bishoku', 5, 10, 'plaza', null),
('Casi Cielo', 5, 30, 'plaza', null), ('Micks', 2, 0, 'southside', null);

insert into cs4400fall2022.delivery_services values
('osf', 'On Safari Foods', 'southside', 'eross10'),
('hf', 'Herban Feast', 'southside', 'hstark16'),
('rr', 'Ravishing Radish', 'avalon', 'echarles19');

insert into cs4400fall2022.drones values
('osf', 1, 100, 9, 0, 'awilson5', null, null, 'airport'),
('hf', 1, 100, 6, 0, 'fprefontaine6', null, null, 'southside'),
('hf', 5, 27, 7, 100, 'fprefontaine6', null, null, 'buckhead'),
('hf', 8, 100, 8, 0, 'bsummers4', null, null, 'southside'),
('hf', 16, 17, 5, 40, 'fprefontaine6', null, null, 'buckhead'),
('rr', 3, 100, 5, 50, 'agarcia7', null, null, 'avalon'),
('rr', 7, 53, 5, 100, 'agarcia7', null, null, 'avalon'),
('rr', 8, 100, 6, 0, 'agarcia7', null, null, 'highpoint');

insert into cs4400fall2022.drones values
('osf', 2, 75, 7, 0, null, 'osf', 1, 'airport'),
('hf', 11, 25, 10, 0, null, 'hf', 5, 'buckhead'),
('rr', 11, 90, 6, 0, null, 'rr', 8, 'highpoint');

insert into cs4400fall2022.payload values
('osf', 1, 'pr_3C6A9R', 5, 20),
('osf', 1, 'ss_2D4E6L', 3, 23),
('osf', 2, 'hs_5E7L23M', 7, 14),
('hf', 1, 'ss_2D4E6L', 6, 27),
('hf', 5, 'hs_5E7L23M', 4, 17),
('hf', 5, 'clc_4T9U25X', 1, 30),
('hf', 8, 'pr_3C6A9R', 4, 18),
('hf', 11, 'ss_2D4E6L', 3, 19),
('rr', 3, 'hs_5E7L23M', 2, 15),
('rr', 3, 'clc_4T9U25X', 2, 28);

insert into cs4400fall2022.work_for values
('eross10', 'osf'), ('hstark16', 'hf'), ('echarles19', 'rr'),
('tmccall5', 'hf'), ('awilson5', 'osf'), ('fprefontaine6', 'hf'),
('bsummers4', 'hf'), ('agarcia7', 'rr'), ('mrobot1', 'osf'),
('mrobot1', 'rr'), ('ckann5', 'osf'), ('rlopez6', 'rr');

-- CS4400: Introduction to Database Systems (Fall 2022)
-- Project Phase III: Stored Procedures SHELL [v0] Monday, Oct 31, 2022
-- set global transaction isolation level serializable;
-- set global SQL_MODE = 'ANSI,TRADITIONAL';
-- set names utf8mb4;
-- set SQL_SAFE_UPDATES = 0;
-- notes for OH
-- Ask about autograder -> ask what's wrong
-- generally is this kind of logic ok?(Ask in ref to something in the middle)
-- 15, how to check for last constraint, two drones in the same location?
-- 19 wtf to do here
-- 20, clarify last detail
-- views: can we see an example?
-- use restaurant_supply_express;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_owner()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new owner.  A new owner must have a unique
username.  Also, the new owner is not allowed to be an employee. */
-- -----------------------------------------------------------------------------

drop procedure if exists add_owner;
delimiter //
create procedure add_owner (in ip_username varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500), in ip_birthdate date)
sp_main: begin 
	if exists(select * from restaurant_owners, employees where restaurant_owners.username = ip_username or employees.username = ip_username)
    then leave sp_main;
    else
    insert into users values(ip_username, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    insert into restaurant_owners values(ip_username);
    end if;
    
    -- ensure new owner has a unique username
end //
delimiter ;

-- [2] add_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new employee without any designated pilot or
worker roles.  A new employee must have a unique username unique tax identifier. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_employee;
delimiter //
create procedure add_employee (in ip_username varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500), in ip_birthdate date,
    in ip_taxID varchar(40), in ip_hired date, in ip_employee_experience integer,
    in ip_salary integer)
sp_main: begin

    -- ensure new owner has a unique username
    -- ensure new employee has a unique tax identifier
	if exists(select * from employees where employees.username = ip_username or employees.taxID = ip_taxID)
    then leave sp_main;
    else
    insert into users values(ip_username, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    insert into employees values(ip_username, ip_taxID, ip_hired, ip_employee_experience, ip_salary);
    end if;

end //
delimiter ;

-- [3] add_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure adds the pilot role to an existing employee.  The
employee/new pilot must have a unique license identifier. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_pilot_role;
delimiter //
create procedure add_pilot_role (in ip_username varchar(40), in ip_licenseID varchar(40),
	in ip_pilot_experience integer)
sp_main: begin
    -- ensure new employee exists
    -- ensure new pilot has a unique license identifier
    if not exists(select * from employees where employees.username = ip_username)
    then leave sp_main;
    else
    if exists(select * from pilots where pilots.licenseID = ip_licenseID)
    then leave sp_main;
    else
    insert into pilots (username, licenseID, experience) values(ip_username, ip_licenseID, ip_pilot_experience);
    end if;
    end if;
end //
delimiter ;

-- [4] add_worker_role()
-- -----------------------------------------------------------------------------
/* This stored procedure adds the worker role to an existing employee. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_worker_role;
delimiter //
create procedure add_worker_role (in ip_username varchar(40))
sp_main: begin
    -- ensure new employee exists
    if not exists(select employees.username from employees where employees.username = ip_username)
    then leave sp_main;
    else
    insert into workers (username) values(ip_username);
    end if;
end //
delimiter ;

-- [5] add_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ingredient.  A new ingredient must have a
unique barcode. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_ingredient;
delimiter //
create procedure add_ingredient (in ip_barcode varchar(40), in ip_iname varchar(100),
	in ip_weight integer)
sp_main: begin
	-- ensure new ingredient doesn't already exist
    if exists(select * from ingredients where ingredients.barcode = ip_barcode)
    then leave sp_main;
    else
    insert into ingredients (barcode, iname, weight) values(ip_barcode, ip_iname, ip_weight);
    end if;
end //
delimiter ;

-- [6] add_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new drone.  A new drone must be assigned 
to a valid delivery service and must have a unique tag.  Also, it must be flown
by a valid pilot initially (i.e., pilot works for the same service), but the pilot
can switch the drone to working as part of a swarm later. And the drone's starting
location will always be the delivery service's home base by default. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_drone;
delimiter //
create procedure add_drone (in ip_id varchar(40), in ip_tag integer, in ip_fuel integer,
	in ip_capacity integer, in ip_sales integer, in ip_flown_by varchar(40))
sp_main: begin
	-- ensure new drone doesn't already exist
    -- ensure that the delivery service exists
    -- ensure that a valid pilot will control the drone
    if exists(select * from drones where drones.id = ip_id and drones.tag = ip_tag)
    then leave sp_main;
    else
    if not exists(select * from delivery_services where ip_id = delivery_services.id)
    then leave sp_main;
    else
    if not exists(select * from pilots where pilots.username = ip_flown_by)
    then leave sp_main;
    else
    insert into drones (id, tag, fuel, capacity, sales, flown_by) values(ip_id, ip_tag, ip_fuel, ip_capacity, ip_sales, ip_flown_by);
    end if;
    end if;
    end if;
end //
delimiter ;

-- [7] add_restaurant()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new restaurant.  A new restaurant must have a
unique (long) name and must exist at a valid location, and have a valid rating.
And a resturant is initially "independent" (i.e., no owner), but will be assigned
an owner later for funding purposes. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_restaurant;
delimiter //
create procedure add_restaurant (in ip_long_name varchar(40), in ip_rating integer,
	in ip_spent integer, in ip_location varchar(40))
sp_main: begin
	-- ensure new restaurant doesn't already exist
    -- ensure that the location is valid
    -- ensure that the rating is valid (i.e., between 1 and 5 inclusively)
	if exists(select long_name from restaurants where restaurants.long_name = ip_long_name) 
	then leave sp_main;
	else
    if not exists(select * from locations where locations.label = ip_location)
    then leave sp_main;
    else
    if ip_rating not between 1 and 5
    then leave sp_main;
    else
	insert into restaurants (long_name, rating, spent, location) values(ip_long_name, ip_rating, ip_spent, ip_location);
	end if;
    end if;
    end if;
end //
delimiter ;
-- check if above stored procedure was flipped

-- [8] add_service()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new delivery service.  A new service must have
a unique identifier, along with a valid home base and manager. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_service;
delimiter //
create procedure add_service (in ip_id varchar(40), in ip_long_name varchar(100),
	in ip_home_base varchar(40), in ip_manager varchar(40))
sp_main: begin
	-- ensure new delivery service doesn't already exist
    -- ensure that the home base location is valid
    -- ensure that the manager is valid
    if exists(select * from delivery_services where ip_id = delivery_services.id)
    then leave sp_main;
    else
    if not exists (select * from locations where locations.label = ip_home_base)
    then leave sp_main;
    else if not exists (select * from restaurant_owners where ip_manager = restaurant_owners.username)
    then leave sp_main;
    else
    insert into delivery_services values(ip_id, ip_long_name, ip_home_base, ip_manager);
    end if;
    end if;
    end if;
end //
delimiter ;

-- [9] add_location()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new location that becomes a new valid drone
destination.  A new location must have a unique combination of coordinates.  We
could allow for "aliased locations", but this might cause more confusion that
it's worth for our relatively simple system. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_location;
delimiter //
create procedure add_location (in ip_label varchar(40), in ip_x_coord integer,
	in ip_y_coord integer, in ip_space integer)
sp_main: begin
	-- ensure new location doesn't already exist
    -- ensure that the coordinate combination is distinct
    if exists(select * from locations where ip_label = locations.label) 
    then leave sp_main;
    else
    if exists (select * from locations where ip_x_coord = locations.x_coord and ip_y_coord = locations.y_coord)
    then leave sp_main;
    else
    insert into locations values(ip_label, ip_x_coord, ip_y_coord, ip_space);
    end if;
    end if;
end //
delimiter ;

-- [10] start_funding()
-- -----------------------------------------------------------------------------
/* This stored procedure opens a channel for a restaurant owner to provide funds
to a restaurant. If a different owner is already providing funds, then the current
owner is replaced with the new owner.  The owner and restaurant must be valid. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_funding;
delimiter //
create procedure start_funding (in ip_owner varchar(40), in ip_long_name varchar(40))
sp_main: begin
	-- ensure the owner and restaurant are valid
    if (not exists(select username from restaurant_owners where restaurant_owners.username = ip_owner)) or (not exists(select * from restaurants where restaurant.long_name = ip_long_name))
    then leave sp_main;
    else
    UPDATE restaurants SET funded_by = ip_owner WHERE long_name = ip_long_name;
    end if;
end //
delimiter ;

-- [11] hire_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure hires an employee to work for a delivery service.
Employees can be combinations of workers and pilots. If an employee is actively
controlling drones or serving as manager for a different service, then they are
not eligible to be hired.  Otherwise, the hiring is permitted. */
-- -----------------------------------------------------------------------------
drop procedure if exists hire_employee;
delimiter //
create procedure hire_employee (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee hasn't already been hired
	-- ensure that the employee and delivery service are valid
    -- ensure that the employee isn't a manager for another service
	-- ensure that the employee isn't actively controlling drones for another service
    if exists (select * from work_for where work_for.username = ip_username)
    then leave sp_main;
    else
    if not exists(select * from employees, delivery_services where employees.username = ip_username and delivery_services.id = ip_id)
    then leave sp_main;
    else 
    if exists (select * from delivery_services where delivery_services.manager = ip_username)
    then leave sp_main;
    else
    if exists(select * from drones where drones.id != ip_id and drones.flown_by = ip_username)
    then leave sp_main;
    else
    insert into work_for values(ip_username, ip_id);
    end if;
    end if;
    end if;
    end if;
    
end //
delimiter ;

-- [12] fire_employee()
-- -----------------------------------------------------------------------------
/* This stored procedure fires an employee who is currently working for a delivery
service.  The only restrictions are that the employee must not be: [1] actively
controlling one or more drones; or, [2] serving as a manager for the service.
Otherwise, the firing is permitted. */
-- -----------------------------------------------------------------------------
drop procedure if exists fire_employee;
delimiter //
create procedure fire_employee (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee is currently working for the service
    -- ensure that the employee isn't an active manager
	-- ensure that the employee isn't controlling any drones
    if not exists(select * from work_for where work_for.username = ip_username and work_for.id = ip_id)
    then leave sp_main;
    else
    if exists (select * from delivery_services where delivery_services.manager = ip_username)
    then leave sp_main;
    else 
    if exists (select * from drones where drones.flown_by = ip_username)
    then leave sp_main;
    delete from work_for where ip_username=username and ip_id = id;
    end if;
    end if;
    end if;
end //
delimiter ;

-- [13] manage_service()
-- -----------------------------------------------------------------------------
/* This stored procedure appoints an employee who is currently hired by a delivery
service as the new manager for that service.  The only restrictions are that: [1]
the employee must not be working for any other delivery service; and, [2] the
employee can't be flying drones at the time.  Otherwise, the appointment to manager
is permitted.  The current manager is simply replaced.  And the employee must be
granted the worker role if they don't have it already. */
-- -----------------------------------------------------------------------------
drop procedure if exists manage_service;
delimiter //
create procedure manage_service (in ip_username varchar(40), in ip_id varchar(40))
sp_main: begin
	-- ensure that the employee is currently working for the service
	-- ensure that the employee is not flying any drones
    -- ensure that the employee isn't working for any other services
    -- add the worker role if necessary
    if not exists(select * from work_for where ip_username=username and id=ip_id)
	then leave sp_main;
	else
	if exists(select * from drones where drones.flown_by = ip_username)
	then leave sp_main;
	else
    if exists(select * from work_for where ip_username=username and id!=ip_id)
    then leave sp_main;
    else
    if not exists(select * from workers where ip_username = workers.username)
    then insert into workers values(ip_username);
    end if;
	UPDATE delivery_services SET delivery_services.manager = ip_username WHERE delivery_services.id= ip_id;
	end if;
	end if;
    end if;
end //

delimiter ;

-- [14] takeover_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows a valid pilot to take control of a lead drone owned
by the same delivery service, whether it's a "lone drone" or the leader of a swarm.
The current controller of the drone is simply relieved of those duties. And this
should only be executed if a "leader drone" is selected. */
-- -----------------------------------------------------------------------------
drop procedure if exists takeover_drone;
delimiter //
create procedure takeover_drone (in ip_username varchar(40), in ip_id varchar(40),
	in ip_tag integer)
sp_main: begin
	-- ensure that the employee is currently working for the service
	-- ensure that the selected drone is owned by the same service and is a leader and not follower
	-- ensure that the employee isn't a manager
    -- ensure that the employee is a valid pilot
    if not exists(select username, id from work_for where ip_username=username and id=ip_id)
	then leave sp_main;
	else
    if not exists(select * from drones where ip_id = drones.id and ip_tag = drones.tag and drones.swarm_tag is null and drones.swarm_id is null)
    then leave sp_main;
    else 
    if exists(select * from delivery_services where delivery_services.manager = ip_username)
    then leave sp_main;
    else
    if not exists (select * from pilots where pilots.username = ip_username)
    then leave sp_main;
    else
    update drones set flown_by = ip_username where ip_id = id and ip_tag = tag;
    end if;
    end if;
    end if;
    end if;
    -- not sure about this one
end //
delimiter ;

-- [15] join_swarm()
-- -----------------------------------------------------------------------------
/* This stored procedure takes a drone that is currently being directly controlled
by a pilot and has it join a swarm (i.e., group of drones) led by a different
directly controlled drone. A drone that is joining a swarm connot be leading a
different swarm at this time.  Also, the drones must be at the same location, but
they can be controlled by different pilots. */
-- -----------------------------------------------------------------------------
drop procedure if exists join_swarm;
delimiter //
create procedure join_swarm (in ip_id varchar(40), in ip_tag integer,
	in ip_swarm_leader_tag integer)
sp_main: begin
	-- ensure that the swarm leader is a different drone
	-- ensure that the drone joining the swarm is valid and owned by the service
    -- ensure that the drone joining the swarm is not already leading a swarm
	-- ensure that the swarm leader drone is directly controlled
	-- ensure that the drones are at the same location
    if ip_tag = ip_swarm_leader_tag
    then leave sp_main;
    else
    if not exists(select * from delivery_services, drones where drones.id = ip_id and drones.tag = ip_tag and delivery_services.id = ip_id)
    then leave sp_main;
    -- check if there exists a drone ip_id and ip_tag provided, if there doesn't exist a drone then quit
    else
    if exists(select * from drones where drones.id = ip_id and drones.tag = ip_tag and drones.swarm_id is null and drones.swarm_tag is null)
    then leave sp_main;
    -- change startubg from drones.tag = ip_tag to swarm tag == ip_tag
    else
    if not exists(select * from drones where drones.id = ip_id and drones.tag = ip_tag and drones.flown_by is not null)
    then leave sp_main;
    -- change ip_tag to ip_swarmleadertag
    else
    if count((select * from drones where drones.id = ip_id and (drones.tag = ip_tag or drones.tag = ip_swarm_leader_tag) group by drones.location)) != 1
    then leave sp_main;
    else
    -- check the locations of drones
    update drones set drones.swarm_id = ip_id, drones.swarm_tag = ip_swarm_leader_tag where drones.id = ip_id;
    
    
    
    -- if not exists(select tag, username, swarm_id, swarm_tag from drones where swarm_tag = null and swarm_id=null and tag != ip_tag and id != ip_id)
    -- then leave sp_main;
	-- else
    -- if not exists(select username, tag, swarm_id, swarm_tag from drones where username = ip_username and tag = ip_tag and swarm_tag!= null and swarm_id != null)
    -- then leave sp_main;
    -- else
    -- if not exists (select tag, flown_by from drones where ip_swarm_leader_tag = tag and flown_by != null)
    -- then leave sp_main;
    -- else
	-- if not exists (select * from drones, locations where drones.id = ip_id and drones.location = drones.swarm_tag.location)
    -- then leave sp_main;
    -- else
    
    end if;
    end if;
    end if;
    end if;
    end if;
end //
delimiter ;

-- [16] leave_swarm()
-- -----------------------------------------------------------------------------
/* This stored procedure takes a drone that is currently in a swarm and returns
it to being directly controlled by the same pilot who's controlling the swarm. */
-- -----------------------------------------------------------------------------
drop procedure if exists leave_swarm;
delimiter //
create procedure leave_swarm (in ip_id varchar(40), in ip_swarm_tag integer)
sp_main: begin
	-- ensure that the selected drone is owned by the service and flying in a swarm
    if not exists(select * from drones, delivery_service where drones.id = ip_id and delivery_service.id = ip_id and drones.tag = ip_swarm_tag)
    then leave sp_main;
    else
    UPDATE drones SET swarm_id = null and swarm_tag = null WHERE drones.id = ip_id and drones.swarm_tag = ip_swarm_tag;
    end if;
end //
delimiter ;

-- [17] load_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to add some quantity of fixed-size packages of
a specific ingredient to a drone's payload so that we can sell them for some
specific price to other restaurants.  The drone can only be loaded if it's located
at its delivery service's home base, and the drone must have enough capacity to
carry the increased number of items.

The change/delta quantity value must be positive, and must be added to the quantity
of the ingredient already loaded onto the drone as applicable.  And if the ingredient
already exists on the drone, then the existing price must not be changed. */
-- -----------------------------------------------------------------------------
drop procedure if exists load_drone;
delimiter //
create procedure load_drone (in ip_id varchar(40), in ip_tag integer, in ip_barcode varchar(40),
	in ip_more_packages integer, in ip_price integer)
sp_main: begin
	-- ensure that the drone being loaded is owned by the service
	-- ensure that the ingredient is valid
    -- ensure that the drone is located at the service home base
	-- ensure that the quantity of new packages is greater than zero
	-- ensure that the drone has sufficient capacity to carry the new packages
    -- add more of the ingredient to the drone
	if not exists(select * from drones, delivery_services where drones.id = ip_id and delivery_services.id = ip_id and drones.tag = ip_tag)
    then leave sp_main;
    else
	if not exists(select * from ingredients where ingredients.barcode = ip_barcode)
    then leave sp_main;
    else
    if not exists(select * from drones, delivery_services where drones.hover = delivery_services.homebase)
    then leave sp_main;
    else
    if (ip_more_packages<=0)
    then leave sp_main;
    else
    if (select * from drones, payload where id = ip_id and tag = ip_tag and (capacity - quantity - ip_more_packages) <=0)
    then leave sp_main;
    else
    UPDATE payload SET barcode = ip_barcode, quantity = quantity + ip_more_packages, price = ip_price WHERE id = ip_id and tag = ip_tag;
    end if;
    end if;
    end if;
    end if;
    end if;
    
end //
delimiter ;

-- [18] refuel_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to add more fuel to a drone. The drone can only
be refueled if it's located at the delivery service's home base. */
-- -----------------------------------------------------------------------------
drop procedure if exists refuel_drone;
delimiter //
create procedure refuel_drone (in ip_id varchar(40), in ip_tag integer, in ip_more_fuel integer)
sp_main: begin
	-- ensure that the drone being switched is valid and owned by the service
    -- ensure that the drone is located at the service home base
    if not exists(select * from drones, delivery_services where delivery_services.id = ip_id and drones.id = ip_id and drones.tag = ip_tag)
    then leave sp_main;
    else
    if not exists(select * from drones where drones.hover = drones.id.home_base)
    then leave sp_main;
    else
    UPDATE drones set fuel = fuel + ip_more_fuel where id = ip_id and tag = ip_tag;
    end if;
    end if;
end //
delimiter ;

-- [19] fly_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure allows us to move a single or swarm of drones to a new
location (i.e., destination). The main constraints on the drone(s) being able to
move to a new location are fuel and space.  A drone can only move to a destination
if it has enough fuel to reach the destination and still move from the destination
back to home base.  And a drone can only move to a destination if there's enough
space remaining at the destination.  For swarms, the flight directions will always
be given to the lead drone, but the swarm must always stay together. */
-- -----------------------------------------------------------------------------
drop function if exists fuel_required;
delimiter //
create function fuel_required (ip_departure varchar(40), ip_arrival varchar(40))
	returns integer reads sql data
begin
	if (ip_departure = ip_arrival) then return 0;
    else return (select 1 + truncate(sqrt(power(arrival.x_coord - departure.x_coord, 2) + power(arrival.y_coord - departure.y_coord, 2)), 0) as fuel
		from (select x_coord, y_coord from locations where label = ip_departure) as departure,
        (select x_coord, y_coord from locations where label = ip_arrival) as arrival);
	end if;
     
end //
delimiter ;

drop procedure if exists fly_drone;
delimiter //
create procedure fly_drone (in ip_id varchar(40), in ip_tag integer, in ip_destination varchar(40))
sp_main: begin
	-- ensure that the lead drone being flown is directly controlled and owned by the service
    -- ensure that the destination is a valid location
    -- ensure that the drone isn't already at the location
    -- ensure that the drone/swarm has enough fuel to reach the destination and (then) home base
    -- ensure that the drone/swarm has enough space at the destination for the flight
    if not exists(select * from drones, work_for, delivery_services where delivery_services.id = ip_id)
    then leave sp_main;
    else
    -- fix pilot
    -- if not exists(select * from drones, work_for, delivery_services where drones.flown_by.username = 
    if not exists (select * from locations where locations.label = ip_destination)
    then leave sp_main;
    else
    if not exists (select * from drones, locations where drones.hover.x_coord = ip_destination.x_coord and drones.hover.y_coord = ip_destination.y_coord)
    then leave sp_main;
    else
    if not exists (select * from drones, location, delivery_services where delivery_services.id = ip_id and (fuel_required(drones.hover, ip_destination)+fuel_required(ip_destination, delivery_services.home_base.label))<0) 
	then leave sp_main;
    else
    if not exists (select * from locations where locations.space>0)
    then leave sp_main;
    else
--     SELECT id, tag, count(*) from drones group by flown_by 
--     if not exists (select * from )
    UPDATE drones set fuel = fuel - fuel_required(drones.hover, ip_destination);
    UPDATE drones set hover = ip_destination;
    end if;
    end if;
    end if;
    end if;
    end if;
end //

delimiter ;

-- [20] purchase_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure allows a restaurant to purchase ingredients from a drone
at its current location.  The drone must have the desired quantity of the ingredient
being purchased.  And the restaurant must have enough money to purchase the
ingredients.  If the transaction is otherwise valid, then the drone and restaurant
information must be changed appropriately.  Finally, we need to ensure that all
quantities in the payload table (post transaction) are greater than zero. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ingredient;
delimiter //
create procedure purchase_ingredient (in ip_long_name varchar(40), in ip_id varchar(40),
	in ip_tag integer, in ip_barcode varchar(40), in ip_quantity integer)
sp_main: begin
	-- ensure that the restaurant is valid
    -- ensure that the drone is valid and exists at the resturant's location
	-- ensure that the drone has enough of the requested ingredient
	-- update the drone's payload
    -- update the monies spent and gained for the drone and restaurant
    -- ensure all quantities in the payload table are greater than zero
    if not exists(select * from restaurants where long_name = ip_long_name)
    then leave sp_main;
    else
    if not exists(select * from drones, restaurants where drones.tag = ip_tag and drones.id = ip_id and drones.hover = restaurants.location)
    then leave sp_main;
    else
    if not exists(select * from drones, ingredients, payload where payload.tag = ip_tag and payload.id = ip_id and payload.barcode = ip_barcode and payload.quantity >= ip_quantity)
    then leave sp_main;
    else
    if exists (select quantity from payload where payload.quantity <= 0)
    then leave sp_main;
    -- doesn't look right, ensure all quantities in the payload table are greater than zero 
    else
	UPDATE restaurants set restaurants.spent = payload.price * payload.quantity where (restaurants.long_name = ip_long_name and payload.id = ip_id and payload.tag=ip_tag);
    UPDATE drones set drones.sales = payload.price * payload.quantity where (drones.id = ip_id and drones.tag = ip_tag and payload.tag=ip_tag);
    UPDATE payload set payload.quantity = payload.quantity - ip_quantity;

    end if;
    end if;
    end if;
    end if;

end //
delimiter ;

-- [21] remove_ingredient()
-- -----------------------------------------------------------------------------
/* This stored procedure removes an ingredient from the system.  The removal can
occur if, and only if, the ingredient is not being carried by any drones. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_ingredient;
delimiter //
create procedure remove_ingredient (in ip_barcode varchar(40))
sp_main: begin
	-- ensure that the ingredient exists
    -- ensure that the ingredient is not being carried by any drones
    if not exists(select * from ingredients where ingredients.barcode = ip_barcode)
    then leave sp_main;
    else
    if exists (select * from payload where payload.barcode = ip_barcode)
    then leave sp_main;
    else
    delete from ingredients where ingredients.barcode = ip_barcode;
    end if;
    end if;
end //
delimiter ;

-- [22] remove_drone()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a drone from the system.  The removal can
occur if, and only if, the drone is not carrying any ingredients, and if it is
not leading a swarm. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_drone;
delimiter //
create procedure remove_drone (in ip_id varchar(40), in ip_tag integer)
sp_main: begin
	-- ensure that the drone exists
    -- ensure that the drone is not carrying any ingredients
	-- ensure that the drone is not leading a swarm
    if not exists (select * from drones where drones.id = ip_id and drones.tag = ip_tag)
    then leave sp_main;
    else
    if exists (select * from payload where payload.id = ip.id and payload.tag = ip_tag and payload.quantity > 0)
    then leave sp_main;
    else if exists (select * from drones where drones.id = ip_id and drones.tag = ip_tag and (drones.swarm_id is null or drones.tag is null))
    then leave sp_main;
    else
    delete from drones where drones.id = ip_id and drones.tag = ip_tag;
    end if;
    end if;
    end if;
end //
delimiter ;

-- [23] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a pilot from the system.  The removal can
occur if, and only if, the pilot is not controlling any drones.  Also, if the
pilot also has a worker role, then the worker information must be maintained;
otherwise, the pilot's information must be completely removed from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_username varchar(40))
sp_main: begin
	-- ensure that the pilot exists
    -- ensure that the pilot is not controlling any drones
    -- remove all remaining information unless the pilot is also a worker
    if not exists(select * from pilots where pilots.username = ip_username)
    then leave sp_main;
    else
    if exists(select * from drones where drones.flown_by = username) 
    then leave sp_main;
    else 
    delete from pilots where pilots.username = ip_username;
    if exists(select * from pilots, workers where pilots.username = ip_username and pilots.username = workers.username)
    then leave sp_main;
    else
    delete from employees where employees.username = ip_username;
    end if;
    end if;
    end if;
end //
delimiter ;

-- [24] display_owner_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of an owner.
For each owner, it includes the owner's information, along with the number of
restaurants for which they provide funds and the number of different places where
those restaurants are located.  It also includes the highest and lowest ratings
for each of those restaurants, as well as the total amount of debt based on the
monies spent purchasing ingredients by all of those restaurants. And if an owner
doesn't fund any restaurants then display zeros for the highs, lows and debt. */
-- -----------------------------------------------------------------------------
create or replace view display_owner_view as
select restaurant_owners.username, employees.taxID, employees.hired, employees.experience, employees.salary, count(restaurants.funded_by), max(restaurants.rating), min(restaurants.rating), restaurants.spent
from restaurant_owners, employees 
left outer join restaurants 
on restaurants.funded_by = username
group by restaurant_owners.username, restaurants.location;
-- how do you display zeros instead of nulls?


-- select * from restaurant_owners;

-- group by username

-- [25] display_employee_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of an employee.
For each employee, it includes the username, tax identifier, hiring date and
experience level, along with the license identifer and piloting experience (if
applicable), and a 'yes' or 'no' depending on the manager status of the employee. */
-- -----------------------------------------------------------------------------
create or replace view display_employee_view as
select employees.username, taxID, hired, employees.experience, pilots.licenseID
from employees
left outer join pilots
on pilots.username = employees.username;

-- [26] display_pilot_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a pilot.
For each pilot, it includes the username, licenseID and piloting experience, along
with the number of drones that they are controlling. */
-- -----------------------------------------------------------------------------
create or replace view display_pilot_view as
select pilots.username, pilots.licenseID, pilots.experience, count((drones.tag))
from pilots, drones
where drones.flown_by = pilots.username
group by pilots.username;

-- [27] display_location_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a location.
For each location, it includes the label, x- and y- coordinates, along with the
number of restaurants, delivery services and drones at that location. */
-- -----------------------------------------------------------------------------
create or replace view display_location_view as
select locations.label, locations.x_coord, locations.y_coord, count(restaurants.long_name), count(delivery_services.home_base), count((drones.tag)) 
from locations, delivery_services, drones, restaurants
where locations.label = restaurants.location and locations.label = delivery_services.home_base and drones.hover = locations.label
group by locations.label;

-- [28] display_ingredient_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of the ingredients.
For each ingredient that is being carried by at least one drone, it includes a list of
the various locations where it can be purchased, along with the total number of packages
that can be purchased and the lowest and highest prices at which the ingredient is being
sold at that location. */
-- -----------------------------------------------------------------------------
create or replace view display_ingredient_view as
select * 
from ingredients, delivery_services
group by ingredients.barcode;
-- lost on this one

-- [29] display_service_view()
-- -----------------------------------------------------------------------------
/* This view displays information in the system from the perspective of a delivery
service.  It includes the identifier, name, home base location and manager for the
service, along with the total sales from the drones.  It must also include the number
of unique ingredients along with the total cost and weight of those ingredients being
carried by the drones. */
-- -----------------------------------------------------------------------------
create or replace view display_service_view as
select delivery_services.id, delivery_services.long_name, delivery_services.home_base, delivery_services.manager, sum(drones.sales), count(ingredients.barcode), sum(payload.price * payload.quantity), sum(payload.quantity) 
from delivery_services, drones, ingredients, payload
where delivery_services.id = drones.id and delivery_services.id=payload.id and ingredients.barcode = payload.barcode and payload.id = drones.id
group by delivery_services.id, drones.tag, ingredients.barcode;
