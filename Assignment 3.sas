/*To read the csv file in SAS*/
proc import datafile="C:\Users\virendsi\Downloads\Churn_telecom.csv"
out=churndata  
dbms=csv  
replace;
getname=yes;
run;

/*Reading the metadata of data*/
proc contents data=churndata nods;
run;
/*Reading first 10 observations */
proc print data=churndata(obs=10);
run;

/*To see the missing observations for each variable.*/
proc means data = churndata nmiss;
run;
/*To drop variables having missing observations > 50000*/ 
data churn_data1;
set churndata (drop = crtcount rmcalls rmmou rmrev tot_ret tot_acpt educ1 retdays);
run;

/*To check ttest of first 30 variables*/
proc ttest data=churn_data1;
class churn;
var rev_Mean mou_Mean totmrc_Mean da_Mean ovrmou_Mean ovrrev_Mean vceovr_Mean datovr_Mean roam_Mean rev_Range mou_Range totmrc_Range da_Range ovrmou_Range ovrrev_Range vceovr_Range datovr_Range roam_Range change_mou change_rev drop_vce_Mean drop_dat_Mean blck_vce_Mean blck_dat_Mean unan_vce_Mean unan_dat_Mean plcd_vce_Mean plcd_dat_Mean recv_vce_Mean recv_sms_Mean;
run;
/*To check ttest of next 60 variables*/
proc ttest data=churn_data1;
class churn;
var comp_vce_Mean comp_dat_Mean custcare_Mean ccrndmou_Mean cc_mou_Mean inonemin_Mean threeway_Mean mou_cvce_Mean 
mou_cdat_Mean mou_rvce_Mean owylis_vce_Mean mouowylisv_Mean iwylis_vce_Mean mouiwylisv_Mean peak_vce_Mean peak_dat_Mean 
mou_peav_Mean mou_pead_Mean opk_vce_Mean opk_dat_Mean mou_opkv_Mean mou_opkd_Mean drop_blk_Mean attempt_Mean complete_Mean 
callfwdv_Mean callwait_Mean drop_vce_Range drop_dat_Range blck_vce_Range blck_dat_Range unan_vce_Range unan_dat_Range 
plcd_vce_Range plcd_dat_Range recv_vce_Range recv_sms_Range comp_vce_Range comp_dat_Range custcare_Range ccrndmou_Range 
cc_mou_Range inonemin_Range threeway_Range mou_cvce_Range mou_cdat_Range mou_rvce_Range owylis_vce_Range mouowylisv_Range 
iwylis_vce_Range mouiwylisv_Range peak_vce_Range peak_dat_Range mou_peav_Range mou_pead_Range opk_vce_Range opk_dat_Range 
mou_opkv_Range mou_opkd_Range drop_blk_Range;
run;



/*Calculating Frequency for categorical variables */
proc freq data= churn_data1;
table HHstatin REF_QTY area asl_flag car_buy cartype
children crclscod creditcd csa div_type dualband
dwllsize dwlltype ethnic hnd_webcap infobase kid0_2
kid11_15 kid16_17 kid3_5 kid6_10 mailflag mailordr
mailresp marital new_cell occu1 ownrent pcowner
prizm_social_one proptype refurb_new solflag wrkwoman;
run;

/*Dropping character variables where there are
more than 70k missing frequencies.*/
data churn_data2;
set churn_data1 (drop = Ref_Qty div_type mailflag pcowner solflag wrkwoman proptype occu1 mailresp mailordr children 
cartype);
run;

/*Drop insignificant variables at 95%confidence level from ttest*/
data churn_data3;
set churn_data2(drop= numbcars rv  pre_hnd_price callfwdv_Range complete_Range attempt_Range drop_blk_Range  mou_peav_Range peak_vce_Range comp_vce_Range recv_sms_Range plcd_vce_Range blck_vce_Range drop_vce_Range callfwdv_Mean recv_sms_Mean datovr_Range datovr_Mean);
run;

/*Checking for mc between variables*/

proc reg data= churn_data3;
model churn=Customer_ID actvsubs adjmou adjqty adjrev adults age1 age2 attempt_Mean avg3mou avg3qty avg3rev
avg6mou avg6qty avg6rev avgmou avgqty avgrev blck_dat_Mean blck_dat_Range blck_vce_Mean callwait_Mean callwait_Range
cc_mou_Mean cc_mou_Range ccrndmou_Mean ccrndmou_Range change_mou change_rev comp_dat_Mean comp_dat_Range comp_vce_Mean 
complete_Mean custcare_Mean custcare_Range da_Mean da_Range drop_blk_Mean drop_dat_Mean
drop_dat_Range drop_vce_Mean eqpdays forgntvl hnd_price income inonemin_Mean inonemin_Range iwylis_vce_Mean 
iwylis_vce_Range last_swap lor models months mou_Mean mou_Range mou_cdat_Mean mou_cdat_Range mou_cvce_Mean
mou_cvce_Range mou_opkd_Mean mou_opkd_Range mou_opkv_Mean mou_opkv_Range mou_pead_Mean mou_pead_Range mou_peav_Mean 
mou_rvce_Mean mou_rvce_Range mouiwylisv_Mean mouiwylisv_Range mouowylisv_Mean mouowylisv_Range
mtrcycle opk_dat_Mean opk_dat_Range opk_vce_Mean opk_vce_Range ovrmou_Mean ovrmou_Range ovrrev_Mean ovrrev_Range 
owylis_vce_Mean owylis_vce_Range peak_dat_Mean peak_dat_Range peak_vce_Mean phones plcd_dat_Mean plcd_dat_Range 
plcd_vce_Mean recv_vce_Mean recv_vce_Range rev_Mean rev_Range roam_Mean roam_Range threeway_Mean
threeway_Range totcalls totmou totmrc_Mean totmrc_Range totrev truck unan_dat_Mean unan_dat_Rangeunan_vce_Mean 
unan_vce_Range uniqsubs vceovr_Mean vceovr_Range / vif tol;
run;

/*Dropping correlated variabled whose vif > 10 and customer_id variable*/
data churn_data4;
set churn_data3 (drop = owylis_vce_Mean drop_dat_Range custcare_Range drop_dat_Mean avg6rev last_swap avgrev eqpdays inonemin_Range change_mou
rev_Range ovrmou_Mean recv_vce_Range blck_dat_Mean mou_pead_Range ovrmou_Range blck_dat_Range custcare_Mean change_rev avgqty
roam_Mean avgmou mou_opkd_Range opk_vce_Mean roam_Range drop_blk_Mean inonemin_Mean peak_vce_Mean mou_opkd_Mean
opk_dat_Range peak_dat_Range mou_cdat_Range mou_cdat_Mean avg3qty avg6qty avg6mou recv_vce_Mean avg3rev rev_Mean plcd_dat_Range
cc_mou_Range ccrndmou_Range vceovr_Range ovrrev_Range comp_dat_Range mou_Mean cc_mou_Mean totrev adjrev vceovr_Mean ovrrev_Mean avg3mou 
ccrndmou_Mean unan_vce_Mean plcd_dat_Mean comp_vce_Mean mou_rvce_Mean attempt_Mean mou_peav_Mean mou_opkv_Mean totmou adjmou adjqty
totcalls mou_cvce_Mean peak_dat_Mean opk_dat_Mean comp_dat_Mean complete_Mean drop_vce_Mean mou_pead_Mean plcd_vce_Mean unan_dat_Mean
);
run;

ods rtf file='temp1.rtf';
proc logistic data=churn_data4 descending;
class HHstatin  asl_flag car_buy crclscod creditcd  dualband  dwlltype  
hnd_webcap infobase kid0_2 kid11_15 kid16_17 kid3_5 kid6_10 marital new_cell ownrent 
prizm_social_one refurb_new;
model churn = actvsubs hhstatin adults age1 age2  asl_flag blck_vce_mean crclscod
callwait_mean callwait_range car_buy creditcd  da_mean da_range 
dualband  dwlltype  forgntvl hnd_price hnd_webcap income
infobase iwylis_vce_mean iwylis_vce_range kid0_2 kid11_15 kid16_17 kid3_5
kid6_10 lor marital models months mou_range mou_cvce_range mou_opkv_range
mou_rvce_range mouiwylisv_mean mouiwylisv_range mouowylisv_mean
mouowylisv_range mtrcycle new_cell opk_vce_range ownrent
owylis_vce_range phones prizm_social_one refurb_new threeway_mean
threeway_range totmrc_mean totmrc_range truck unan_dat_range
unan_vce_range uniqsubs; run;
ods rtf close;

proc surveyselect data=churn_data4
   method=srs n=25000 out=churn_sample;
run;

proc logistic data=churn_data4 descending;
class HHstatin  asl_flag car_buy crclscod creditcd  dualband  dwlltype  
hnd_webcap infobase kid0_2 kid11_15 kid16_17 kid3_5 kid6_10 marital new_cell ownrent 
prizm_social_one refurb_new;
model churn = actvsubs hhstatin adults age1 age2  asl_flag blck_vce_mean crclscod
callwait_mean callwait_range car_buy creditcd  da_mean da_range 
dualband  dwlltype  forgntvl hnd_price hnd_webcap income
infobase iwylis_vce_mean iwylis_vce_range kid0_2 kid11_15 kid16_17 kid3_5
kid6_10 lor marital models months mou_range mou_cvce_range mou_opkv_range
mou_rvce_range mouiwylisv_mean mouiwylisv_range mouowylisv_mean
mouowylisv_range mtrcycle new_cell opk_vce_range ownrent
owylis_vce_range phones prizm_social_one refurb_new threeway_mean
threeway_range totmrc_mean totmrc_range truck unan_dat_range unan_vce_range uniqsubs; 
score data=churn_sample out=finaloutput;
run;

ods rtf file='temp2.rtf';
proc freq data=finaloutput;
table churn;run;
ods rtf close;

