***数据导入
clear
cd"C:\Users\Administrator\Desktop\拒绝H0的日常\双重差分法"
import excel "案例数据.xlsx", sheet("Sheet1") firstrow clear
********************************************准备工作********************************************
global xlist  lnagdp indust_stru finance ainternet market //定义控制变量

//生成干预时间差
destring 干预时间, g(Time) //由于原数据干预时间是字符串，需要将其转化为数值数据
gen dist = 年份-Time
replace dist = -4 if dist  <= -4 // 细节见文章解释
//生成样本政策实施的相对时间
sum dist
******************************************附录1.描述性统计**************************************
asdoc sum Y DID $xlist , dec(4) save(描述性统计.doc) title("表1描述性统计") replace
asdoc sum Y DID $xlist if DID==1 , dec(4) save(描述性统计.doc) title("表1描述性统计") append
asdoc sum Y DID $xlist if DID==0 , dec(4) save(描述性统计.doc) title("表1描述性统计") append
*******************************************一、基准回归 *********************************
reghdfe Y  DID $xlist , absorb(id 年份) vce(cluster id) 
est store benchmark1
outreg2  benchmark1 using 基准回归.doc, replace /*
*/bdec(3) sdec(3) se addtext(Controls, YES, City FE, YES, Year Fe,Yes)
*******************************************二、平行趋势**********************************
#delimit;
eventdd Y $xlist, timevar(dist) 
     method(hdfe, absorb(id 年份) vce(robust))
     inrange leads(3) lags(8) 
     level(95) ci(rcap)
     baseline(0) noline
     coef_op(m(o) c(l) color(black) lcolor(black))
     graph_op(ytitle(Coefficients)
     color(black) xlabel(-3(1)8)
     xline(0, lc(black*0.5) lp(dash))
     graphregion(fcolor(white)));
#delimit cr