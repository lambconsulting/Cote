/*libname et "C:\Lamb Consulting";*/


/*libname et "U:\Consulting\KEL\Fox\Weisse\cote\input" ;*/
/*data et.ET_DATA_REVIEW_20200727; set ET_DATA_REVIEW_20200727; run;*/

libname et "U:\Consulting\KEL\Fox\Weisse\Coate\input" access=readonly;


/* Pivoting output off of Excel from etienne_results_20200103.xlsx - 20200727 KL */


/*%let main =U:\Consulting\KEL\Fox\Weisse\Coate;*/
/*%include "&main.\ROC_Optimal_Cutoff_031816.sas";*/
/*libname et "&main.";*/

/**/
/*data et.et_data;*/
/*	set work.'AMC CT bronch project data sheet'n;*/
/*	drop name 'ct date'n;*/
/*	thor_w_cw = thor_ht_cw_0001;*/
/*run;		*/

/* Updated data per Etienne 20190113 KL */
/*data et_data;*/
/*	set et.et_data (rename= (L_br_ht_y_n_cw=L_br_ht_max_cw L_br_ht_max_cw=L_br_ht_y_n_cw));*/
/*run;	*/
/*data et.et_data_pre20190113; set et.et_data; run;*/

/*proc means data=et_data median;*/
/*	var bw;*/
/*run;*/

/* median bodyweight (bw) = 10.4 */

/*data et.et_data_03302019;*/
/*set WORK.etienne03302019;*/
/*run;*/

data et_data (drop=pectus_cw_tmp); set et.ET_DATA_REVIEW_20200727 (rename=pectus_cw = pectus_cw_tmp);

/*data et_data; set et.et_data_20191230;*/
/*data et_data; set et.et_data_03302019; */
/*data et_data; set et.et_data_11192019; */

/* no longer used as of 20200728 removing */
/*loc_l_br_max_ec_temp = input(loc_l_br_max_ec, 8.);*/
/*loc_l_br_max_cw_temp = input(loc_l_br_max_cw, 8.);*/
/*drop loc_l_br_max_cw loc_l_br_max_ec;*/



/*loc_l_br_max_cw - None present*/
/*loc_l_br_max_ec*/

/*bcs = bcs_col;*/

pectus_cw = input(pectus_cw_tmp,5.0);

/* These are not all handled as of 20200728 so allowing this syntax */
if l_br_ht_max_cw = . then l_br_ht_max_cw = 0;
if loc_l_br_max_ec = . then loc_l_br_max_ec= 0;
if loc_r_br_max_ec = . then loc_r_br_max_ec = 0;

if deep_barrel = 1 and BCS >= 6 and BW >= 10.4 then deep_bcs_bw = 1;
else deep_bcs_bw = 0;

/*echo_dx = 'Echo Dx'n;*/

/*drop f65 Comments_CW Comments_EC 'Echo Dx'n;*/
/*rename Thor_ht_CW_0001 = thor_w_cw;*/

run;

data et_data_EC;
	set et_data; 
	drop thor_ht_cw--pectus_cw; 
	reviewer = "EC";
	rename  Ao_ht_ec = ao_ht
			Thor_ht_ec = thor_ht
			Thor_w_ec = thor_w
			Thor_H_W_ec = thor_h_w
			Spond_ec = spond
			Ao_ht_ec = ao_ht
			Ao_w_ec	= ao_w
			L_br_h_ec = l_br_h
			L_br_w_ec = l_br_w
			L_br_H_W_ec = l_br_h_w
			Ao_L_br_ec = ao_l_br
			L_br_ht_max_ec = l_br_ht_max
			L_br_ht_y_n_ec = l_br_ht_y_n
			Ao_vertebr_ec = ao_vertebr
			R_br_h_ec = r_br_h
			R_br_w_ec = r_br_w
			R_br_H_W_ec = r_br_h_w
			R_br_ht_max_ec = r_br_ht_max
			R_br_ht_y_n_ec= r_br_ht_y_n
			Pectus_ec = pectus;
run;

data et_data_CW;
	set et_data; 
	drop thor_ht_ec--pectus_ec; 
	reviewer = "CW";
	rename  Ao_ht_cw = ao_ht
			Thor_ht_cw = thor_ht
			Thor_w_cw = thor_w
			Thor_H_W_cw = thor_h_w
			Spond_cw = spond
			Ao_ht_cw = ao_ht
			Ao_w_cw	= ao_w
			L_br_h_cw = l_br_h
			L_br_w_cw = l_br_w
			L_br_H_W_cw = l_br_h_w
			Ao_L_br_cw = ao_l_br
			L_br_ht_max_cw = l_br_ht_max
			L_br_ht_y_n_cw = l_br_ht_y_n
			Ao_vertebr_cw = ao_vertebr
			R_br_h_cw = r_br_h
			R_br_w_cw = r_br_w
			R_br_H_W_cw = r_br_h_w
			R_br_ht_max_cw = r_br_ht_max
			R_br_ht_y_n_cw= r_br_ht_y_n
			pectus_cw = Pectus;
/*	format Pectus 8.;*/
/*	Pectus = pectus_cw;*/
/*	drop pectus_cw;*/
run;

data et_data_stacked;
	set et_data_CW et_data_ec;
	la_ao_le_1p5 = la_ao <= 1.5;
	ao_l_br_gt_0 = ao_l_br > 0;
	if l_br_ht_y_n = 1 then do;
		l_br_diff = l_br_ht_max - l_br_h;
	end;
	if r_br_ht_y_n = 1 then do;
		r_br_diff = r_br_ht_max - r_br_h;
	end;
	if ao_l_br>0 and ao_vertebr=0 then ao_l_br_gt_0_vertebr_0 = 1;
	else ao_l_br_gt_0_vertebr_0 = 0;
	r_br_h_w_ge_0p9792 = r_br_h_w >= 0.9792;
	r_br_h_w_ge_1 = r_br_h_w >= 1;
	l_br_h_w_ge_0p6887 = l_br_h_w >= 0.6887;
	l_br_h_w_ge_1 = l_br_h_w >= 1;

	if l_br_ht_y_n = 1 and ao_l_br < 0.1 and ao_vertebr = 0 then l_ao_verte0_com = 1;
	else l_ao_verte0_com = 0;
	
	if l_br_ht_y_n = 1 and ao_l_br < 0.1 and ao_vertebr = 1 then l_ao_verte1_com = 1;
	else l_ao_verte1_com = 0;

	if ao_l_br = 0 and ao_vertebr = 0 and l_br_ht_y_n = 1 then l_ao_verte_com = 1;
	else l_ao_verte_com = 0;

run;



data et_data_cw et_data_ec;
	set et_data_stacked;
	if reviewer="CW" then output et_data_cw;
	else output et_data_ec;
run;



/*proc contents data=et_data_stacked;*/
/*run;*/

/*proc contents data=et_data;*/
/*run;*/
/**/
/*data et_data1;*/
/*	set et_data;*/
/*	keep mrn Ao_L_br_CW Ao_L_br_EC Ao_vertebr_CW Ao_vertebr_EC;*/
/*run;*/

/* Data Deep Dive N */
/*data test; set et_data (keep=Thor_H_W: ao_l_br:); run;*/
/*proc reg; model Thor_H_W_cw = Ao_L_br_cw; run;*/
/*proc reg; model Thor_H_W_ec = Ao_L_br_ec; run;*/

/* LA_AO has been added/moved from categorical to continuous - I suspect BCS will end up as a cetagorical after collapsing but will leave as continuous for now... */
/**/
/*%let cont_describe = age bw la_ao bcs thor_ht_ec thor_w_ec thor_h_w_ec Ao_ht_EC Ao_w_EC */
/*						L_br_h_EC L_br_w_EC L_br_H_W_EC Ao_L_br_EC L_br_ht_max_EC*/
/*						R_br_h_EC R_br_w_EC R_br_H_W_EC R_br_ht_max_EC */
/*Thor_ht_CW	Thor_w_CW	Thor_H_W_CW Ao_ht_CW	Ao_w_CW	L_br_h_CW	L_br_w_CW	L_br_H_W_CW	Ao_L_br_CW R_br_h_CW	R_br_w_CW	*/
/*R_br_H_W_CW	R_br_ht_max_CW L_br_ht_max_cw						*/
/*;*/
/**/
/*%let cat_describe = gender breed deep_barrel indication_dx resp echo_dx  spond_ec*/
/*	L_br_ht_y_n_EC Loc_L_br_max_EC Ao_vertebr_EC R_br_ht_y_n_EC Loc_R_br_max_EC Pectus_EC*/
/*	spond_cw Ao_vertebr_cw R_br_ht_y_n_cw Pectus_cw*/
/*						L_br_ht_y_n_cw */
/*						Brachy_brd Coll_tr_brd Brd_size Mitral bcs_col*/
/*;*/


/* Noting extra rater datasets produced off of stacked */
/*%let cont_describe = Age BCS BW ao_ht ao_l_br ao_w l_br_h l_br_h_w l_br_w la_ao r_br_h r_br_h_w r_br_w thor_h_w*/
/*thor_ht thor_w l_br_ht_max r_br_ht_max ;*/
/*%let cont_describe_stk = &cont_describe. l_br_diff r_br_diff */
/* Removing due to inconsistency in variable presence for CW Loc_L_br_max_EC Loc_R_br_max_EC; */

%let cont_describe = Age BCS BW ao_ht ao_l_br ao_w l_br_h l_br_h_w l_br_w la_ao r_br_h r_br_h_w r_br_w thor_h_w
thor_ht thor_w l_br_ht_max r_br_ht_max l_br_diff r_br_diff;



/* Noting extra rater datasets produced off of stacked */
/*%let cat_describe = Brachy_brd Brd_size Breed Coll_tr_brd Deep_barrel echo_dx Gender Mitral Pectus ao_vertebr*/
/*bcs_col deep_bcs_bw indication_dx l_br_ht_y_n r_br_ht_y_n resp spond ;*/
/*%let cat_describe_stk = &cat_describe. la_ao_le_1p5 ao_l_br_gt_0 ao_l_br_gt_0_vertebr_0 r_br_h_w_ge_0p9792*/
/*r_br_h_w_ge_1 l_br_h_w_ge_0p6887 l_br_h_w_ge_1;*/
/*%put &cat_describe. &cat_describe_stk.;*/

%let cat_describe = Brachy_brd Brd_size Breed Coll_tr_brd Deep_barrel echo_dx Gender Mitral Pectus ao_vertebr
bcs_col deep_bcs_bw indication_dx l_br_ht_y_n r_br_ht_y_n resp spond la_ao_le_1p5 ao_l_br_gt_0 ao_l_br_gt_0_vertebr_0 r_br_h_w_ge_0p9792
r_br_h_w_ge_1 l_br_h_w_ge_0p6887 l_br_h_w_ge_1 l_ao_verte0_com l_ao_verte1_com l_ao_verte_com;




/* Combine the following datasets:

Combine DV
bw
thor_h_w_cw
Thor_h_w_ec
l_br_h_ec
l_br_h_cw
r_br_h_ec
r_br_h_ce
l_br_h_w_cw
l_br_h_w_ec
r_br_h_w_cw
r_br_h_w_ec

Combine IV
ao_l_br_cw
ao_l_br_ec
la_ao
l_br_ht_max_cw
l_br_ht_max_ec

r_br_ht_max_cw
r_br_ht_max_ec
Ao_ht_cw
Ao_ht_ec

*/

/*data keepme; set et_data (keep=id mrn*/
/*bw*/
/*thor_h_w_cw thor_h_w_ec l_br_h_cw l_br_h_ec  r_br_h_cw r_br_h_ec l_br_h_w_cw l_br_h_w_ec r_br_h_w_cw r_br_h_w_ec*/
/*la_ao */
/*ao_l_br_cw ao_l_br_ec  l_br_ht_max_cw l_br_ht_max_ec r_br_ht_max_cw r_br_ht_max_ec ao_ht_cw ao_ht_ec*/
/*);*/
/*run;*/

/*data keep_cw (rename=(*/
/*thor_h_w_cw =thor_h_w l_br_h_cw =l_br_h r_br_h_cw = r_br_h l_br_h_w_cw = l_br_h_w r_br_h_w_cw = r_br_h_w ao_l_br_cw = ao_l_br */
/*l_br_ht_max_cw = l_br_ht_max r_br_ht_max_cw = r_br_ht_max ao_ht_cw = ao_ht));;*/
/*set keepme (keep=bw la_ao thor_h_w_cw l_br_h_cw r_br_h_cw l_br_h_w_cw r_br_h_w_cw ao_l_br_cw l_br_ht_max_cw r_br_ht_max_cw ao_ht_cw);*/
/*PI = "CW"; rep=1;*/
/*run;*/
/*data keep_ec (rename=(*/
/*thor_h_w_ec =thor_h_w l_br_h_ec = l_br_h r_br_h_ec =r_br_h l_br_h_w_ec = l_br_h_w r_br_h_w_ec = r_br_h_w ao_l_br_ec = ao_l_br */
/*l_br_ht_max_ec = l_br_ht_max r_br_ht_max_ec = r_br_ht_max ao_ht_ec = ao_ht));*/
/*;*/
/*set keepme (keep=bw la_ao thor_h_w_ec l_br_h_ec r_br_h_ec l_br_h_w_ec r_br_h_w_ec ao_l_br_ec l_br_ht_max_ec r_br_ht_max_ec ao_ht_ec);*/
/*PI = "EC"; rep=2;*/
/*run;*/

/*data stack_cw_ec; set keep_cw keep_ec; run;*/


/* Get Continuous Descriptive */


%macro means_desc(ds,var_list);
	%let vars = &var_list.;
	%let word_cnt=%sysfunc(countw(&vars));

	%do i = 1 %to &word_cnt.;

		proc means data =  &ds. noprint;
			var %scan(&vars.,&i);
			output out= nmiss nmiss(%scan(&vars.,&i))=;
			output out= mean mean(%scan(&vars.,&i))=;
			output out= median median(%scan(&vars.,&i))=;
			output out= std std(%scan(&vars.,&i))=;
			output out= min min(%scan(&vars.,&i))=;
			output out= max max(%scan(&vars.,&i))=;
			output out= p25 p25(%scan(&vars.,&i))=;
			output out= p75 p75(%scan(&vars.,&i))=;
		run;

		data mean (rename = (%scan(&vars.,&i) = mean _freq_ = n));
			set mean (drop =  _type_);

		data nmiss (rename = %scan(&vars.,&i) = nmiss);
			set nmiss (keep = %scan(&vars.,&i));

		data median (rename = %scan(&vars.,&i) = median);
			set median (keep = %scan(&vars.,&i));

		data std (rename = %scan(&vars.,&i) = std);
			set std (keep = %scan(&vars.,&i));

		data min (rename = %scan(&vars.,&i) = min);
			set min (keep = %scan(&vars.,&i));

		data max (rename = %scan(&vars.,&i) = max);
			set max (keep = %scan(&vars.,&i));

		data p75 (rename = %scan(&vars.,&i) = p75);
			set p75 (keep = %scan(&vars.,&i));

		data p25 (rename = %scan(&vars.,&i) = p25);
			set p25 (keep = %scan(&vars.,&i));

		data all_mean_%scan(&vars.,&i);
			length src ds $30.;
			merge nmiss mean median std min max p25 p75;
			ds = "%scan(&vars.,&i)";
			src = "&ds.";
		run;

		data all_mean;
			set all_mean all_mean_%scan(&vars.,&i);
		run;

	%end;
%mend;

data all_mean;
	set _null_;
run;

%means_desc(et_data_cw,&cont_describe.);
%means_desc(et_data_ec,&cont_describe.);
%means_desc(et_data_stacked,&cont_describe.);

/* Print desriptive statistics for means/IQR and paste into means_desc tab in Excel */
proc print data=all_mean noobs; run;



/* Get Categorical Descriptive */

%macro freqs1(ds);
	%let vars = &cat_describe;
	%let word_cnt=%sysfunc(countw(&vars));

	%do i = 1 %to &word_cnt.;

		proc freq data =  &ds.;
			tables %scan(&vars.,&i) / chisq;
			ods output onewayfreqs = owf OneWayChiSq= owc;
		run;

		data freq (rename = f_%scan(&vars.,&i) = var_mid);
			length table $50.;
			set owf (drop = %scan(&vars.,&i));
		run;

		data chi (drop = name1 label1 cvalue1);
		    length table $50.;
			set owc;
			where name1 = "P_PCHI";
		run;

		data freq_%scan(&vars.,&i);
			length src table var_level  $50.; *cValue1;
			merge freq chi;
			by table;
			p_value = nvalue1;
			var_level = left(var_mid);
			src = "&ds.";
			run;


		data freq_tot (drop= var_mid nvalue1  ); *cvalue1;
			set freq_tot freq_%scan(&vars.,&i);
		run;

	%end;
%mend;

data freq_tot; 	set _null_; run;

%freqs1(et_data_cw);
%freqs1(et_data_ec);
%freqs1(et_data_stacked);

/* Print desriptive statistics for frequencies/categorical and paste into cat tab in Excel */
proc print data=freq_tot noobs; run;



	


/* Customized frequencies by research question */

%macro freq_cust(analysis,r_q_n,research,iv1,iv2);

	proc freq data =  &analysis.;
		tables &iv1.*&iv2. / chisq agree;
		ods output CrossTabFreqs = freqs ChiSq= chi FishersExact = fish kappa=k;
	run;

		%if %sysfunc(exist(k)) %then
		%do;

data k; set k (keep= name1 nvalue1); 
where name1 = "_KAPPA_"; 
		retain r_q_n analysis research_q;
		length r_q_n research_q iv1 iv2 $50.;
		analysis = "&analysis.";
		research_q = "&research.";
		r_q_n = "&r_q_n.";
		iv1 = "&iv1";
		iv2 = "&iv2.";
run;
	data kappa_all; set kappa_all k; run;

		%end;

	data freqs_in;
		set freqs (drop =  _table_ rowpercent colpercent);
		where _type_ in ("11" "00");
		drop _type_;
	run;

	data ctf_&research. (drop =  &iv1. &iv2.);
		retain r_q_n analysis research_q;
		length r_q_n research_q $50.;
		set freqs_in;
		analysis = "&analysis.";
		research_q = "&research.";
		r_q_n = "&r_q_n.";
		iv1 = put(&iv1.,5.0);
		iv2 = put(&iv2.,5.0);
	run;

	data ctf_all;
		set ctf_all ctf_&research.;
	run;

	%if %sysfunc(exist(fish)) %then
		%do;

			data f_&research. (rename=nvalue1=P_FISH);
				set fish (keep =  table name1 nvalue1);
				where name1 in ("P_TABLE");
				drop name1;
			run;

			data f_p;
				set f_p f_&research.;
			run;

		%end;

	%if %sysfunc(exist(chi)) %then
		%do; 
			%if (&iv1. = bcs_col OR &iv1. = Sex OR &iv1. = Hx_pneum OR &iv1. = Skel) OR (&iv2. = bcs_col) %then %do;
				data chi_&research. (rename=prob=P_CHI);
					set chi (keep = table statistic prob);
					where statistic in ("Mantel-Haenszel Chi-Square");
					Research_Question = "&research";
				run;

				data chi_p;
					set chi_p chi_&research.;
				run;
			%end;
			%else %do;
				data chi_&research. (rename=prob=P_CHI);
					set chi (keep =  table statistic prob);
					where statistic in ("Chi-Square");
					length research_question $10;
					Research_Question = "&research";
				run;

				data chi_p;
					set chi_p chi_&research.;
				run;

			%end;

		%end;

	proc datasets library=work nolist nodetails;
		delete chi fish k freq p_&research. chi_&research.;
	run;

%mend;

data ctf_all; 	set _null_; 
data f_p; 	set _null_;
data chi_p;	set _null_;
data kappa_all;	set _null_;
run;

%freq_cust(et_data,5D,5D,spond_ec,spond_cw);
%freq_cust(et_data,5L,5L,l_br_ht_y_n_ec,l_br_ht_y_n_cw);
%freq_cust(et_data,5N,5N,ao_vertebr_ec,ao_vertebr_cw); * This should be a Chi Square ;
%freq_cust(et_data,5S,5S,r_br_ht_y_n_ec,r_br_ht_y_n_cw);
%freq_cust(et_data,5U,5U,pectus_ec,pectus_cw);
%freq_cust(et_data,6DA,6DA,Ao_vertebr_EC,Ao_vertebr_CW); * Add on for 6DA;

%freq_cust(et_data,K,K,deep_barrel,bcs_col); * Round 2 listed as multivariate 201901019;

%freq_cust(et_data,8eb,8eb,ao_vertebr_ec,l_br_ht_y_n_ec);
%freq_cust(et_data,8ed,8ed,deep_barrel,l_br_ht_y_n_ec);
%freq_cust(et_data,8fb,8fb,ao_vertebr_ec,l_br_ht_y_n_ec);
%freq_cust(et_data,8fd,8fd,deep_barrel,l_br_ht_y_n_cw);
%freq_cust(et_data,8gb,8gb,deep_barrel,ao_vertebr_ec);
%freq_cust(et_data,8gd,8gd,l_br_ht_y_n_ec,ao_vertebr_ec);
%freq_cust(et_data,8hb,8hb,deep_barrel,ao_vertebr_cw);
%freq_cust(et_data,8hd,8hd,l_br_ht_y_n_cw,ao_vertebr_cw);








/* Print Frequencies, Fisher, and Chi-Square statistics - Added manual Kappa analysis given low number of analyses, intent, and 1/0 nature of data for agreement */
proc print data=ctf_all; run;
proc print data=f_p; run;
proc print data=chi_p; run;
proc print data=kappa_all; run;



***** ANOVA Analysis;
%macro aov(mod_ty,mod,research_q,dv,iv);
	/*ods output lsmeans tests3 diffs;*/
	proc mixed data=et_data;
		class &iv.;
		model &dv. = &iv. /* / solution */;
		lsmeans &iv.  / pdiff=all;
		ods output lsmeans=lsmeans_x (drop = df tvalue probt) 
			diffs = diffs_x (keep = estimate probt &iv. _&iv.);
	run;

	data diffs_&dv. (rename = (estimate = Compr_mean));
		set diffs_x;
		mergeme = 1;
		var = left(trim(put(&iv,5.0)));
		var2 = left(trim(put(_&iv,5.0)));
	run;

	data lsmeans_&dv. (rename = (estimate = lsmean effect = iv));
		length dv research_q $50.;
		set lsmeans_x;
		mod_number = "&mod.";
		dv = "&dv.";
		mod_type = "&mod_ty.";
		research_q = "&research_q.";
		lsmean_level = left(trim(put(&iv,5.0)));
		mergeme = 1;
	run;

	data merge_&mod. (drop=mergeme);
		length iv $50.;
		merge diffs_&dv. (drop =  &iv _&iv.) 
			lsmeans_&dv. (drop =  &iv);
		by mergeme;
	run;

	data allaov;
		retain dv mod_type mod_number research_q iv lsmean_level lsmean stderr;
		set allaov merge_&mod.;
	run;


/* Check normality for NPAR1WAY or Proc Mixed Interpretation */

	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;
	%let ds = et_data;
	%let var = &dv.;
	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q iv var $50.;
		set &var.pe;
		var = "&var.";
		iv = "&iv.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
	length iv var $30.;
		set &var.norm;
		var = "&var.";
		iv = "&iv.";
	run;

	data norm;
		set norm &var.norm;
	run;

		* Non Parametric;
	proc npar1way data = xxx median wilcoxon;
		class &iv.;
		var &var.;
		ods output MedianAnalysis = mt /*WilcoxonScores=wt*/
		KruskalWallisTest=kw;
	run;

	data &var.mt (drop=name1 label1 cvalue1 variable nvalue1);
		set mt;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_CHMED");
		analysis = "median";
		p_value = nvalue1;
	run;

	data &var.kw (drop=name1 label1 cvalue1 variable nvalue1);
		set kw;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_KW");
		analysis = "kruskw";
		p_value = nvalue1;
	run;

	data npar;
		set npar &var.mt &var.kw;
	run;

%mend;

data allaov; set _null_;
data lsmeans_x; set _null_;
data diffs_x; set _null_;
data norm; set _null_;
data pe; set _null_;
data npar; set _null_;
run;

/* Omitting ODS 2k due to permission issue and will export PDF instead for memorial */
/*ods msoffice2k file="c:\junk\norm_coate_20181227.xls";*/

/* The only meaningful analysis with Gender and Deep Barrel at this point.  All are normally distributed except r_br_ht_max_cw which has a data error
noted below - 20181227- KL */


%aov(aov,1AB,1AB,Thor_H_W_EC,Gender);
%aov(aov,1AC,1AC,Thor_H_W_EC,Breed); * Too many breeds to be meaningful but ran anyway with solution option turned off;
%aov(aov,1AD,1AD,Thor_H_W_EC,Deep_barrel);
%aov(aov,1AG,1AG,Thor_H_W_EC,Indication_Dx); * Too many classes to be meaningful but ran anyway with solution option turned off;
%aov(aov,1AH,1AH,Thor_H_W_EC,resp); * Too many classes to be meaningful but ran anyway with solution option turned off;
%aov(aov,1AI,1AI,Thor_H_W_EC,echo_dx); * Too many classesto be meaningful but ran anyway with solution option turned off ;
%aov(aov,1BB,1BB,Thor_H_W_CW,Gender);
%aov(aov,1BC,1BC,Thor_H_W_CW,Breed); * Too many breeds to be meaningful ;
%aov(aov,1BD,1BD,Thor_H_W_CW,Deep_barrel);
%aov(aov,1BG,1BG,Thor_H_W_CW,Indication_Dx);
%aov(aov,1BH,1BH,Thor_H_W_CW,resp);
%aov(aov,1BI,1BI,Thor_H_W_CW,echo_dx);
%aov(aov,2DA,2DA,Thor_H_W_EC,l_br_ht_y_n_ec);
%aov(aov,2DB,2DB,Thor_H_W_CW,l_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now;
%aov(aov,2EA,2EA,Thor_H_W_EC,ao_vertebr_ec);
%aov(aov,2EB,2EB,Thor_H_W_CW,ao_vertebr_cw);
%aov(aov,2HA,2HA,Thor_H_W_EC,r_br_ht_y_n_ec);
%aov(aov,2HB,2HB,Thor_H_W_CW,r_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now;
%aov(aov,2IA,2IA,Thor_H_W_EC,pectus_ec);
%aov(aov,2IB,2IB,Thor_H_W_CW,pectus_cw);
%aov(aov,3AD,3AD,BW,l_br_ht_y_n_ec);
%aov(aov,3AH,3AH,BW,r_br_ht_y_n_ec);
%aov(aov,3AI,3AI,BW,pectus_ec);
%aov(aov,3BD,3BD,BW,l_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now ;
%aov(aov,3BH,3BH,BW,r_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now ;
%aov(aov,3BI,3BI,BW,pectus_cw);
%aov(aov,4AD,4AD,BCS,l_br_ht_y_n_ec);
%aov(aov,4AH,4AH,BCS,r_br_ht_y_n_ec);
%aov(aov,4AI,4AI,BCS,pectus_ec);
%aov(aov,4BD,4BD,BCS,l_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now;
%aov(aov,4BH,4BH,BCS,r_br_ht_y_n_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now;
%aov(aov,4BI,4BI,BCS,pectus_cw);

%aov(aov,8ea,8ea,ao_l_br_ec,l_br_ht_y_n_ec);
%aov(aov,8ec,8ec,thor_h_w_ec,l_br_ht_y_n_ec);
%aov(aov,8fa,8fa,ao_l_br_cw,l_br_ht_y_n_cw);
%aov(aov,8fc,8fc,thor_h_w_cw,l_br_ht_y_n_cw);
%aov(aov,8ga,8ga,ao_l_br_ec,ao_vertebr_ec);
%aov(aov,8gc,8gc,thor_h_w_ec,ao_vertebr_ec);
%aov(aov,8ha,8ha,ao_l_br_cw,ao_vertebr_cw);
%aov(aov,8hc,8hc,thor_h_w_cw,ao_vertebr_cw);
%aov(aov,8ka,8ka,l_br_h_w_ec,deep_bcs_bw);
%aov(aov,8kb,8kb,l_br_h_w_cw,deep_bcs_bw);



/*%aov(aov,100,100,bcs_col,l_br_ht_y_n_ec);*/
/*%aov(aov,101,101,bcs_col,r_br_ht_y_n_ec);*/
/*%aov(aov,102,102,bcs_col,pectus_ec);*/
/*%aov(aov,103,103,bcs_col,l_br_ht_y_n_cw); */
/*%aov(aov,104,104,bcs_col,r_br_ht_y_n_cw); */
/*%aov(aov,105,105,bcs_col,pectus_cw);*/


/*ods msoffice2k close;*/


proc print data=allaov; run; * Do no print these 53K+ records, export, then collapse classes to fix this issue ;
/* Gives formal normality statistics for quick review */
proc print data=norm; run;
/* Gives non-parametric statistics in the event that formal normalty and visual inspection do not yield parametric (ANOVA/REG) interpretation */
proc print data=npar; run;



/* Get regression analyses from proc reg simple linear and normality in one fall swoop */

/* Regression on et_data for single observations and rater - non-stacked at this point no need to block 20200727 KL */

%macro reg (var, iv, ds, research_q);
	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;

	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q $50.;
		set &var.pe;
		var = "&var.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
		set &var.norm;
		var = "&var.";
	run;

	data norm;
		set norm &var.norm;
	run;

%mend;

* show regression and save rstudent, lev, cookd, dffits;
data pe;	set _null_;
data norm;	set _null_;
run;

/* BCS looks janky and everything with this right max variable (r_br_ht_max_ec and r_br_ht_max_cw) is off and 0 ... */

%reg(L_br_h_w_cw,ao_l_br_cw,et_data,3aa);
%reg(L_br_h_w_cw,ao_l_br_ec,et_data,3ab);
%reg(L_br_h_w_ec,ao_l_br_cw,et_data,3ba);
%reg(L_br_h_w_ec,ao_l_br_ec,et_data,3bb);
%reg(L_br_h_w_cw,la_ao,et_data,6AA);
%reg(L_br_h_w_ec,la_ao,et_data,6AB);
%reg(BCS,ao_l_br_cw,et_data,4BB);
%reg(BCS,ao_l_br_ec,et_data,4AB);

/*%aov(aov,5K,5K,l_br_ht_max_ec,l_br_ht_max_cw); * l_br_ht_max_ec is in fractions l_br_ht_max_cw is 1/0 - need to address this consistency as above;*/
/*%reg(loc_l_br_max_ec,loc_l_br_max_cw,et_data,5M);  ***** loc_l_br_max_cw STILL doesn't exist... 20190120;*/
/*%aov(aov,5R,5R,r_br_ht_max_ec,r_br_ht_max_cw); * Error in data for r_br_ht_y_n_cw - need 1/0 will leave here as ANOVA for now - Might be Chi-Square does not pass normality;*/
/*%reg(loc_r_br_max_ec,loc_r_br_max_cw,et_data,5T); * loc_r_br_max_cw does not exist *;*/

%reg(BCS,L_br_h_w_cw,et_data,4BA);
%reg(BCS,L_br_h_w_ec,et_data,4AA);
%reg(BCS,l_br_ht_max_cw,et_data,4BC);
%reg(BCS,l_br_ht_max_ec,et_data,4AC);
%reg(BCS,r_br_h_w_cw,et_data,4BF);
%reg(BCS,r_br_h_w_ec,et_data,4AF);
%reg(BCS,r_br_ht_max_cw,et_data,4BG);
%reg(BCS,r_br_ht_max_ec,et_data,4AG);
%reg(BW,ao_l_br_cw,et_data,3BB);
%reg(BW,ao_l_br_ec,et_data,3AB);

%reg(BW,L_br_h_w_cw,et_data,3BA);
%reg(BW,L_br_h_w_ec,et_data,3AA);
%reg(BW,l_br_ht_max_cw,et_data,3BC);
%reg(BW,l_br_ht_max_ec,et_data,3AC);
%reg(BW,r_br_h_w_cw,et_data,3BF);
%reg(BW,r_br_h_w_ec,et_data,3AF);
%reg(BW,r_br_ht_max_cw,et_data,3BG);
%reg(BW,r_br_ht_max_ec,et_data,3AG);
%reg(Thor_H_W_CW,Age,et_data,1BA);
%reg(Thor_H_W_CW,ao_l_br_cw,et_data,2BB); * Question ;
%reg(Thor_H_W_CW,BCS,et_data,1BF);
%reg(Thor_H_W_CW,BW,et_data,1BE);
%reg(Thor_H_W_CW,L_br_h_w_cw,et_data,2AB);
%reg(Thor_H_W_CW,l_br_ht_max_cw,et_data,2CB); 
%reg(Thor_H_W_CW,LA_Ao,et_data,1BJ);
%reg(Thor_H_W_CW,r_br_h_w_cw,et_data,2FB);
%reg(Thor_H_W_CW,r_br_ht_max_cw,et_data,2GB); * Data error with this variable - Everything is 0 - non-sensical ;
%reg(Thor_H_W_EC,Age,et_data,1AA);
%reg(Thor_H_W_EC,ao_l_br_ec,et_data,2BA); * Question ;
%reg(Thor_H_W_EC,BCS,et_data,1AF);
%reg(Thor_H_W_EC,BW,et_data,1AE);
%reg(Thor_H_W_EC,L_br_h_w_ec,et_data,2AA);
%reg(Thor_H_W_EC,l_br_ht_max_ec,et_data,2CA);
%reg(Thor_H_W_EC,LA_Ao,et_data,1AJ);
%reg(Thor_H_W_EC,r_br_h_w_ec,et_data,2FA);
%reg(Thor_H_W_EC,r_br_ht_max_ec,et_data,2GA); * Data error with this variable - Everything is 0 - non-sensical ;


%reg(Thor_H_W_EC,l_br_ht_max_ec,et_data,2CA);
%reg(Thor_H_W_EC,LA_Ao,et_data,1AJ);
%reg(Thor_H_W_EC,r_br_h_w_ec,et_data,2FA);
%reg(Thor_H_W_EC,r_br_ht_max_ec,et_data,2GA); * Data error with this variable - Everything is 0 - non-sensical ;

/*8. Additional analyses based on this first round of results. May we ask you for the following analyses please:*/
/*a) Compare Ao_ht_EC to L_br_w_EC; Ao_ht_EC is dependent variable*/
/*b) Compare Ao_ht_CW to L_br_w_CW; Ao_ht_CW is dependent variable*/
/*c) ANOVA comparing R_br_H_W_EC vs L_br_H_W_EC; L_br_H_W_EC is dependent variable*/
/*d) ANOVA comparing R_br_H_W_CW vs L_br_H_W_CW; L_br_H_W_CW is dependent variable*/

%reg(Ao_ht_EC,L_br_w_EC,et_data,8a);
%reg(Ao_ht_CW,L_br_w_CW,et_data,8b);
%reg(L_br_H_W_EC,R_br_H_W_EC,et_data,8c);
%reg(L_br_H_W_CW,R_br_H_W_CW,et_data,8d); 

/*-L_br_h_EC as dominant and Ao_L_br_EC as variable*/
/*-L_br_h_CW as dominant and Ao_L_br_CW as variable*/
/*-R_br_H_W_EC as dominant and Ao_L_br_EC as variable*/
/*-R_br_H_W_CW as dominant and Ao_L_br_CW as variable*/
/*-R_br_h_EC as dominant and Ao_L_br_EC as variable*/
/*-R_br_h_CW as dominant and Ao_L_br_CW as variable*/
/*J1-J6*/

%reg(L_br_h_EC,Ao_L_br_EC,et_data,J1);
%reg(L_br_h_CW,Ao_L_br_CW,et_data,J2);
%reg(R_br_H_W_EC,Ao_L_br_EC,et_data,J3);
%reg(R_br_H_W_CW,Ao_L_br_CW,et_data,J4); 
%reg(R_br_h_EC,Ao_L_br_EC,et_data,J5);
%reg(R_br_h_CW,Ao_L_br_CW,et_data,J6); 


/*-R_br_H_EC (dependent) and Ao_ht_EC*/
/*-R_br_H_W_EC (dependent) and Ao_ht_EC*/
/*-R_br_H_CW (dependent) and Ao_ht_CW*/
/*-R_br_H_W_CW (dependent) and Ao_ht_CW*/

%reg(R_br_H_EC,Ao_ht_EC,et_data,N1);
%reg(R_br_H_W_EC,Ao_ht_EC,et_data,N1);
%reg(R_br_H_CW,Ao_ht_CW,et_data,N1);
%reg(R_br_H_W_CW,Ao_ht_CW,et_data,N1); 




/* Get regression PE (proc reg is fine for now for simple linear regression) and normality */
proc print data=pe; run;
proc print data=norm; run;




/* Put in Stacked data from dataset stack_cw_ec for following variables known as series 100 ...all combinations
Combine DV: bw Thor_h_w l_br_h r_br_h l_br_h_w r_br_h_w
Combine IV: la_ao ao_l_br l_br_ht_max r_br_ht_max Ao_ht
*/

/*****START *******

No evidence in output from etienne_results_20200103 - EC reply 20200221.xlsx furnished by ET 2020021 **** ommitting KL 20200729 

***** START ********/

%macro reg_stack (iv, ds, research_q);

	%let vars = bw Thor_h_w l_br_h r_br_h l_br_h_w r_br_h_w;
	%let word_cnt=%sysfunc(countw(&vars));

	%do i = 1 %to &word_cnt.;


	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;

	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model %scan(&vars.,&i)= &iv.;
		output out=%scan(&vars.,&i)res rstudent=%scan(&vars.,&i)r;
		ods output ParameterEstimates=%scan(&vars.,&i)pe;
	run;

	data %scan(&vars.,&i)pe;
		length research_q var $50.;
		set %scan(&vars.,&i)pe;
		var = "%scan(&vars.,&i)";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe %scan(&vars.,&i)pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="%scan(&vars.,&i)_res";
	ods listing gpath= "&path.";
	proc univariate data=%scan(&vars.,&i)res(keep=%scan(&vars.,&i)r) plots plotsize=30 normal;
		var %scan(&vars.,&i)r;
		ods output TestsForNormality=%scan(&vars.,&i)norm;
	run;
	ods listing close;
	ods graphics off;

	data %scan(&vars.,&i)norm;
	length var $50.;
		set %scan(&vars.,&i)norm;
		var = "%scan(&vars.,&i)";
	run;

	data norm;
		set norm %scan(&vars.,&i)norm;
	run;

		%end;

%mend;

    

* show regression and save rstudent, lev, cookd, dffits;
data pe;	set _null_;
data norm;	set _null_;

%reg_stack(la_ao,stack_cw_ec,Stack_la_ao); 
%reg_stack(ao_l_br,stack_cw_ec,Stack_la_ao); 
%reg_stack(l_br_ht_max,stack_cw_ec,Stack_la_ao); 
%reg_stack(r_br_ht_max,stack_cw_ec,Stack_la_ao); 
%reg_stack(Ao_ht,stack_cw_ec,Stack_la_ao); 

/* Get regression PE (proc reg is fine for now for simple linear regression) and normality */
proc print data=pe; run;
proc print data=norm; run;

/*****END *******

No evidence in output from etienne_results_20200103 - EC reply 20200221.xlsx furnished by ET 2020021 **** ommitting KL 20200729 

***** END ********/

/*Multivariate Regression - This can be handled as one-off analyses for now...in the tab reg_multi */
/*I1) L_br_H_W_EC = Thor H_W_EC and Ao_L_br_EC*/
/*I2) L_br_H_W_CW = Thor H_W_CW and Ao_L_br_CW*/

title "I1) L_br_H_W_EC = Thor H_W_EC and Ao_L_br_EC";
proc reg data= et_data;
model L_br_H_W_EC = Thor_H_W_EC Ao_L_br_EC;
run;

title "I2) L_br_H_W_CW = Thor H_W_CW and Ao_L_br_CW";
proc reg data= et_data;
model L_br_H_W_CW = Thor_H_W_CW Ao_L_br_CW;
run;

/* Both variables are significant drivers */

title;



/* Inter rater handled with a correlation analysis and BA */



%macro p(rq,x,y,l,u,s);
data temp;
/*set &prefix.%scan(&vars.,&i);*/
set et_data;
mean=mean(&x,&y);
diff=&y-&x;
r=0;
/*in order to show perfect agreement: diff=0 */
run;
/*title "&x.";*/
proc univariate data=temp normal;
var mean diff ;
output out=o mean= m_mean m_diff
std= s_mean s_diff;
run;
proc print data=o;
run;
data o_&x.;
set o;
length ds $15.;
d1=m_diff+2*s_diff;
d2=m_diff-2*s_diff;
call symput("m1",m_diff);
call symput("d1",d1);
call symput("d2",d2);
call symput("m_mean",m_mean);
ds = "&x.";
run;
data out; set out o_&x.; run;
proc sql;
select min(floor(mean)), max(ceil(mean))
into :min_x, :max_x
from temp;
quit;
proc sql;
select min(floor(2*(d2))),max(ceil(2*(d1)))
into :min_y, :max_y
from o_&x.;
quit;
proc sgplot data=temp;
/*ODS GRAPHICS / RESET IMAGENAME = "&prefix.&x._&y._%scan(&vars.,&i)" IMAGEFMT =PNG ;*/
ODS GRAPHICS / RESET IMAGENAME = "&rq._&x._&y." IMAGEFMT =PNG ;
ODS LISTING IMAGE_DPI= 300 GPATH = 'C:\Junk' ;
scatter y =  diff x = mean / MARKERATTRS= (color = black size = 10)
LEGENDLABEL = 'Mean of raters';
series y = r x = mean / lineattrs=(color = black thickness = 2 pattern = solid)
LEGENDLABEL = 'Reference (No rater difference)';
refline &m1 / axis = Y lineattrs=(color = gray thickness = 1 pattern = dot);
refline &d1 / axis = Y lineattrs=(color = gray thickness = 1 pattern = shortdash);
refline &d2 / axis = Y lineattrs=(color = gray thickness = 1 pattern = shortdash);
yaxis min = &l. max = &u. values=(&l. to &u. by &s.) Label= "Difference between raters" ;
/*yaxis min = &l. max = &u. values=(&min_y. to &max_y. by &s.) Label= "Difference between raters" ;*/
xaxis min = &min_x max = &max_x LABEL = 'Mean of raters' GRID ;
run;
title;



/* Roll up correlation into same macro */

proc corr data =  et_data;
var &x &y;
ods output PearsonCorr=p;
run;
data pc; length variable raters $30.;  set p  ; 
var = lowcase(variable);
raters = "&x. &y."; 
run;

data px; set pc;
call symput('drop_var',var);
where var = "&x.";
run;
/*data px (drop=&drop_var. &x. &y.); */
data px (keep=raters corr p_val); 
set px;

corr = &y.;
p_val = p&y.;
run;
%put var &x. &drop_var.;

data pearson; set pearson px; run;


%mend p;

/* These are lower case sensitive due to the above code */
data out; set _null_; run;
data pearson; set _null_; run;
%p(5A,thor_ht_ec,thor_ht_cw,-30,30,10);
%p(5B,thor_w_ec,thor_w_cw,-30,30,10);
%p(5C,thor_h_w_ec,thor_h_w_cw,-30,30,10);
%p(5E,ao_ht_ec,ao_ht_cw,-30,30,10);
%p(5F,ao_w_ec,ao_w_cw,-30,30,10);
%p(5G,l_br_h_ec,l_br_h_cw,-30,30,10);
%p(5H,l_br_w_ec,l_br_w_cw,-30,30,10);
%p(5I,l_br_h_w_ec,l_br_h_w_cw,-30,30,10);
%p(5I,ao_l_br_ec,ao_l_br_cw,-30,30,10);
%p(5O,r_br_h_ec,r_br_h_cw,-30,30,10);
%p(5P,r_br_w_ec,r_br_w_cw,-30,30,10);
%p(5Q,r_br_h_w_ec,r_br_h_w_cw,-30,30,10);
%p(7AA,l_br_h_w_ec,l_br_h_w_cw,-30,30,10);
%p(7AB,l_br_h_w_cw,r_br_h_w_cw,-30,30,10);
%p(7BA,r_br_h_w_ec,r_br_h_w_cw,-30,30,10);
%p(7BB,l_br_h_w_ec,r_br_h_w_ec,-30,30,10);




******************** End Bland Altman and Correlations for Interobserver Analaysis ********************;
proc print data =  out; run;
proc print data =  pearson; run;



***** ANOVA Analysis;
%macro aov(mod_ty,mod,research_q,dv,iv);
	/*ods output lsmeans tests3 diffs;*/
	proc mixed data=et_data_stacked;
		class &iv.;
		model &dv. = &iv. /* / solution */;
		lsmeans &iv.  / pdiff=all;
		ods output lsmeans=lsmeans_x (drop = df tvalue probt) 
			diffs = diffs_x (keep = estimate probt &iv. _&iv.);
	run;

	data diffs_&dv. (rename = (estimate = Compr_mean));
		set diffs_x;
		mergeme = 1;
		var = left(trim(put(&iv,5.0)));
		var2 = left(trim(put(_&iv,5.0)));
	run;

	data lsmeans_&dv. (rename = (estimate = lsmean effect = iv));
		length dv research_q $50.;
		set lsmeans_x;
		mod_number = "&mod.";
		dv = "&dv.";
		mod_type = "&mod_ty.";
		research_q = "&research_q.";
		lsmean_level = left(trim(put(&iv,5.0)));
		mergeme = 1;
	run;

	data merge_&mod. (drop=mergeme);
		length iv $50.;
		merge diffs_&dv. (drop =  &iv _&iv.) 
			lsmeans_&dv. (drop =  &iv);
		by mergeme;
	run;

	data allaov;
		retain dv mod_type mod_number research_q iv lsmean_level lsmean stderr;
		set allaov merge_&mod.;
	run;


/* Check normality for NPAR1WAY or Proc Mixed Interpretation */

	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;
	%let ds = et_data_stacked;
	%let var = &dv.;
	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q $50.;
		set &var.pe;
		var = "&var.";
		iv = "&iv.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
	length iv var $30.;
		set &var.norm;
		var = "&var.";
		iv = "&iv.";
	run;

	data norm;
		set norm &var.norm;
	run;

		* Non Parametric;
	proc npar1way data = xxx median wilcoxon;
		class &iv.;
		var &var.;
		ods output MedianAnalysis = mt /*WilcoxonScores=wt*/
		KruskalWallisTest=kw;
	run;

	data &var.mt (drop=name1 label1 cvalue1 variable nvalue1);
		set mt;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_CHMED");
		analysis = "median";
		p_value = nvalue1;
	run;

	data &var.kw (drop=name1 label1 cvalue1 variable nvalue1);
		set kw;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_KW");
		analysis = "kruskw";
		p_value = nvalue1;
	run;

	data npar;
		set npar &var.mt &var.kw;
	run;

%mend;

%macro aov_subset(ds,mod_ty,mod,research_q,dv,iv);
	/*ods output lsmeans tests3 diffs;*/
	proc mixed data=&ds.;
		class &iv.;
		model &dv. = &iv. /* / solution */;
		lsmeans &iv.  / pdiff=all;
		ods output lsmeans=lsmeans_x (drop = df tvalue probt) 
			diffs = diffs_x (keep = estimate probt &iv. _&iv.);
	run;

	data diffs_&dv. (rename = (estimate = Compr_mean));
		set diffs_x;
		mergeme = 1;
		var = left(trim(put(&iv,5.0)));
		var2 = left(trim(put(_&iv,5.0)));
	run;

	data lsmeans_&dv. (rename = (estimate = lsmean effect = iv));
		length dv research_q $50.;
		set lsmeans_x;
		mod_number = "&mod.";
		dv = "&dv.";
		mod_type = "&mod_ty.";
		research_q = "&research_q.";
		lsmean_level = left(trim(put(&iv,5.0)));
		mergeme = 1;
	run;

	data merge_&mod. (drop=mergeme);
		length iv $50.;
		merge diffs_&dv. (drop =  &iv _&iv.) 
			lsmeans_&dv. (drop =  &iv);
		by mergeme;
	run;

	data allaov;
		retain dv mod_type mod_number research_q iv lsmean_level lsmean stderr;
		set allaov merge_&mod.;
	run;


/* Check normality for NPAR1WAY or Proc Mixed Interpretation */

	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;
	%let var = &dv.;

	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q $50.;
		set &var.pe;
		var = "&var.";
		iv = "&iv.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
	length iv var $30.;
		set &var.norm;
		var = "&var.";
		iv = "&iv.";
	run;

	data norm;
		set norm &var.norm;
	run;

		* Non Parametric;
	proc npar1way data = xxx median wilcoxon;
		class &iv.;
		var &var.;
		ods output MedianAnalysis = mt /*WilcoxonScores=wt*/
		KruskalWallisTest=kw;
	run;

	data &var.mt (drop=name1 label1 cvalue1 variable nvalue1);
		set mt;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_CHMED");
		analysis = "median";
		p_value = nvalue1;
	run;

	data &var.kw (drop=name1 label1 cvalue1 variable nvalue1);
		set kw;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_KW");
		analysis = "kruskw";
		p_value = nvalue1;
	run;

	data npar;
		set npar &var.mt &var.kw;
	run;

%mend;



/* Adding addition init for freq_cust for tab aq chi-square 2020729 KL */

data ctf_all; 	set _null_; 
data f_p; 	set _null_;
data chi_p;	set _null_;
data kappa_all;	set _null_;
run;


data allaov; set _null_;
data lsmeans_x; set _null_;
data diffs_x; set _null_;
data norm; set _null_;
data pe; set _null_;
data npar; set _null_;
run;

/* additional questions */

%freq_cust(et_data_stacked,1,1,ao_vertebr,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,2,2,deep_barrel,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,3,3,deep_barrel,ao_vertebr);
%aov(aov,5,5,age,l_br_h_w_ge_1);
%aov(aov,6,6,bw,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,7,7,bcs_col,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,8,8,deep_barrel,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,9,9,mitral,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,10,10,coll_tr_brd,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,11,11,brd_size,l_br_h_w_ge_1);
%aov(aov,12,12,la_ao,l_br_h_w_ge_1);
%aov(aov,13,13,thor_h_w,l_br_h_w_ge_1);
%aov(aov,14,14,thor_h_w,l_br_h_w_ge_1);
%aov(aov,15,15,ao_l_br,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,16,16,spond,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,17,17,pectus,l_br_h_w_ge_1);
%freq_cust(et_data_stacked,18,18,ao_vertebr,l_br_h_w_ge_1);
%aov(aov,19,19,age,l_br_h_w_ge_0p6887);
%aov(aov,20,20,bw,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,21,21,bcs_col,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,22,22,deep_barrel,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,23,23,mitral,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,24,24,coll_tr_brd,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,25,25,brd_size,l_br_h_w_ge_0p6887);
%aov(aov,26,26,la_ao,l_br_h_w_ge_0p6887);
%aov(aov,27,27,thor_h_w,l_br_h_w_ge_0p6887);
%aov(aov,28,28,thor_h_w,l_br_h_w_ge_0p6887);
%aov(aov,29,29,ao_l_br,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,30,30,spond,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,31,31,pectus,l_br_h_w_ge_0p6887);
%freq_cust(et_data_stacked,32,32,ao_vertebr,l_br_h_w_ge_0p6887);
%aov(aov,34,34,age,r_br_h_w_ge_1);
%aov(aov,35,35,bw,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,36,36,bcs_col,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,37,37,deep_barrel,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,38,38,mitral,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,39,39,coll_tr_brd,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,40,40,brd_size,r_br_h_w_ge_1);
%aov(aov,41,41,la_ao,r_br_h_w_ge_1);
%aov(aov,42,42,thor_h_w,r_br_h_w_ge_1);
%aov(aov,43,43,thor_h_w,r_br_h_w_ge_1);
%aov(aov,44,44,ao_l_br,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,45,45,spond,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,46,46,pectus,r_br_h_w_ge_1);
%freq_cust(et_data_stacked,47,47,ao_vertebr,r_br_h_w_ge_1);
%aov(aov,48,48,age,r_br_h_w_ge_0p9792);
%aov(aov,49,49,bw,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,50,50,bcs_col,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,51,51,deep_barrel,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,52,52,mitral,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,53,53,coll_tr_brd,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,54,54,brd_size,r_br_h_w_ge_0p9792);
%aov(aov,55,55,la_ao,r_br_h_w_ge_0p9792);
%aov(aov,56,56,thor_h_w,r_br_h_w_ge_0p9792);
%aov(aov,57,57,thor_h_w,r_br_h_w_ge_0p9792);
%aov(aov,58,58,ao_l_br,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,59,59,spond,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,60,60,pectus,r_br_h_w_ge_0p9792);
%freq_cust(et_data_stacked,61,61,ao_vertebr,r_br_h_w_ge_0p9792);
%aov(aov,62,62,age,ao_l_br_gt_0);
%freq_cust(et_data_stacked,63,63,deep_barrel,ao_l_br_gt_0);
%freq_cust(et_data_stacked,64,64,mitral,ao_l_br_gt_0);
%freq_cust(et_data_stacked,65,65,brd_size,ao_l_br_gt_0);
%aov(aov,66,66,la_ao,ao_l_br_gt_0);
%aov(aov,67,67,l_br_h_w,ao_l_br_gt_0);
%aov(aov,68,68,r_br_h_w,ao_l_br_gt_0);
%freq_cust(et_data_stacked,69,69,pectus,ao_l_br_gt_0);
%freq_cust(et_data_stacked,70,70,spond,ao_l_br_gt_0);
%freq_cust(et_data_stacked,71,71,l_br_ht_y_n,ao_l_br_gt_0);
%freq_cust(et_data_stacked,72,72,ao_vertebr,ao_l_br_gt_0);
%aov(aov,73,73,thor_h_w,ao_l_br_gt_0);
%aov(aov,74,74,bw,ao_l_br_gt_0);
%freq_cust(et_data_stacked,75,75,bcs_col,ao_l_br_gt_0);
%freq_cust(et_data_stacked,76,76,brachy_brd,ao_l_br_gt_0);
%freq_cust(et_data_stacked,77,77,coll_tr_brd,ao_l_br_gt_0);
%aov(aov,78,78,age,ao_vertebr );
%freq_cust(et_data_stacked,79,79,deep_barrel,ao_vertebr );
%freq_cust(et_data_stacked,80,80,mitral,ao_vertebr );
%freq_cust(et_data_stacked,81,81,brd_size,ao_vertebr );
%aov(aov,82,82,la_ao,ao_vertebr );
%aov(aov,83,83,l_br_h_w,ao_vertebr );
%aov(aov,84,84,r_br_h_w,ao_vertebr );
%freq_cust(et_data_stacked,85,85,pectus,ao_vertebr );
%freq_cust(et_data_stacked,86,86,spond,ao_vertebr );
%aov(aov,87,87,ao_l_br,ao_vertebr );
%freq_cust(et_data_stacked,88,88,l_br_ht_y_n,ao_vertebr );
%aov(aov,89,89,thor_h_w,ao_vertebr );
%aov(aov,90,90,bw,ao_vertebr );
%freq_cust(et_data_stacked,91,91,bcs_col,ao_vertebr );
%freq_cust(et_data_stacked,92,92,brachy_brd,ao_vertebr );
%freq_cust(et_data_stacked,93,93,coll_tr_brd,ao_vertebr );
%aov(aov,94,94,thor_h_w ,brachy_brd);
%aov(aov,95,95,thor_h_w,mitral );
%aov(aov,96,96,thor_h_w,coll_tr_brd);
%aov(aov,97,97,thor_h_w ,brd_size);
%aov(aov,98,98,thor_h_w,spond);
%freq_cust(et_data_stacked,100,100,l_br_ht_y_n,r_br_ht_y_n);
%freq_cust(et_data_stacked,101,101,l_br_ht_y_n,ao_l_br_gt_0);
%freq_cust(et_data_stacked,102,102,l_br_ht_y_n,ao_vertebr);
%freq_cust(et_data_stacked,103,103,l_br_ht_y_n,ao_l_br_gt_0_vertebr_0);
/* Adding 20200729 missing  la_ao_le_1p5 Brachy_brd */

%freq_cust(et_data_stacked,1,1,l_br_ht_y_n,la_ao_le_1p5);
%freq_cust(et_data_stacked,1,2,l_br_ht_y_n,Brachy_brd);
%freq_cust(et_data_stacked,1,3,r_br_ht_y_n ,Brachy_brd);
/* Adding 20200729 missing  la_ao/l_br_ht_y_n l_br_h_w/l_ao_verte_com */
%aov(aov,1,2,la_ao ,l_br_ht_y_n);
%aov(aov,2,2,l_br_h_w ,l_ao_verte_com);



%reg(l_br_h_w,ao_l_br,et_data_stacked,99);

%let cat_describe = r_br_h_w_ge_1
					l_br_h_w_ge_1
;

***** The freq_cust macro pastes to the tab aq chi-square from ctf_all and chi_p*****;
***** The aov macro pastes to the tab aq anova from allaov *****;
***** The reg macro pastes to the tab aq regression from pe at the bottom since part of other set or l_br_h_wpe *****;

/* Tab Subgroup Analysis #1 */
/*a) What is the la_ao mean +/- SD or median, min, max, p25, p75 for the group of 14 with la_ao>1.5?*/
/*b) What is the la_ao mean +/- SD or median, min, max, p25, p75 for the group of 79 with la_ao ≤1.5?*/
proc means data=et_data_stacked n mean median std min p25 p75 max;
	where la_ao_le_1p5 = 1 and reviewer="CW";
	var la_ao;
run; 


proc means data=et_data_stacked n mean median std min p25 p75 max;
	where la_ao_le_1p5 = 0 and reviewer="CW";
	var la_ao;
run; 

%aov_subset(et_data_cw,aov,1c,1c,bw,la_ao_le_1p5);
%aov_subset(et_data_stacked,aov,1f,1f,ao_l_br,la_ao_le_1p5);

%freq_cust(et_data_cw,1e,1e,la_ao_le_1p5,bcs_col);
%freq_cust(et_data_stacked,1g,1g,la_ao_le_1p5,ao_vertebr);

/* Subgroup Analysis #2 */

%aov(aov,2a,2a,thor_h_w,ao_l_br_gt_0);
%aov(aov,2b,2b,l_br_h_w,ao_l_br_gt_0);
%aov(aov,2c,2c,bw,ao_l_br_gt_0);

%freq_cust(et_data_stacked,2d,2d,ao_l_br_gt_0,ao_vertebr);
%freq_cust(et_data_stacked,2e,2e,ao_l_br_gt_0,brachy_brd);
%freq_cust(et_data_stacked,2f,2f,ao_l_br_gt_0,coll_tr_brd);

/* Subgroup Analysis #3 */

proc means data=et_data_ec n mean median min max p25 p75;
	var l_br_diff;
run;

proc means data=et_data_cw n mean median min max p25 p75;
	var l_br_diff;
run;

proc means data=et_data_stacked n mean median min max p25 p75;
	var l_br_diff;
run;

/* Sub Analysis #4 Means */
proc means data=et_data_ec n mean median min max p25 p75;
	var r_br_diff;
run;

proc means data=et_data_cw n mean median min max p25 p75;
	var r_br_diff;
run;

proc means data=et_data_stacked n mean median min max p25 p75;
	var r_br_diff;
run;

%freq_cust(et_data_cw,4,4,l_br_ht_y_n,r_br_ht_y_n);

/* Sub Analysis #5 Logistic ane Expand with Rocme datasets for 0.9/-0.9*/
ods graphics on;
proc logistic data=et_data_stacked plots(only)=(roc(id=obs) effect);
  model l_br_ht_y_n (event="1")  = thor_h_w  / scale=none
                        clparm=wald
                        clodds=pl
                        rsquare;
run;
ods graphics off;

ods graphics on;
proc logistic data=et_data_stacked plots(only)=(roc(id=obs) effect);
  model l_br_ht_y_n = thor_h_w la_ao  / scale=none
                        clparm=wald
                        clodds=pl
                        rsquare;
run;
ods graphics off;

%aov_subset(et_data_ec,aov,1c,1c,thor_h_w,deep_barrel);

proc freq data=et_data_ec;
	tables bcs_col / missing;
run;


/* Additional Request for specific Sensitivity / Specificity at 0.9*/

%macro logit(ds,iv,dv,prob);
	/* ods graphics on;            */
	proc logistic data=&ds. /* plots=roc */;
		model &dv. (event = "1") = &iv. / outroc=roc1;
		output out=out p=phat;
	run;

	/*ods graphics off;*/
	title  "ROC plot for &dv. = &iv.";
	title2 " ";

	%rocplot( inroc = roc1, inpred = out, p = phat,
		id = &iv. _sens_ _spec_ _OPTEFF_ _opty_ _cutpt_,
		optcrit = youden , pevent = &prob.,
		optsymbolstyle = size=0, optbyx = panelall, x = &iv.)

		data rocme;
	retain _id &iv. _CORRECT_ _sens_ _spec_ _FALPOS_ _FALNEG_ _opty_;
	set _rocplot (keep=_id &iv. _CORRECT_ _sens_ _spec_    _sensit_ _FALPOS_ _FALNEG_ _opty_ __spec_ _POS_ _NEG_);

	if (_sens_ in (0 1)) or (_spec_ in (0 1)) or (_opty_ = "Y") then
		output;
	run;

	data rocme9_10;
	retain _id &iv. _CORRECT_ _sens_ _spec_ _FALPOS_ _FALNEG_ _opty_;
	set _rocplot (keep=_id &iv. _CORRECT_ _sens_ _spec_    _sensit_ _FALPOS_ _FALNEG_ _opty_ __spec_ _POS_ _NEG_);

	if (0.89 le _sens_ le 0.91) or (0.09 le _spec_ le 0.11) or (_opty_ = "Y") then
		output;
		run;

		data rocme90;
	retain _id &iv. _CORRECT_ _sens_ _spec_ _FALPOS_ _FALNEG_ _opty_;
	set _rocplot (keep=_id &iv. _CORRECT_ _sens_ _spec_    _sensit_ _FALPOS_ _FALNEG_ _opty_ __spec_ _POS_ _NEG_);

	if (0.89 le _sens_ le 0.91) or (0.89 le _spec_ le 0.91) or (_opty_ = "Y") then
		output;
		run;


%mend;


/*Tab: subgroup analysis 5*/

%logit(et_data_stacked,thor_h_w,l_br_ht_y_n,1);



/***** These appear to be extra and not associated with output as of 20200227 - KL START *********/

***** ANOVA Analysis;
%macro aov(mod_ty,mod,research_q,dv,iv);
	/*ods output lsmeans tests3 diffs;*/
	proc mixed data=&dataset.;
		class &iv.;
		model &dv. = &iv. /* / solution */;
		lsmeans &iv.  / pdiff=all;
		ods output lsmeans=lsmeans_x (drop = df tvalue probt) 
			diffs = diffs_x (keep = estimate probt &iv. _&iv.);
	run;

	data diffs_&dv. (rename = (estimate = Compr_mean));
		set diffs_x;
		mergeme = 1;
		var = left(trim(put(&iv,5.0)));
		var2 = left(trim(put(_&iv,5.0)));
	run;

	data lsmeans_&dv. (rename = (estimate = lsmean effect = iv));
		length dv research_q $50.;
		set lsmeans_x;
		mod_number = "&mod.";
		dv = "&dv.";
		mod_type = "&mod_ty.";
		research_q = "&research_q.";
		lsmean_level = left(trim(put(&iv,5.0)));
		mergeme = 1;
	run;

	data merge_&mod. (drop=mergeme);
		length iv $50.;
		merge diffs_&dv. (drop =  &iv _&iv.) 
			lsmeans_&dv. (drop =  &iv);
		by mergeme;
	run;

	data allaov;
		retain dv mod_type mod_number research_q iv lsmean_level lsmean stderr;
		set allaov merge_&mod.;
	run;


/* Check normality for NPAR1WAY or Proc Mixed Interpretation */

	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;
	%let var = &dv.;
	data xxx;
		set &dataset.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q $50.;
		set &var.pe;
		var = "&var.";
		iv = "&iv.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
	length iv var $30.;
		set &var.norm;
		var = "&var.";
		iv = "&iv.";
	run;

	data norm;
		set norm &var.norm;
	run;

		* Non Parametric;
	proc npar1way data = xxx median wilcoxon;
		class &iv.;
		var &var.;
		ods output MedianAnalysis = mt /*WilcoxonScores=wt*/
		KruskalWallisTest=kw;
	run;

	data &var.mt (drop=name1 label1 cvalue1 variable nvalue1);
		set mt;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_CHMED");
		analysis = "median";
		p_value = nvalue1;
	run;

	data &var.kw (drop=name1 label1 cvalue1 variable nvalue1);
		set kw;
		length analysis iv var $30.;
		var = "&var.";
		iv = "&iv.";
		where name1 in ("P_KW");
		analysis = "kruskw";
		p_value = nvalue1;
	run;

	data npar;
		set npar &var.mt &var.kw;
	run;

%mend;

data allaov; set _null_;
data lsmeans_x; set _null_;
data diffs_x; set _null_;
data norm; set _null_;
data pe; set _null_;
data npar; set _null_;
run;

%let dataset=et_data_ec;

%aov(aov,1AB,1AB,Thor_H_W,Gender);
%aov(aov,1AC,1AC,Thor_H_W,Breed);
%aov(aov,1AD,1AD,Thor_H_W,Deep_barrel);
%aov(aov,1AG,1AG,Thor_H_W,Indication_Dx);
%aov(aov,1AH,1AH,Thor_H_W,resp);
%aov(aov,1AI,1AI,Thor_H_W,echo_dx);
%aov(aov,2DA,2DA,Thor_H_W,l_br_ht_y_n);
%aov(aov,2EA,2EA,Thor_H_W,ao_vertebr);
%aov(aov,2HA,2HA,Thor_H_W,r_br_ht_y_n);
%aov(aov,2IA,2IA,Thor_H_W,pectus);
%aov(aov,3AD,3AD,BW,l_br_ht_y_n);
%aov(aov,3AH,3AH,BW,r_br_ht_y_n);
%aov(aov,3AI,3AI,BW,pectus);
%aov(aov,4AD,4AD,BCS,l_br_ht_y_n);
%aov(aov,4AH,4AH,BCS,r_br_ht_y_n);
%aov(aov,4AI,4AI,BCS,pectus);

%let dataset=et_data_cw;

%aov(aov,1BB,1BB,Thor_H_W,Gender);
%aov(aov,1BC,1BC,Thor_H_W,Breed);
%aov(aov,1BD,1BD,Thor_H_W,Deep_barrel);
%aov(aov,1BG,1BG,Thor_H_W,Indication_Dx);
%aov(aov,1BH,1BH,Thor_H_W,resp);
%aov(aov,1BI,1BI,Thor_H_W,echo_dx);
%aov(aov,2DB,2DB,Thor_H_W,l_br_ht_y_n);
%aov(aov,2EB,2EB,Thor_H_W,ao_vertebr);
%aov(aov,2HB,2HB,Thor_H_W,r_br_ht_y_n);
%aov(aov,2IB,2IB,Thor_H_W,pectus);
%aov(aov,3BD,3BD,BW,l_br_ht_y_n);
%aov(aov,3BH,3BH,BW,r_br_ht_y_n);
%aov(aov,3BI,3BI,BW,pectus);
%aov(aov,4BH,4BH,BCS,r_br_ht_y_n);
%aov(aov,4BI,4BI,BCS,pectus);
%aov(aov,BAD,4BD,BCS,l_br_ht_y_n);

%let dataset=et_data_stacked;

%aov(aov,1B,1B,Thor_H_W,Gender);
%aov(aov,1C,1C,Thor_H_W,Breed);
%aov(aov,1D,1D,Thor_H_W,Deep_barrel);
%aov(aov,1G,1G,Thor_H_W,Indication_Dx);
%aov(aov,1H,1H,Thor_H_W,resp);
%aov(aov,1I,1I,Thor_H_W,echo_dx);
%aov(aov,2D,2D,Thor_H_W,l_br_ht_y_n);
%aov(aov,2E,2E,Thor_H_W,ao_vertebr);
%aov(aov,2H,2H,Thor_H_W,r_br_ht_y_n);
%aov(aov,2I,2I,Thor_H_W,pectus);
%aov(aov,3D,3D,BW,l_br_ht_y_n);
%aov(aov,3H,3H,BW,r_br_ht_y_n);
%aov(aov,3I,3I,BW,pectus);
%aov(aov,4D,4D,BCS,l_br_ht_y_n);
%aov(aov,4H,4H,BCS,r_br_ht_y_n);
%aov(aov,4I,4I,BCS,pectus);


%macro reg (var, iv, ds, research_q);
	ods tagsets.sasreport13(id=egsr) gtitle gfootnote;
	%let path = C:\Junk;

	data xxx;
		set &ds.;
	run;

	proc reg data=xxx;
		model &var.= &iv.;
		output out=&var.res rstudent=&var.r;
		ods output ParameterEstimates=&var.pe;
	run;

	data &var.pe;
		length research_q $50.;
		set &var.pe;
		var = "&var.";
		where variable not in ("Intercept");
		research_q = "&research_q.";
	run;

	data pe;
		set pe &var.pe;
	run;

	* Examine residuals for normality;
	ods graphics on/reset=index imagefmt=png imagename="&var._res";
	ods listing gpath= "&path.";
	proc univariate data=&var.res(keep=&var.r) plots plotsize=30 normal;
		var &var.r;
		ods output TestsForNormality=&var.norm;
	run;
	ods listing close;
	ods graphics off;

	data &var.norm;
		set &var.norm;
		var = "&var.";
	run;

	data norm;
		set norm &var.norm;
	run;

%mend;

* show regression and save rstudent, lev, cookd, dffits;
data pe;	set _null_;
data norm;	set _null_;
run;

%reg(BCS,ao_l_br,et_data_ec,4AB);
%reg(BCS,ao_vertebr,et_data_ec,4AE);
%reg(BCS,L_br_h_w,et_data_ec,4AA);
%reg(BCS,l_br_ht_max,et_data_ec,4AC);
%reg(BCS,r_br_h_w,et_data_ec,4AF);
%reg(BCS,r_br_ht_max,et_data_ec,4AG);
%reg(BW,ao_l_br,et_data_ec,3AB);
%reg(BW,ao_vertebr,et_data_ec,3AE);
%reg(BW,L_br_h_w,et_data_ec,3AA);
%reg(BW,l_br_ht_max,et_data_ec,3AC);
%reg(BW,r_br_h_w,et_data_ec,3AF);
%reg(BW,r_br_ht_max,et_data_ec,3AG);
%reg(Thor_H_W,Age,et_data_ec,1AA);
%reg(Thor_H_W,ao_l_br,et_data_ec,2BA);
%reg(Thor_H_W,BCS,et_data_ec,1AF);
%reg(Thor_H_W,BW,et_data_ec,1AE);
%reg(Thor_H_W,L_br_h_w,et_data_ec,2AA);
%reg(Thor_H_W,l_br_ht_max,et_data_ec,2CA);
%reg(Thor_H_W,LA_Ao,et_data_ec,1AJ);
%reg(Thor_H_W,r_br_h_w,et_data_ec,2FA);
%reg(Thor_H_W,r_br_ht_max,et_data_ec,2GA);
%reg(BCS,ao_l_br,et_data_cw,4BB);
%reg(BCS,ao_vertebr,et_data_cw,4BE);
%reg(BCS,L_br_h_w,et_data_cw,4BA);
%reg(BCS,l_br_ht_max,et_data_cw,4BC);
%reg(BCS,r_br_h_w,et_data_cw,4BF);
%reg(BCS,r_br_ht_max,et_data_cw,4BG);
%reg(BW,ao_l_br,et_data_cw,3BB);
%reg(BW,ao_vertebr,et_data_cw,3BE);
%reg(BW,L_br_h_w,et_data_cw,3BA);
%reg(BW,l_br_ht_max,et_data_cw,3BC);
%reg(BW,r_br_h_w,et_data_cw,3BF);
%reg(BW,r_br_ht_max,et_data_cw,3BG);
%reg(Thor_H_W,Age,et_data_cw,1BA);
%reg(Thor_H_W,ao_l_br,et_data_cw,2BB);
%reg(Thor_H_W,BCS,et_data_cw,1BF);
%reg(Thor_H_W,BW,et_data_cw,1BE);
%reg(Thor_H_W,L_br_h_w,et_data_cw,2AB);
%reg(Thor_H_W,l_br_ht_max,et_data_cw,2CB);
%reg(Thor_H_W,LA_Ao,et_data_cw,1BJ);
%reg(Thor_H_W,r_br_h_w,et_data_cw,2FB);
%reg(Thor_H_W,r_br_ht_max,et_data_cw,2Gb);
%reg(BCS,ao_l_br,et_data_stacked,4B);
%reg(BCS,ao_vertebr,et_data_stacked,4E);
%reg(BCS,L_br_h_w,et_data_stacked,4A);
%reg(BCS,l_br_ht_max,et_data_stacked,4C);
%reg(BCS,r_br_h_w,et_data_stacked,4F);
%reg(BCS,r_br_ht_max,et_data_stacked,4G);
%reg(BW,ao_l_br,et_data_stacked,3B);
%reg(BW,ao_vertebr,et_data_stacked,3E);
%reg(BW,L_br_h_w,et_data_stacked,3A);
%reg(BW,l_br_ht_max,et_data_stacked,3C);
%reg(BW,r_br_h_w,et_data_stacked,3F);
%reg(BW,r_br_ht_max,et_data_stacked,3G);
%reg(Thor_H_W,Age,et_data_stacked,1A);
%reg(Thor_H_W,ao_l_br,et_data_stacked,2B);
%reg(Thor_H_W,BCS,et_data_stacked,1F);
%reg(Thor_H_W,BW,et_data_stacked,1E);
%reg(Thor_H_W,L_br_h_w,et_data_stacked,2A);
%reg(Thor_H_W,l_br_ht_max,et_data_stacked,2C);
%reg(Thor_H_W,LA_Ao,et_data_stacked,1J);
%reg(Thor_H_W,r_br_h_w,et_data_stacked,2F);
%reg(Thor_H_W,r_br_ht_max,et_data_stacked,2G);




/***** These appear to be extra and not associated with output as of 20200227 - KL END *********/





/* 
Have individual (EC, CW) results, need stacked
- l_br_h_w and r_br_h_w (non-stacked: 0.48719-0.61174 +/- 0.13265-0.11631; P = 0.0004 - <0.0001; rsch question 8d, 8e) and others as noted in the MS
*/
%reg(L_br_h_w,r_br_h_w,et_data_stacked,8);

/* Do LPB H:W and the occurrence of focal LPB compression increase with increasing LA size? 
2 new research questions: Is there a relationship between l_br_ht_y_n=1 and LA:Ao? Is there a relationship between l_br_ht_y_n and LA:Ao >1.5 vs LA:Ao1.5 (Chi sq)? 
 */
%aov(aov,1,1,la_ao,l_br_ht_y_n);
%freq_cust(et_data_stacked,1,1,l_br_ht_y_n ,la_ao_le_1p5);

%freq_cust(et_data_stacked,2,2,l_br_ht_y_n ,brachy_brd);
%freq_cust(et_data_stacked,3,3,r_br_ht_y_n ,brachy_brd);


/*Thor_h_w compounded variable l_br_ht_y_n=1 AND ao_l_br<0.1 AND ao_vert = 0 or 1	*/
/*	Getting p-values is complicated since there is overlap between the populations*/

proc means data=et_data_stacked n nmiss mean std;
	where l_ao_verte0_com = 1;
	class reviewer;
	var thor_h_w;
run;
proc means data=et_data_stacked n nmiss mean std;
	where l_ao_verte1_com = 1;
	class reviewer;
	var thor_h_w;
run;



/*%aov(aov,1,1,l_br_h_w,l_ao_verte_com);*/