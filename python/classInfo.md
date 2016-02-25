# 全局变量说明

* speedLimit: N * 3 的数组, 第一列为起始公里标(单位: m), 第二列为速度限制(单位: km/h), 第三列为终点公里标(单位: m)
* nodePosition: N * 2 的数组, 第一列为节点编号, 第二列为节点公里标(单位: m)
* gradient: N * 3 的数组, 第一列起始公里标(单位: m), 第二列为坡度, 第三列为终点公里标(单位: m)
* curvature: N * 3 的数组, 第一列为起始公里标(单位: m), 第二列为曲率, 第三列为终点公里标(单位: m)

# 函数说明

* sectionFun(startNode): 根据速度限制进行分区.
  输入: startNode, 起始节点号, 范围为1-13
  输出: 参数一, 分区端点数组, 第一列为分区起始端点公里标(单位: m), 第二列为分区终点公里标(单位: m)
  	参数二, 分区速度限制(单位: km/h)

# 类定义说明

* Interstation: 站间行驶方案
  变量:
	startNode, 起始节点号
	endNode, 终点节点号
	targetT, 目标行驶时间(单位: s)
	section, 区间端点, 第一列为分区起始端点公里标(单位: m), 第二列为分区终点公里标(单位: m)
	secLimit, 区间速度限制(单位: km/h)
	secNum, 区间数目
	S, 位置向量(单位: m), 一个大小为区间数的数组, 其中每个元素为从区间起点到终点的步长为0.1的向量
	T, 时间向量(单位: s), 一个大小为区间数的数组, 其中每个元素为对应S的时间
	F, 牵引力向量(单位: kN), 一个大小为区间数的数组, 其中每个元素为对应S的牵引力
	B, 制动力向量(单位: kN), 一个大小为区间数的数组, 其中每个元素为对应S的制动力
	V, 速度向量(单位: m/s), 一个大小为区间数的数组, 其中每个元素为对应S的速度
	A, 加速度向量(单位: m/s^2), 一个大小为区间数的数组, 其中每个元素为对应S的加速度
	usedE, 能量向量(单位: J), 一个大小为区间数的数组, 其中每个元素为对应S已经消耗的能量
	braking, 区间限速制动曲线, 一个大小为区间数的数组, 若没有则为None, 若有则为一个与对应S大小相等的向量
	endBraking, 终点制动曲线, 一个大小为区间数的数组, 与S相对应
	now, 状态变量数组, 第一个元素为区间索引, 第二个元素为区间内索引
	secEnerge, 区间消耗的能量数组
	secLeftE, 区间剩余的能量数组
	totalE, 总能量
	totalT, 总时间
	M, 列车质量(单位: kg)
	constA, 列车基本阻力参数A
	constB, 列车基本阻力参数B
	constC, 列车基本阻力参数C
	cosntc, 曲线阻力参数
  函数:
	maxTractionForce(self, v), 求最大牵引力
	  输入: v, 速度(单位: m/s)
	  输出: T, 最大牵引力(单位: N)
	maxBrakingForce(self, v), 求最大制动力
	  输入: v, 速度(单位: m/s)
	  输出: B, 最大制动力(单位: N)
	groundConditionFun(s), 计算s处的坡度和曲率
	  输入: s, 公里标(单位: m)
	  输出: i, 坡度
	  	R, 曲率
	totalResistanceFun(self, v, s), 求总阻力
	  输入: v, 速度(单位: m/s)
	  	s, 公里标(单位: m)
	  输出: W, 总阻力(单位: N)