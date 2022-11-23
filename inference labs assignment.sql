#1)Write a query to identify students (Names) who have attended classes for at least 3 consecutive days
#(Attendance of 3 or more consecutive days)?

select user_tid, min(date), max(date)
from (select a.*,
             row_number() over (partition by user_id order by date) as seqnum,
             row_number() over (partition by user_id  order by date) as seqnum_a
      from attendance_table a
     ) a
where present = 'Yes'
group by user_id, (seqnum - seqnum_a)
having count(*) >= 3;

#2)Write a query to filter out redundant records from the table (e.g. row 1 and row 2 refers to the same
#match, so we need to keep only 1 of these rows in resultant table)
create table matchresult
(match_id int not null,team1 varchar(24),team2 varchar(30),winner varchar(20));
insert into matchresult
values(0001,'csk','mi','mi'),
	  (0001,'mi','csk','mi'),
      (0002,'mi','kkr','mi'),
      (0003,'rcb','rr','rr'),
      (0003,'rcb','rr','rr'),
      (0002,'kkr','mi','mi');
select match_id,team1,team2,winner from (select a.*,row_number() over (PARTITION BY match_id ORDER BY match_id)
 as row_num from matchresult a group by team1,team2) a group by match_id;
select a.*,row_number() over (PARTITION BY match_id ORDER BY match_id)
 as row_num from matchresult a group by team1,team2;
 
 ##3)Using the transactions table as described below, find out the count of users who transacted for
#the first time on a Monday (Not to be mistaken for identifying customers who have transacted on
#any Monday).
 select user_id, count(*)
from (
  select user_id,  MIN(transaction_date) as date from transaction
  group by user_id
  having DAYOFWEEK(date) = 2
) as a
group by user_id;


#4)a)Minimum salary, and the employee details related to it.
select * from salaries_table where salary=(select min(salary) from salaries_table);

#4)b)Running total of salary for all employees, ordered by emp_id.
SELECT * ,(
SELECT SUM(T2.SALARY)  
 FROM salaries_table AS T2
       WHERE T2.emp_id <= T1.emp_ID
) AS Running_Total
FROM salaries_table AS T1

#5)Write a query to fetch data in the following manner:
##Product_ID Product_Views Order_Quantity Product_Shares;

SELECT a.product_id, a.product_views,
b.order_quantity, c.product_shares 
FROM procuct_view a 
INNER JOIN product_purchase b 
ON a.product_id=b.product_id 
INNER JOIN  c 
ON a.product_id=c.product_id;