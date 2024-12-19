-- step 1 
create view rental_summary as 
select r.customer_id, 
		concat(c.first_name, ' ', c.last_name) as full_name, 
        left(c.email, 3) as email_prefix, 
        count(r.rental_id) as rental_count
from rental r
join customer c on r.customer_id = c.customer_id
group by 1, 2, 3
order by 4 desc;

-- step 2
create temporary table total_amount_paidd as
select rs.customer_id, rs.rental_count, sum(p.amount) as total_amount
from payment p
join rental_summary rs
on p.customer_id = rs.customer_id
group by 1, 2;

-- step 3
with customer_summary_report as (
	select r.full_name,
			r.email_prefix,
            r.rental_count,
            t.total_amount
	from rental_summary r
    join total_amount_paidd t on r.customer_id = t.customer_id)

select full_name, 
		email_prefix, 
        rental_count, 
        total_amount,
        round((total_amount/rental_count), 2) as average_payment_per_rental
from customer_summary_report;    
