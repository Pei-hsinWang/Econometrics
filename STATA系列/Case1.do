*****************************************
****数据导入
// 加载auto 数据集
sysuse auto,clear //sysuse是使用系统数据集命令，选项clear表示清空保存在内存中的数据
// 查看数据结构
describe

****************************************
****回归分析
// 一元线性回归
reg price weight //reg Y X controlvar
// 设置控制变量
global control  length mpg // 生成控制变量的代理，用$control即可表示length mpg三个变量
// 进行多元回归 
reg price weight $control //reg Y X 
// 使用稳健标准误
reg price weight $control, robust //robust可以缩写为r