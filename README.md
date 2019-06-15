Operation Research Final Project
===

Operations research (OR) is a discipline that deals with the application of advanced analytical methods to help make better decisions.


## Group members
| B04902131 | B06705023 | B06705056 | B06504104 | B05701151 |
| :-------: | :-------: | :-------: | :-------: | :-------: |
|  黃郁凱   |  邱廷翔   |  馮正安   |  石子仙   |  廖守三   |

## Topic
The sleeping problem

## Agenda
1. Defining problems
2. Programming
3. Solving the first model
4. Refine the model

## Defining problems
人的每天生活作息，就跟電池一樣，面對任務時，我們會需要付出心力(放電)，而在晚上睡覺的時候，我們需要有足夠長的休息時間(充電)，來讓自己回復體力。在期末考試壓力大，想要找有趣的事情來解悶的我們，想探討一個人每天考量接下來兩周的任務決定今天應該睡多久，如果睡太多會有罪惡感，但睡太少又會精神不濟，做事效率不好。

而在這個報告中，我們只考量睡覺時間這個變數，其餘如入睡時間、任務先後的安排，並不是我們的目標，我們希望藉由OR的方法，來找出最佳化的睡覺時間。


### Precondition
1. Events are taken as given.
2. Exams of a day are taken right after you wake up.
3. Events are done instantaneously. 
4. A day begins when you go to bed.


## Programming

### Parameters
$$
\begin{split}
    &i \in \{1, \cdots, S(科目總數)\}\\
    &t \in \{1, \cdots, Days(總天數)\}\\
    &Days = \mbox{number of Days}\\
    &S = \mbox{number of subjects}\\
    &Tired_i=\mbox{tiredness of subject }i\quad &\forall i \in S\\
    &Credit_i=\mbox{credit of subject }i\quad& \forall i \in S\\
    &\overline{L}=\mbox{upper bound of }L\\
    &{C_{study}}_{it}=\begin{cases}1, &\mbox{if } t\mbox{ is before Test date of subject }i \\ 0, & \mbox{o/w}   \end{cases}\quad& \forall i \in S,t \in Days\\
    &{C_{test}}_{it}=\begin{cases}1, &\mbox{if } t\mbox{ is the Test date of subject }i \\ 0, & \mbox{o/w}   \end{cases}\quad &\forall i \in S,t \in Days\\
    &C_{\alpha}=\mbox{sensitivity of study efficiency}\\
    &C_{{weight}}=\mbox{to balance the influence of TU and Long-term strength}\quad&\\
    &C_{spirit}=\mbox{lower bound of }L\mbox{ to take test without penalty }\\
    &C_{r}=\mbox{slope of }f(x)\\
    &\beta_{sleep}=\mbox{how important one person evaluate sleeping}\\
    &\beta_{study}=\mbox{how important one person evaluate studying}\\
    &\beta_{demand}=\mbox{how important one person evaluate taking courses}\\
    &Subject_{it}=\mbox{time to take course }i\mbox{ at day }t\quad& \forall i \in S,t \in Days\\
    &\begin{split}
        f(L_t) & = \overline{L}\cdot C_r- | L_t-\overline{L}|\cdot C_r\\
               & = \overline{L}\cdot C_r- w_{L_t} \cdot C_r
     \end{split}
\end{split}
$$


### Variables
#### (1) Decision Variables
$$
    \begin{split}
        &sleep_t = \mbox{the sleep time at day }t \quad&\forall t \in Days\\
        &study_{it} = \mbox{the study time for subject }i\mbox{ at day }t\quad&\forall i \in S, \  t \in Days\\
    \end{split}
$$

#### (2) Variables
$$
    \begin{split}
    &\mathcal{L} = \mbox{Long-term strength}\\
    &TU = \mbox{Test utility}\\
    & L_t = \mbox{one's power at the end of day }t &\forall t \in Days\\
    &x_t = \mbox{the power waking up at day t}
    \quad& \forall t \in Days\\
    &{w_{TU_i}}=min(x_t-C_{spirit}, 0)=\mbox{the penalty we get from the test}\quad &\forall i \in S\\
    &w_{L_t}=|L_t-\overline{L}|=\mbox{the difference bewtween } L_t \mbox{ and }  \overline{L}\quad & \forall t \in Days\\
    &D_t=\mbox{power demanded for taking courses at day }t \quad &\forall t \in Days\\
    &Study_i = \mbox{the total study time for subject }i   \quad &\forall i \in S\\
    \end{split}
$$

### Objective Function
$$
\max \quad \mathcal{L} + C_{weight} \cdot TU
$$

### Constraints
$\begin{split}
    &\begin{split}
        \mathcal{L} &= \Sigma_{t=1}^{Days}{f(L_t)}\\
                    &= \Sigma_{t=1}^{Days} \overline{L}\cdot C_r- | L_t-\overline{L}|\cdot C_r\\
                    &= \Sigma_{t=1}^{Days} \overline{L}\cdot C_r- {w_L}_t \cdot C_r\\
                 TU &=  \sum_{i=0}^S\left(\dfrac{C_\alpha \cdot Study_i}{{Tired}_i\cdot Credit_i} + min(x_i-C_{spirit}, 0) \cdot \sum_{t \in Days} {C_{test}}_{it} \right) \\
                    &= \sum_{i=0}^S\left(\dfrac{C_\alpha \cdot Study_i}{{Tired}_i\cdot Credit_i} + {w_{TU_i}} \cdot \sum_{t \in Days} {C_{test}}_{it}\right)\\
     \end{split} \\
    &L_{t} = L_{t-1} + sleep_t\beta_{sleep} - D_t\beta_{demand} - \sum_{i\in S} study_{it}\beta_{study}, \quad &\forall t \in Days\\
    &L_t\geq0 \quad &\forall t \in Days\\
    &L_0 = 50\\
    &x_t= L_{t-1} + sleep_t\cdot\beta_{sleep}&\forall t \in Days \\
    &\begin{cases}
        w_{L_t} \geq L_t - \overline{L}\\
        w_{L_t} \geq \overline{L} - L_t\\
    \end{cases}&\forall t \in Days\\
    &\begin{cases}
        {w_{TU_i}} \leq x - C_{spirit}\\
        {w_{TU_i}} \leq 0\\
    \end{cases}&\forall i \in S\\
    &D_t = \sum_{i\in S} Subject_{it}\cdot(0.5+0.5\cdot \frac{Tired_i}{5}), \quad &\forall t \in Days\\
    &24 \geq sleep_t \geq 0, \quad &\forall t \in Days\\
    &24 \geq study_{it} \geq 0, \quad &\forall i \in S, t \in Days\\
    &24 = sleep_t + \sum_{i\in S} Subject_{it} + \sum_{i\in S} study_{it}, & \forall t\in Days\\
    &sleep_t\beta_{sleep} \geq D_t\beta_{demand}&\forall t \in Days\\
    &Study_i = \sum_{t = 1}^T study_{it}\cdot {C_{study}}_{it} & \forall i \in S\\
\end{split}$

## Model Meaning
在第一個模型中，我們考量的效益包括長期體力$\mathcal{L}$和考試效益$TU$。長期體力由一天耗電剩餘量補充或減少，呈現倒V圖形，效益尖峰由$\overline{L}$控制，也就是長期體力不能過高或過低。考試效益則分兩者，第一者是和科目疲累程度、學分數成反比，也就是該科越累越多學分，則需要越多讀書時間，才能達到同等考試效益；第二者為考試精神懲罰，要達到一定電量去考試才不會受懲罰。


## Solving the first model

This is the allocation plan for our first model .![](https://i.imgur.com/kEddDur.png)

| Objective | Test Utility |  L   |
| :-------: | :----------: | :--: |
|    895    |    823.4     | 71.6 |
1. Because the initial program is LP, meaning the shadown prices are all constant. That is, we can simply obtain more by increasing study time.
2. $\mathcal{L}$ drops dramatically when the ending time is comming.
    * The model treats $\mathcal{L}$ as a kind of shorterm power, which damages your health.
3. We disregarded ***the more you study, the less you get*** effect, which will be considered in the following parts.

## Refine the model

- Because the base model is too far from reality to make suggestions or give insights, we decided to add the following models and considerations. 
1. Study Related 
    * Diminishing Marginal Utility
    * Setup Cost 
    * Switching Cost
2. Activity Based
    * Garbage Time
    * Caffeine Boost
- The followings are added layer by layer to the base model, meaning the last model will be the most comprehensive one. And it doesn't sorted in above sequence, it is sorted by the importance we think. 

---



### I. Diminishing Marginal Utility
#### (1) Concept
- In reality, the fall in marginal utility as studying time increases. We need to change our linear formula into a concave function.
Change the original $\mbox{test utility}(TU):$
$$
    TU=\sum_{i=0}^S\left(\left(\dfrac{C_\alpha \cdot Study_i}{{Tired}_i\cdot Credit_i}\right) + {w_{TU_i}} \cdot \sum_{t \in Days} {C_{test}}_{it}\right)
$$
into
$$
    TU=\sum_{i=0}^S\left(\left(\dfrac{C_\alpha \cdot g(Study_i)}{{Tired}_i\cdot Credit_i}\right) + {w_{TU_i}} \cdot \sum_{t \in Days} {C_{test}}_{it}\right)
$$
* where $g(x)=C_k \cdot ln(x+1)$
* Marginal Utility of increase will be $\dfrac{\partial g}{\partial x} = \dfrac{C_k}{x+1}$
* The following graph illustrates the idea of decreasing marginal utility.
- ![](https://i.imgur.com/aY4hfhB.png =380x)

* Improving Current $f(x)$ in  $\mathcal{L}$

#### Results
![Marginal Utility](https://i.imgur.com/jPwjH3V.png)

| Objective | Test Utility |  L   |
| :-------: | :----------: | :--: |
|   192.7   |     96.2     | 96.4 |
- When Diminishing Marginal Utility is taken into consideration...
    1. We have an increased sleep time compared to the previous problems.
    2. Before exams, we don't study as much as we can. We will spend a bit more time on sleeping.
    3. Though we have a reduced Test Utility, but the summation of $\mathcal{L}$ increased comparing to the previous model.

---

### II. Garbage Time
#### (1) Conept 
* It is impossible for a normal person to keep alive when his/her life consisit of study, sleeping, and having classes and test.
* Sometimes we need to take a rest. We call it garbage time.
* Having some garbage time makes positive effect in objective function.
* The graph below illustrates the increase in objective value of having garbage time.
* The curve of function is $f(x)=\left(-x^3+20x\ \right)0.07$
$x=$  garbage time in $t, \quad$ $y=$ effect.
* ![](https://i.imgur.com/WeXhKmY.png =280x)

- However, taking garbage time also depletes the power. Hence, we need to make some change in our constraint regarding daily power.

#### (2) addition parameters

$C_{garbage}=\mbox{to balance the influence of garbage time}$

$\beta_{garbage}=\mbox{the degree that taking garbage time influences  one's power}$
#### (3) addition variable 
$garbage_t=\mbox{garbege time at day }t \quad \forall t \in Days$
#### (4) addition constraint
$garbage_t \geq 0 \quad \forall t\in Days$
#### (5) changing constraint
$L_{t} = L_{t-1} + sleep_t\beta_{sleep} - D_t\beta_{demand} - \sum_{i\in S} study_{it}\beta_{study} - \beta_{garbage} \cdot  garbage_t$

#### (6) addition term in objective function
$+\sum_{t}^{Days}f(garbage_t)$

### Result
![](https://i.imgur.com/oALJeH6.png)
| Objective | Test Utility |  L   |  G   |
| :-------: | :----------: | :--: | :--: |
|   199.4   |     91.5     | 96.7 | 11.3 |
- When we include Test Utility...
    1. Garbage time reduces study time. 
    3. Test Utility drops, but it benefits Garbage Time utility.
    4. We have a increased Objective value compared to the previous model.

---

### III. Caffeine Boost
#### (1) Concept
- Final exams and projects is upcoming, you need to stay awake... Let take some coffees!
- Coffee can boosts short-term (using day as unit) energy but need to be return (in power form) before the end, called $\mbox{coffee debt}$.

#### (2) addition parameters
$\beta_{cafe}=\mbox{utility of drinking coffee}$
$\beta_{{cafe}\_{ret}}=\mbox{the influence of coffee debt}$
#### (3) addition variable 
$\begin{split}
&cup_t=\mbox{cups of coffee taken at day } t\quad  &\forall t \in Days\\
&cafe\_ret_t= \mbox{coffee debt returned at day } t&\forall t \in Days\\
&cafe\_record_t=\mbox{Accumulated coffee debt at day }t \quad &\forall t \in Days\\
\end{split}$
#### (4) addition constraint
$\begin{split}
    &cafe\_record_t = cafe\_record_{t-1} + cup_t \cdot \beta_{cafe} - cafe\_ret_t \geq 0\quad &\forall t \in Days\\
    &cafe\_record_T=0\\
    &cup_t \in [0,2]\quad & \forall t \in Days
\end{split}$
#### (5) changing constraint
$$
L_{t} = L_{t-1} + sleep_t\beta_{sleep} - D_t\beta_{demand} - \sum_{i\in S} study_{it}\beta_{study} - \beta_{garbage} \cdot  garbage_t+cup_t\cdot \beta_{cafe} - \beta_{cafe\_ret}\cdot cafe\_ret_t
$$

### result
![](https://i.imgur.com/N3SwFLA.png)
| Objective | Test Utility |  L   |  G   |
| :-------: | :----------: | :--: | :--: |
|   205.1   |     93.7     | 100  | 11.4 |

| Day  | cups |
| :--: | :--- |
|  1   | 2.0  |
|  5   | 1.1  |
|  9   | 1.1  |
- What we observed...
    1. Because caffeine brings more power to us, we can have slightly increased Test Utility.
        * The increased power are used to study.
    2. Objective Value got greater than the previous model.
        * The increased power did bring more benefits to our life.
    3. We get to sleep more if we drink coffee. 

---

## IX. Setup cost and Switching cost
### a. Setup cost
#### (1) Concept
- Alsome everyone resists to start studying everyday. We need to take the setup cost into consideration. 
#### (2) addition parameters

$C_{setup}=\mbox{to balance the influence of setting up }$
#### (3) addition variable 
$\begin{split}
    &{w_{setup}}_t=\begin{cases}1, &\mbox{ if }{study\_count}_t >0 \\0, &\mbox{ o/w}\end{cases} \quad& \forall t\in Days\\
    &{study\_count}_t=\mbox{numbers of subject study at day }t\quad& \forall t \in Days\\
\end{split}$
#### (4) addition constraint
$\begin{split}
    &{study\_count}_t = \sum_{i\in S} {w_{setup}}_t\quad &\forall t \in Days \\
    &{study\_count}_t\leq S\cdot {w_{setup}}_t \quad &\forall t\in Days\\
    &{w_{setup}}_t \in \{0,1\} &\forall t \in Days
\end{split}$
#### (5) addtional term in objective function
$-\sum_{t\in Days} {w_{setup}}_t \cdot C_{setup}$

#### Results
![](https://i.imgur.com/q5vB8yf.png)
| Objective | Test Utility |   L   |  G   | Setup |
| :-------: | :----------: | :---: | :--: | :---: |
|   185.1   |     93.7     | 100.0 | 11.4 | 20.0  |

| Day  | cups |
| :--: | :--- |
|  5   | 1.4  |
|  9   | 1.2  |

What we find...
1. Setup cost act as a direct cost factor to the objective value.
2. It really does nothing because if we don't study, we will be penalized greater.
---
### b. Switching cost
#### (1) Concept
The concept of switching is similar with setup cost, but incurs when swithcing to study another subject.

#### (2) addition parameters

$C_{switching}=\mbox{to balance the influence of switching subject}$
#### (3) addition variable 
$\begin{split}
    &{w_{study}}_{it}=\begin{cases}1, &\mbox{if study subject }i\mbox{ at day }t\\0, &\mbox{o/w}  \end{cases}\quad &\forall i \in S, t \in Days\\
    &{study\_count}_t=\mbox{numbers of subject study at day }t\quad& \forall t \in Days\\
\end{split}$
#### (4) addition constraint
$\begin{split}
    &{study\_count}_t = \sum_{i\in S} {w_{setup}}_t\quad &\forall t \in Days \\
    &study_{it}\leq 24 \cdot {w_{study}}_{it}&\forall i \in S, \ t \in Days\\
    &{w_{study}}_{it} \in \{0,1\} &\forall i \in S, \ t \in Days
\end{split}$
#### (5) addtional term in objective function
$-\sum_{t\in Days}\left(max \{\left( {study\_count}_t-1 \right) , 0 \}  \right) \cdot C_{switching}$

#### result
![](https://i.imgur.com/DtY7rIG.png)
| Objective | Test Utility |   L   |  G   | Switching | Setup |
| :-------: | :----------: | :---: | :--: | :-------: | :---- |
|   183.2   |     91.8     | 100.0 | 11.3 |    0.0    | 20.0  |

| Day  | cups |
| :--: | :--- |
|  4   | 2    |
|  9   | 1.2  |

![](https://i.imgur.com/4Q4lGNu.png)

![](https://i.imgur.com/r0D7Ip5.png)

what we found...
1. We have a reduced Test Utility compared to the previous model.
    * Intuitively, we will not study as many subjects as we can, because there is a swithcing cost.
2. When we have switching cost on hand, we will try to study as least subjects as possible.
    * From day 2 and 4, we can see the differences.

## model file
Please see the attached file: $\mbox{final.mod}$
## data file
Please see the attached file: $\mbox{final.dat}$
## How to run with AMPL
* Change directory to where ampl and minos binary are
* Put "final.mod" and "final.dat" in this directory
* Create a file "input"
```=
option solver "./minos";
option display_round 1;
option minos_options 'Major_iterations=100000\
	Crash_option=1\
	Minor_iterations=100000\
	Superbasics_limit=100000'; 

model final.mod;
data final.dat;
solve;

display _L, _TU1, _TU2, _G, _Switching, _Setup;
if MarginalUtility = 1 then printf "Use marginal utility\n";
if GarbageTime = 1 then {
	if CafeBoost = 1 then {
		display L, sleep, _Subject, _Study, garbage, cup, cafe_record;
		display study;
	}
	else {
		display L, sleep, _Subject, _Study, garbage;
		display study;
	}
}
else {
	if CafeBoost = 1 then {
		display L, sleep, _Subject, _Study, cup, cafe_record;
		display study;
	}
	else {
		display L, sleep, _Subject, _Study;
		display study;
	}
}
```
* Run command
```=
./ampl < input
```
* Note that in data file, one can set line 4-8 options from 1 to 0 to specify which features to close. 
