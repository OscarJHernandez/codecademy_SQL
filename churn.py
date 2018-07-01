import numpy as np
import matplotlib.pyplot as plt


x = [1,2,3]
x_labels = ['2017-01-01','2017-02-01','2017-03-01']
churn_total = [0.161687170474517,0.189795918367347,0.274258219727346]
churn_87 = [0.251798561151079,0.32034632034632,0.485875706214689]
churn_30 = [0.0756013745704467,0.0733590733590734,0.11731843575419]

plt.xlabel('Dates', fontsize=20)
plt.ylabel('Churn Rate [%]', fontsize=20)
plt.xticks(x, x_labels)
plt.plot(x,churn_total, '-o',label="All segments")
plt.plot(x,churn_30, '-o',label="Segment 30")
plt.plot(x,churn_87, '-o',label="Segment 87")
plt.legend()
plt.savefig('churn.pdf',bbox_inches='tight' )
plt.show()

plt.xlabel('Dates', fontsize=20)
plt.ylabel('Churn Rate ratio', fontsize=20)
plt.xticks(x, x_labels)
print(np.asarray(churn_87)/np.asarray(churn_30))
plt.plot(x,np.asarray(churn_87)/np.asarray(churn_30), '-o',label="Segment 87 / Segment 30")
plt.legend()
plt.savefig('churn_ratio.pdf',bbox_inches='tight' )
plt.show()
