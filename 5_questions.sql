

show tables;

select * from Pieces;
select * from Providers;
select * from provides; 


-- 5.1
-- Select the name of all the pieces. 
MariaDB [mytestdb]> select name from pieces;
+----------+
| name     |
+----------+
| Sprocket |
| Screw    |
| Nut      |
| Bolt     |
+----------+
4 rows in set (0.00 sec)

-- 5.2 
-- Select all the providers' data. 
MariaDB [mytestdb]> select * from providers;
+------+----------------------+
| Code | Name                 |
+------+----------------------+
| HAL  | Clarke Enterprises   |
| RBT  | Susan Calvin Corp.   |
| TNBC | Skellington Supplies |
+------+----------------------+
3 rows in set (0.00 sec)
 
-- 5.3
-- Obtain the average price of each piece (show only the piece code and the average price).
MariaDB [mytestdb]> select pi.code,avg(pro.price) from pieces pi, provides pro where pi.code = pro.piece group by pi.code;
+------+----------------+
| code | avg(pro.price) |
+------+----------------+
|    1 |      12.500000 |
|    2 |      16.333333 |
|    3 |      47.500000 |
|    4 |       6.000000 |
+------+----------------+
4 rows in set (0.00 sec)

-- 5.4 
-- Obtain the names of all providers who supply piece 1.

/* Without subquery */
MariaDB [mytestdb]> select pro.name from providers pro, provides prov where pro.code = prov.provider and prov.piece = 1;
+--------------------+
| name               |
+--------------------+
| Clarke Enterprises |
| Susan Calvin Corp. |
+--------------------+
2 rows in set (0.05 sec)

/* With subquery */
MariaDB [mytestdb]> select name from providers where code in (select provider from provides where piece = 1);
+--------------------+
| name               |
+--------------------+
| Clarke Enterprises |
| Susan Calvin Corp. |
+--------------------+
2 rows in set (0.03 sec) 


-- 5.5
-- Select the name of pieces provided by provider with code "HAL".
MariaDB [mytestdb]> select pi.name from pieces pi, provides prov where pi.code = prov.piece and prov.provider = 'HAL';
+----------+
| name     |
+----------+
| Sprocket |
| Screw    |
| Bolt     |
+----------+
3 rows in set (0.01 sec)

/* With EXISTS subquery */   
-- Interesting clause
MariaDB [mytestdb]> SELECT Name  FROM Pieces  WHERE EXISTS  (    SELECT * FROM Provides      WHERE Provider = 'HAL'        AND Piece = Pieces.Code  );
+----------+
| Name     |
+----------+
| Sprocket |
| Screw    |
| Bolt     |
+----------+
3 rows in set (0.00 sec)

-- 5.6
-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Intereting and important one.
-- For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
-- (note that there could be two providers who supply the same piece at the most expensive price).

MariaDB [mytestdb]> select max(price),pi.name from provides prov, pieces pi where pi.code = prov.piece group by piece;
+------------+----------+
| max(price) | name     |
+------------+----------+
|      15.00 | Sprocket |
|      20.00 | Screw    |
|      50.00 | Nut      |
|       7.00 | Bolt     |
+------------+----------+
4 rows in set (0.00 sec)
 

-- 5.7
-- Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
MariaDB [mytestdb]> insert into provides values(10,1,'TNBC',7);
Query OK, 1 row affected (0.09 sec)

MariaDB [mytestdb]> select * from provides;
+------+-------+----------+-------+
| Code | Piece | Provider | Price |
+------+-------+----------+-------+
|    1 |     1 | HAL      | 10.00 |
|    2 |     1 | RBT      | 15.00 |
|    3 |     2 | HAL      | 20.00 |
|    4 |     2 | RBT      | 15.00 |
|    5 |     2 | TNBC     | 14.00 |
|    6 |     3 | RBT      | 50.00 |
|    7 |     3 | TNBC     | 45.00 |
|    8 |     4 | HAL      |  5.00 |
|    9 |     4 | RBT      |  7.00 |
|   10 |     1 | TNBC     |  7.00 |
+------+-------+----------+-------+
10 rows in set (0.00 sec)

-- 5.8
-- Increase all prices by one cent.
MariaDB [mytestdb]> update provides set price = price + 0.1;
Query OK, 10 rows affected (0.11 sec)
Rows matched: 10  Changed: 10  Warnings: 0

MariaDB [mytestdb]> select * from provides;
+------+-------+----------+-------+
| Code | Piece | Provider | Price |
+------+-------+----------+-------+
|    1 |     1 | HAL      | 10.01 |
|    2 |     1 | RBT      | 15.01 |
|    3 |     2 | HAL      | 20.01 |
|    4 |     2 | RBT      | 15.01 |
|    5 |     2 | TNBC     | 14.01 |
|    6 |     3 | RBT      | 50.01 |
|    7 |     3 | TNBC     | 45.01 |
|    8 |     4 | HAL      |  5.01 |
|    9 |     4 | RBT      |  7.01 |
|   10 |     1 | TNBC     |  7.01 |
+------+-------+----------+-------+
10 rows in set (0.00 sec)


-- 5.9
-- Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
MariaDB [mytestdb]> delete from provides where provider = 'RBT' and piece = 4;
Query OK, 4 rows affected (0.06 sec)

MariaDB [mytestdb]> select * from provides;
+------+-------+----------+-------+
| Code | Piece | Provider | Price |
+------+-------+----------+-------+
|    1 |     1 | HAL      | 11.00 |
|    2 |     1 | RBT      | 16.00 |
|    3 |     2 | HAL      | 21.00 |
|    4 |     2 | RBT      | 16.00 |
|    5 |     2 | TNBC     | 15.00 |
|    6 |     3 | RBT      | 51.00 |
|    7 |     3 | TNBC     | 46.00 |
|    8 |     4 | HAL      |  6.00 |
|   10 |     1 | TNBC     |  8.00 |
+------+-------+----------+-------+
10 rows in set (0.00 sec)


-- 5.10
-- Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces 
-- (the provider should still remain in the database).
MariaDB [mytestdb]> delete from provides where provider = 'RBT';
Query OK, 3 rows affected, 4 warnings (0.09 sec)

MariaDB [mytestdb]> select * from provides;
+------+-------+----------+-------+
| Code | Piece | Provider | Price |
+------+-------+----------+-------+
|    1 |     1 | HAL      | 11.00 |
|    3 |     2 | HAL      | 21.00 |
|    5 |     2 | TNBC     | 15.00 |
|    7 |     3 | TNBC     | 46.00 |
|    8 |     4 | HAL      |  6.00 |
|   10 |     1 | TNBC     |  8.00 |
+------+-------+----------+-------+
10 rows in set (0.00 sec)
