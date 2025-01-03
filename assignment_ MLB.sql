--  ASSIGNMENT QUESTION 

-- SCHOOL - MLB players attend / What school does MLB players attend 
-- Q1) In each decade , how many school were there attended by MLB players ?  

/*
select   
	   (floor((yearID/10)) )*10 as decade ,         -- step 1: categorizing years into decades (MAIN CODE)
		 count(distinct schoolID) as count_schools   -- step2: count schools by decade 
from schools 
group by decade 
order by decade    */ 

-- Q2) Which 5 schools genrated most players ?
/*
 select schoolID, count(distinct playerID) as np  
 from schools 
 group by schoolID 
 order by np desc   */ 
 
 -- Q3) For each decade, which 3 schools generated the most players ? 
						
	with ct as		(	select   
								   (floor((yearID/10)) )*10 as decade , schoolID, 
								   count(distinct playerID) as count_players              
						from schools 
						group by decade, schoolID    
						order by decade  , count_players desc ) ,
                        
		ct2 as		 ( select decade, schoolID, count_players, 
					     row_number () over (partition by decade order by count_players desc ) as rk
				  from ct )              
				                          -- here it should be row_number() instead of dense_rank()
       select * 
       from ct2 
       where rk IN (1,2,3) ;         -- returning only top 3 schools with high number of students 
       
	/* dense_rank() - gives us all the 1,2 & 3's(which we don't need). but i just need only top 3 for each
     decade, row_number() will give only top 1,2, & 3. even if u have many 1's or 2's or 3.  */ 
     
-- -----------------------------------------------------------------------------------------------
--  SALARY ANALYSIS  
-- How much do teams spend on players salaries ? 

-- Q1) Return the top 20% of teams in terms of avg. annual salary 

with c1 as 	(	select teamID ,yearID,  count(distinct playerID) as no_players , avg(salary) as sal_avg
				from salaries  
				 group by teamID, yearID ),            -- 1st : avg salary per year - for each team 
                 
		c2	 as ( select teamID, round(avg(sal_avg)) as avg_sal_per_team   
				  from c1 
				  group by teamID  ) ,                 -- 2nd : Final avg across years - per team 
                  
        c3 as   ( select teamID, avg_sal_per_team , 
						ntile(5) over (order by avg_sal_per_team desc ) as rank_20_per
				  from c2 )                           -- 3rd : ranking evry team ( 20% ) 
                  
              select  teamID, 
                      round(avg_sal_per_team/1000000, 1) as avg_sal_in_mil    -- converting into Million ( for better readibility)
              from c3 
              where rank_20_per = 1 ;           -- 4th : Returning Top 20% teams ( based on avg annual salary ) 
				  
/* as it is being said- "avg annual spending" - [ annual spending] - they r doing sum of sal for each year 
    instead of doing avg(sal) in the first part. rest is same. so for annual spending- they r summing as for 
    each year how much they have spended and then findign  avg of all those years . But I don't know 
     mine i.e doing avg in 1st part also seems ligit */
                  
/* as each team occured in many years , and in those years there r  varying number of players . So for some
   years there are more rows than other year for a same team . Hence if we find the collective avg for teams 
   neglicting ( rows in there years ) it could skew our results , as the avg could heavilty sidelined for that
   year who has more years. So t okeep it  balanced , 1st - we avg for each for a given team ( mean - 
    avg salary for all those players for a year - for that team ) 2nd- then we did our final avg of all those 
    years for that team . In that way even if rows r more for some years - thisway it keep it balanced. */
    
    
-- Q2) For each team, show the cumulative sum of salaries over the years ?      
/*                
with c1 as 	(	select teamID ,yearID,  count(distinct playerID) as no_players , sum(salary) as sal_sum
				from salaries  
				 group by teamID, yearID )           -- 1st : sum salary per year for each team 
                 
		 select teamID, yearID , sal_sum, 
                round( sum(sal_sum) over (partition by teamID order by  yearID)) as cum_sum 
		 from c1 
	*/			                                    -- 2nd: then, cum_sum of those years of sal for each team
    
-- Q3) Return the First year that each team's cumulative spending surpassed 1 billion 
    
    with c1 as 	(	select teamID ,yearID,  count(distinct playerID) as no_players , sum(salary) as sal_sum
				from salaries  
				 group by teamID, yearID ) ,          -- 1st : sum salary per year for each team 
                 
		c2 as 	( select teamID, yearID , sal_sum, 
						 round(sum(sal_sum) over (partition by teamID order by  yearID)) as cum_sum 
				 from c1 ) ,                        -- 2nd : cumulative sum of sal for each year for a team
                 
		c3 as	( select teamID, yearID, cum_sum 
				 from c2 
				 where cum_sum > 1000000000 ),    -- 3rd : returning only those rows , where cum_sum surpss 1 bil
                 
		c4 as	(  select * , 
						  row_number () over (partition by teamID) as first_year 
				   from c3 )              -- here even if we do -(order by cum_sum)- results will be same, as we have alredy order by yearId, and it is cumulative sum - so naturally whaiver year hits the firt billion it will automaticlaly will be rank 1 for each team
                   
           select teamId, yearID, 
                   round(cum_sum/1000000000, 2) as cum_spending_billions   -- clean-up step ( converting whole cum_sum in billions for easy to read )
           from c4 
           where first_year = 1 ;       -- 4th : First year for every team - who's cum_sum surpassed - 1 billion
	
    
-- ----------------------------------------------------------------------------------------------------
 -- PLAYER CAREER ANALYSIS 
 -- What does each player career look like 
 
 /* Q1) Calculate the career length of each player , their age at their first game and 
		their age at their last game. (all in years) Sort from the longest career. */ 
        
      select  nameGiven,  
            ( year( finalGame ) - year( debut ) )   as career_length, 
            ( year( debut ) - ( birthYear ) )  as age_started_playing, 
            ( year( finalGame ) - ( birthYear ) )  as age_ended_playing
      from players   
      order by career_length desc ; 
        -- used here basic math to find- what was their age was -when they started playing and when they ended .
        -- BUT u can also u TIMESTAMPDIFF() to calculate "years" between two dates . 
      
 -- Q2) What team did each player play on for their starting and ending years ? 
/* 
with c1 as 	(  select  playerID, nameGiven, 
					   year( debut ) as starting_year ,
					   year( finalGame ) as ending_year 
			   from players  ) , 
               
	c2 as   (  select 	c1.playerID, c1.nameGiven, c1.starting_year, s.teamID as debut_team, c1.ending_year  
			   from 	c1  left join salaries s 
						on c1.playerID = s.playerID 
						AND c1.starting_year = s.yearID ) ,
					                                                 -- we can also perform this 2 joins together but keep alias diffet (salaries s and s2 ) 
	c3 as	(	select 		c2.playerID, c2.nameGiven, 
							c2.starting_year, c2.debut_team, 
							c2.ending_year, s2.teamID as final_team  
				from 		c2  left join  salaries s2 
							on c2.playerID = s2.playerID 
							AND c2.ending_year = s2.yearID )         
                            
		select * 
        from  c3 
        where    debut_team IS NOT NULL 
             AND final_team IS NOT NULL           */
        -- returning only those rows for which each player has both debut team and final team 
        
-- Q3) How many players started and ended on the same team and played for over a decade ? 
/*
      with c1 as 	(  select  playerID, nameGiven, 
					   year( debut ) as starting_year ,
					   year( finalGame ) as ending_year 
			   from players  ) , 
               
	c2 as   (  select 	c1.playerID, c1.nameGiven, c1.starting_year, s.teamID as debut_team, c1.ending_year  
			   from 	c1  left join salaries s 
						on c1.playerID = s.playerID 
						AND c1.starting_year = s.yearID ) ,
					
	c3 as	(	select 		c2.playerID, c2.nameGiven, 
							c2.starting_year, c2.debut_team, 
							c2.ending_year, s2.teamID as final_team  
				from 		c2  left join  salaries s2 
							on c2.playerID = s2.playerID 
							AND c2.ending_year = s2.yearID ),  
                            
		c4 as		(	select *  
					from  c3 
					where    debut_team IS NOT NULL 
						 AND final_team IS NOT NULL )     
                         
               select *                    -- this only (last)part, I have added from my prev. code 
               from c4 
               where   debut_team = final_team               -- Players who started and ended on the same team 
					   and  ending_year - starting_year > 10 ;  -- and also played over a decade 
     */                 
-- ---------------------------------------------------------------------------------------------------
-- PLAYER COMPARISON ANALYSIS 
-- How do player's attributes compare ? 

-- Q1) Create a Summary table that shows for each team, what percent(%) of players bat - right, left or both ? 
/*
with c1 as ( select s.teamID, p.playerID, p.nameGiven,  p.bats  
			 from  players p inner join salaries s 
				  on p.playerID = s.playerID )            -- consist's of duplicate player record in each team
          */        
   -- so, this code will skewing the results , hence need to exclude duplicate player record from each team 
   -- re-writing the whole code 
   
/*   
   with c1 as  (select s.teamID, p.playerID, p.nameGiven,  p.bats  
			from  players p inner join salaries s 
				  on p.playerID = s.playerID) ,  
                  
     c2 as  (select distinct playerID, teamID, nameGiven, bats     -- excluding DUPLICATE player's from each team
       from c1) , 
       
		c3 as	(   select teamID, 
				   sum(case when bats = 'R' then 1 else 0 end) as right_batsman, 
					sum(case when bats = 'L' then 1 else 0 end) as left_batsman,
					sum(case when bats = 'B' then 1 else 0 end) as both_hand_batsman    -- Summary table 
			 from c2
			 group by teamID ) , 
             
        c4 as    ( select teamID, right_batsman, left_batsman, both_hand_batsman, 
                    (right_batsman + left_batsman + both_hand_batsman) as total_sum     -- Total number of players for each team
             from c3 )                                                                 -- u can find total without even doing sum - take count(playerID) groped under each team
					  
      select teamID, 
           round ((right_batsman * 100 / total_sum), 1) as right_batsman_percent,
             round((left_batsman * 100 / total_sum), 1) as left_batsman_percent,
             round((both_hand_batsman * 100 / total_sum), 1) as both_hand_batsman_percent   -- Calculating percentages for right, left and both handed batsman
      from c4 
 */  
   
-- Q2) Which players have the same birthday (month & day) ? 
/*
with c1 as 	( select    birthMonth, birthDay , count(playerID) 
			 from      players 
			 group by  birthMonth, birthDay 
			 order by  birthMonth, birthDay )     -- upto this, code tells- No. of players who have same birth month & day 
			 
       select c1.birthMonth, c1.birthDay, p.nameGiven  
       from c1  left join players p 
            on c1.birthMonth = p.birthMonth 
            and c1.birthDay = p.birthDay      -- and full code- gives u the name of those players also 
            
       /* So, this code only gives u the list of player names who have same birth - MONTH & DAY NOT YEAR 
         That means - not the full birthday . 
         
         So to know also the names of those players who have exact same birthday- (years, months, day) 
         Here I'm used a new function called - GROUP_CONCAT() - which gives me the names of all players 
         who have same birthday in row-wise . 
 */           
         
  with c1 as      ( select    nameGiven, 
                   cast(concat(birthYear, '-' ,birthMonth, '-' ,birthDay) as date ) as birthday    
		 from      players  )      
		-- combining year,month & day of birth for each player and converting its data-type into DATE from integer
 
      select birthday , 
            --  count(playerID) as count_of_players, 
              GROUP_CONCAT(nameGiven separator ',')  as names_of_players  
      from c1 
      where year(birthday) between 1984 and 1994 
      group by birthday
      order by birthday 
      
       -- taking only last part of data, as more have added in the last , so expected possible matches will be more
       -- GROUP_CONCAT() - 1st it groups all the rows who has same  birthdays then it combines tier names 
      
 
/*  Q3) How have avg height and weight at debut game changed over the years, 
		what's the decade-over-difference, with a moving avg ? */           
         
     -- Analyzing trends - how this avg(ht/wt) has changed "over the years or decade" 
/*     
with c1 as (select weight, height, year(debut) as debut_year  
			from players ) ,  
            
	 c2 as	(   select debut_year, round(avg(weight), 1) as avg_weight, round(avg(height), 1) as avg_height   
			   from c1    
			   group by debut_year
			   order by debut_year  ) , 
                          -- trends on avg(ht & wt) over the YEARS  
             
	c3 as	(	select   (floor( ( debut_year/ 10 ))) * 10 as decade , 
						 round(avg(avg_weight), 1) as dec_avg_wt,
						 round(avg(avg_height), 1) as dec_avg_ht    
				from c2 
				group by decade ) , 
						-- grouping into decades ( decade wise -avg wt & ht) 
            
	c4 as	  ( select   decade, 
					  dec_avg_wt, 
					  lag (dec_avg_wt) over (order by decade) as prev_wt, 
					  dec_avg_ht, 
					  lag (dec_avg_ht) over (order by decade) as prev_ht
             from c3 ) ,
                       -- assigning prev value ( helps in diffence ) 
                       
     c5 as    ( select decade, 
                 (dec_avg_wt - prev_wt) as diff_wt_prev_decade,
                 (dec_avg_ht - prev_ht) as diff_ht_prev_decade 
          from c4 ) 
                --  deacde-over-decade- wight & height diference 
            
         select debut_year, 
                avg_weight, 
                round(avg(avg_weight) over(order by debut_year rows between 9 preceding and current row), 1) as moving_avg_wt_years,
                avg_height,
                round(avg(avg_height) over(order by debut_year rows between 9 preceding and current row), 1) as moving_avg_ht_years
         from c2 
                  -- moving avg for weight & height over the YEARS  
                  
   */                