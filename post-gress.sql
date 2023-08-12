drop materialized view if exists sales_summary;
DROP TABLE IF EXISTS sale cascade;
DROP TABLE IF EXISTS users cascade;
drop table if exists items cascade;

/* 
 * users of the company
 */
CREATE TABLE users(
   id serial,
   name VARCHAR(255) NOT NULL,   
   email VARCHAR(255) NOT NULL,
   PRIMARY KEY(id)
);

create table items(
 id serial ,
 name VARCHAR(255) NOT NULL,   
 price real not null,
 primary key (id)
);

create table sale(
 id serial ,
 user_id int,
 item_id int,
 count int,
 primary key (id),
 CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
	  REFERENCES users(id),
  CONSTRAINT fk_item
      FOREIGN KEY(item_id) 
	  REFERENCES items(id)
);

/*
 * insert sample data
 */
INSERT INTO users(name, email)
VALUES('Anubhav', 'anubhav@gmail.com'),
      ('Arjun', 'arjun@gmail.com');	   


INSERT INTO items(name, price)
VALUES('i-pad', 50000),
      ('shampoo', 100),
      ('gym-gloves', 350);
      


INSERT INTO sale(user_id, item_id, count)
VALUES(1, 1, 1),
      (2, 3, 2),
      (1, 2, 1);
           
     
select * from users ;
select * from items ;
select * from sale ;

/*
 * query to take data from three table by taking joins
 * This might be query to get the sale details.
 */
select 
sale.id,
users.name as user_name,
users.email ,
items.name as item_name,
items.price,
sale.count
from sale 
inner join users on 
users.id = sale.user_id
inner join items on 
items.id = sale.item_id;


/*
 * create materialized view which caches the data
 */
CREATE MATERIALIZED VIEW sales_summary
AS
select 
sale.id,
users.name as user_name,
users.email ,
items.name as item_name,
items.price,
sale.count
from sale 
inner join users on 
users.id = sale.user_id
inner join items on 
items.id = sale.item_id
WITH NO DATA;

/*
 * Load data to view. It takes table lock
 */
REFRESH MATERIALIZED VIEW sales_summary;

/*
 * query from view
 */
select  * from sales_summary where id = 1 ;


/*
 * insert a new sale
 */

INSERT INTO sale(user_id, item_id, count)
VALUES(1, 3, 1);

/*
 * query from view does not reflect the new data
 */
select  * from sales_summary ;

/*
 * refresh materialized view to laod new data. You can also use below query to avoid taking lock from table
 *  REFRESH MATERIALIZED VIEW contacts_by_customer_name;
 */
REFRESH MATERIALIZED VIEW sales_summary;


/*
 * query from view does not reflect the new data
 */
select  * from sales_summary ;



