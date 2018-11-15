# math :
from numpy import *

# ploting :
from matplotlib import pyplot as plt

from utility import getdataset , getangle
# --------------- #

def functionF( pointsVec , ds):

    groups_distances = [  ]
    groups_var = [  ]

    groups = ds.groupby( ['H' , 'measuringround' ])
    for i ,((x0 , y0) , group ) in enumerate(zip(pointsVec,groups) ) :
        p = array([x0 , y0] , dtype="f8")
        print(group[1])
        print(
         group[1][["Rx" , "Ry"]].apply(
          lambda row : getangle( p, array([row.Rx , row.Ry],dtype="f8")  ) , axis=1))
        #print(groups_var[-1])
        print(group[1][["Rx" , "Ry"]])

    return var(groups_var)

if __name__ == "__main__" :
    ds1 , ds2 , ds3 , ds4 = getdata()



    eps = 10 ** -12

    def calculatePointsVecEps( pointsVec ):
        ret = array([[ (x + eps, y + eps )
         for x, y in pointsVec ]] * len(pointsVec) * 2 ,dtype="f8")
        for i in range( len(pointsVec) ):
            ret[2*i][i][0]   += eps
            ret[2*i+1][i][1] += eps
        return ret

    def _genrateTupels(Vec):
        ret = []
        for i in range(0,len(Vec),2):
            ret.append( (Vec[i] , Vec[i+1]) )
        return array(ret , dtype="f8")

    def gradientF( pointsVec, groups):

        def _gradientF(pointsVecEpsOneVec, pointsVec, groups):
            return ( functionF( pointsVecEpsOneVec , groups ) -
             functionF( pointsVec, groups ) )/ eps

        return _genrateTupels(array([ _gradientF( W , pointsVec, groups)
          for W in calculatePointsVecEps( pointsVec) ] , dtype="f8"))


    rate = 0.5
    def getNextIterationVec( pointsVec, groups ) :
        direaction = calculatePointsVecEps( pointsVec )
        vec = direaction[0]
        for u in direaction[1:]:
            vec += u
        #print("debug:\t ->" +str(vec))
        r = gradientF( pointsVec, groups)
        #print("debug:\t ->" +str(r))
        ret = array([W*V*rate for W , V in zip (vec , r)] , dtype="f8")
        return  ret


    pointsVec =  array([( 0.0 , 0.0) for _ in range(11)]  , dtype="f8")

    def getLines(groups, pointsVec):
        Adistances , height = [] , []
        for ( (ms, H),  group ) , zeropoint in zip (groups.items() , pointsVec ):
            Adistances.append(average([linalg.norm (  point - zeropoint ) for point in group]))
            height.append(H)
        return height , Adistances

    height , distances = getLines(groups, pointsVec)

    from random import random

    pointsVec =  array([( (random() - 0.5) * 4 , (random() - 0.5) * 4) for _ in range(11)]  , dtype="f8")
    for _ in range (10):
        groups_var =  functionF( pointsVec, groups )
        print( groups_var)
        pointsVec +=  getNextIterationVec(pointsVec, groups)
        print(" the centers after {0} iterations ->\n{1} ".format(_, pointsVec))

    #----------------------------------------------------------------------------#




    height , Adistances = getLines(groups, pointsVec)
    plt.plot(height, Adistances,'bo', height, distances, 'go')
    plt.axis([min(Adistances[0],height[0]) , max(Adistances[-1],height[-1])]*2)
    plt.grid(True)
    plt.show()

    import seaborn as sns
    import pandas as pd
    sns.set()

    # Load the iris dataset
    df = pd.DataFrame(data, index=list(range(75)))
    # Plot sepal with as a function of sepal_length across days
    g = sns.lmplot(x="H", y="R", data=data)

    # Use more informative axis labels than are provided by default
    g.set_axis_labels("Sepal length (mm)", "Sepal width (mm)")
