# model file
param S;    # subject number
param T;    # total T days

param beta_sleep;
param beta_study;
param beta_demand;
param beta_garbage;
param beta_cafe;
param beta_cafe_ret;

param C_alpha;
param C_weight_TU;
param C_weight_G;
param C_spirit;
param L_bar;
param L0;
param C_r;
param C_study{i in 1..S, t in 1..T};
param C_test{i in 1..S, t in 1..T};
param C_switching;
param C_setup;

param Credit{i in 1..S};
param Hard{i in 1..S};
param Tired{i in 1..S};
param Subject{i in 1..S, t in 1..T};

param SwitchingCost;
param SetupCost;
param MarginalUtility;
param GarbageTime;
param CafeBoost;

var w_L{t in 1..T};
var w_TU{i in 1..S};
var study{i in 1..S, t in 1..T};
var sleep{t in 1..T};
var L{t in 0..T};
var x{i in 1..S};
var D{i in 1..T};
var garbage{t in 1..T};
var cup{t in 1..T};
var cafe_ret{t in 1..T};
var cafe_record{t in 0..T};


var whether_study{i in 1..S, t in 1..T};
var study_subject_cnt{t in 1..T}; 				# study subject count[t] = sum{i in 1..S} whether_study[i ,t]
var whether_setup{t in 1..T};				  
var w_switching{t in 1..T}; 					# w_switching = max(study_subject_cnt - 1, 0)


var _L;
var _TU;
var _TU1;
var _TU2;
var _G;
var _Study{t in 1..T};
var _Subject{t in 1..T};
var _Switching;
var _Setup;

maximize obj_func:
    _L + _TU + _G - _Switching - _Setup;

subject to cns_show_L:
	_L = sum{t in 1..T} (L_bar * C_r - w_L[t] * C_r);

subject to cns_show_TU:
	_TU = _TU1 + _TU2;

subject to cns_show_TU1:
	_TU1 = (1-MarginalUtility) * C_weight_TU * sum{i in 1..S} (C_alpha * (sum{t in 1..T} study[i, t] * C_study[i, t]/(Tired[i] * Credit[i])))
	+ (MarginalUtility) * C_weight_TU * sum{i in 1..S} (C_alpha * log((sum{t in 1..T} study[i, t] * C_study[i, t]) + 1)/(Tired[i] * Credit[i]));

subject to cns_show_garbage:
	_G = GarbageTime * C_weight_G * sum{t in 1..T} (-garbage[t]^3 + 20*garbage[t])*0.07;

subject to cns_show_TU2:
	_TU2 = C_weight_TU * sum{i in 1..S} (w_TU[i] * sum{t in 1..T} C_test[i, t]);

subject to cns_show_study_one_day{t in 1..T}:
	_Study[t] = sum{i in 1..S} study[i, t];

subject to cns_show_subject_one_dat{t in 1..T}:
	_Subject[t] = sum{i in 1..S} Subject[i, t];

subject to nonneg_L{t in 0..T}:
    L[t] >= 0;

subject to cns_sleep_balance{t in 1..T}:
    L[t] = L[t-1] + sleep[t] * beta_sleep - D[t] * beta_demand - (sum{i in 1..S} study[i, t]) * beta_study - beta_garbage * garbage[t] + CafeBoost * (cup[t] * beta_cafe - beta_cafe_ret * cafe_ret[t]);
    
subject to cns_L_0_value:
    L[0] = L0;
    
subject to cns_w_L_1{t in 1..T}:
    w_L[t] >= L[t] - L_bar;
    
subject to cns_w_L_2{t in 1..T}:
    w_L[t] >= L_bar - L[t];
    
subject to cns_test_spirit{i in 1..S}:
    x[i] = sum{t in 1..T} C_test[i, t] * (L[t-1] + sleep[t] * beta_sleep);
    
subject to cns_w_TU_1{i in 1..S}:
    w_TU[i] <= x[i] - C_spirit;
    
subject to cns_w_TU_2{i in 1..S}:
    w_TU[i] <= 0;
    
subject to cns_demand{t in 1..T}:
    D[t] = sum{i in 1..S} Subject[i, t] * (0.5+0.5*(Tired[i]/5));
    
subject to cns_sleep{t in 1..T}:
    24 >= sleep[t] >= 0;

subject to cns_sleep2{t in 1..T}:
    sleep[t] >= D[t];

subject to cns_study{i in 1..S, t in 1..T}:
    24 >= study[i, t] >= 0;

subject to cns_garbage_1{t in 1..T}:
	24 >= garbage[t] >= 0;

subject to cns_garbage_2{t in 1..T}:
	garbage[t] = GarbageTime * garbage[t];

subject to cns_cup{t in 1..T}:
	2 >= cup[t] >= 0;

subject to cns_cafe_ret{t in 1..T}:
	cafe_ret[t] >= 0;

subject to cns_cafe_record_0:
	cafe_record[0] = 0;

subject to cns_cafe_record_t{t in 1..T-1}:
	cafe_record[t] >= 0;

subject to cns_cafe_record_T:
	cafe_record[T] = 0;

subject to cns_cafe_balance{t in 1..T}:
	cafe_record[t] = 1.1*(cafe_record[t-1] + cup[t] * beta_cafe - cafe_ret[t]);

subject to cns_24_hours{t in 1..T}:
    24 = sleep[t] + sum{i in 1..S} Subject[i, t] + sum{i in 1..S} study[i, t] + garbage[t];

subject to cns_sleep_geq_demand{t in 1..T}:
	sleep[t] * beta_sleep >= D[t] * beta_demand;

subject to cns_sleep_ub{t in 1..T}:
	sleep[t] <= 12;

subject to cns_study_cnt{t in 1..T}:
	study_subject_cnt[t] = (sum{i in 1..S} whether_study[i, t]);

subject to cns_w_switch_1{t in 1..T}:
 	w_switching[t] >= 0;
	
subject to cns_w_switch_2{t in 1..T}:
 	w_switching[t] >= (study_subject_cnt[t] - 1);
	
subject to cns_show_switching:
	_Switching = SwitchingCost * sum{t in 1..T}w_switching[t] * C_switching;

subject to cns_show_setup:
	_Setup = SetupCost * sum{t in 1..T}(whether_setup[t]) * C_setup;
	
subject to cns_switch{i in 1..S, t in 1..T}:
	whether_study[i, t] = study[i, t] / (study[i, t] + 0.0001);

subject to cns_setup{t in 1..T}:
	whether_setup[t] = study_subject_cnt[t] / (study_subject_cnt[t] + 0.0001);

