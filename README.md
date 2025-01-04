# Major-League-Baseball-
Analyzed player statistics over time and across different league ( SQL &amp; Excel )   
</br>  
<h3>Contents</h3> 
1. Situation <br> 
2. Objectives <br>  
3. Data Structure <br> 
4. Executive Summary <br>  
5. Insights and Findings for each Section <br> 

 * Schools attended <br>
 * Salary comparisons <br>
 * Career stats <br>
 * Player comparisons <br> 

<br>
<h3>SITUATION</h3>
<hr> 

As a Data Analyst Intern at **Major League Baseball (MLB)**, I’ve been granted access to decades of player records—spanning details 
from schools attended to salaries and performance metrics. My task? To uncover how player statistics have shifted over time and 
reveal key patterns across different teams in the league. <br> 

<h3>OBJECTIVES</h3> 
<hr> 
Analyzed the dataset across four key sections to uncover insights:<br> 

* **Career Stats:** What does each player's career journey look like? <br>
  
* **Player Comparisons:** How do players' attributes stack up across teams? <br>
  
* **Schools Attended:** Which schools have produced the most MLB players?	<br>
  
* **Salary Comparisons:** How much do teams invest in player salaries? <br>
<br> 

<h3>DATA STRUCTURE</h3> 
<hr> 
The dataset consists of four tables that capture various aspects of MLB players' historical data: <br>  

* **Players:** Contains unique player records, including attributes such as date of birth (DOB), debut and final game dates, and other quantifiable metrics like height, weight, and batting hand. <br> 

* **Salaries:** Records of player salaries paid by their respective teams for each year. <br> 

* **School Details:** Lists each school’s name along with its location. <br> 

* **Schools:** Tracks which schools players attended in a given year. <br>

Each table contains a different number of records. For instance, the Players table includes around 18,000 unique player records, while the Salaries table may vary in size depending on the number of salary records available. <br> 

*Data Source : http://seanlahman.com* <br> 
<br> 

![ERD](https://github.com/arghanilhub/Major-League-Baseball-/blob/main/ERD_MLB.png) <BR> 
<br>


<h3>EXECUTIVE SUMMARY</h3> 
<hr> 
 
The data reveals several long-term trends across MLB player careers, attributes, education, and salaries. Most players begin their careers in their early 20s and retire by their 40s, though a few rare cases have shown remarkable career longevity of over 30 years. Staying with the same team for both debut and final games over a decade is relatively uncommon but observed in a few teams. <br> 

Over the years, player weight has steadily increased, especially from the 1980s to 2000s, while height has remained constant. The number of schools producing MLB players grew significantly until 1990 but declined in recent decades, with talent coming from fewer institutions. <br>  
            
Salary trends show that team spending has steadily risen over the decades, with several teams surpassing $1 billion in annual spending, indicating a long-term investment in player retention and talent acquisition. <br> 
<br>                       

<h3>INSIGHTS & FINDINGS FOR EACH SECTION</h3> 
<hr> 

<h4>:one: PLAYER CAREER ANALYSIS </h4> 
<br> 

**Q1) What is the career length of each player, and how old were they at their first and last games? Which player had the longest career?** <br> 

:white_medium_square: Nicholas stands out with a career lasting **35 years**, making him the longest-serving player. Most players started their careers at 22 or 23 years old. Interestingly, a small group of four players continued playing well into their 50s, retiring at 55 or 57 — an impressive  stretch compared to the rest, who typically retired in their 40s. <br>   
            
**Q2) Which team did each player start and end their career with? How many players stayed with the same team from their debut to their final game, playing for over a decade?** <br>        
:white_medium_square: Out of the 18,000 player records we analyzed, we were able to track the debut and final teams for **912 players**. Interestingly, **322 of these players** started and ended their careers with the **same team** — though, of course, it's possible they played for other teams in between. <br> 

Now, here's the fascinating part: out of those, **19 players** had careers that spanned **over a decade** while still starting and finishing with the same team. Again, they might have had stints with other teams during their careers, but they made their debut and played their final game with the same franchise. <br> 

Looking at team trends, **CHA (Chicago White Sox)** and **OAK (Oakland Athletics)** were the most common starting points for players' careers, while **DET (Detroit Tigers)** and **PHI (Philadelphia Phillies)** were where many players played their last games. <br> 

And those rare, long-tenured players who stayed loyal to the same team from start to finish over a decade? They mostly belonged to **NYA (New York Yankees)** and **ATL (Atlanta Braves)** — two franchises known for their strong player retention. <br> 

                
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ![career](https://github.com/arghanilhub/Major-League-Baseball-/blob/main/career.png)              
           
