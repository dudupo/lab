# constants :
from constants import DATAPATH as datapath

# math :
from numpy import *

# ploting :
from matplotlib import pyplot as plt



# ~ loading data : ~ #
def getdata():
    dtype = [('Col{0}'.format(i),'f8') for i in range(6)]
    return genfromtxt(datapath, dtype=dtype,
     names = ["point" ,"measuringround" ,"H" ,"Rx",
     "Ry","R"] , delimiter=None)
# --------------- #

def getangle(p , r):
    ret = arccos( inner(p , r) / (linalg.norm(p) * linalg.norm(r))  )
    return ret if str(ret) != "nan" else 0

if __name__ == "__main__" :
    data = getdata()
    #plt.plot(data["Rx"],data["Ry"],'ro')

    # for y0 in range(-1,2):
    #     for (x,y) in zip(data["Rx"] , data["Ry"]):
    #         plt.plot([0,x],[y0,y] , ''+{-1:'r',0:'b',1:'c'}[y0])

    groups = { }
    for (measuringround, H, x, y) in zip(data["measuringround"], data["H"],
      data["Rx"], data["Ry"]):
        if (measuringround, H) not in groups:
            groups[(measuringround, H)] = []
        groups[(measuringround, H)].append((x , y ))


    I = 0
    for key , group in groups.items():
        print("{0:2}.group : {1} ~> {2}".format(I, key, group))
        I += 1

    def functionF( pointsVec ,groups):
        groups_distances = [ [] for _ in groups.items() ]
        groups_var = [ 0 for _ in groups ]
        xdir_vec = array([1 , 0] , dtype="f8")
        for i, ((x0 , y0) , group) in enumerate(zip(pointsVec, groups.values())):
            p = array([x0 , y0] , dtype="f8")
            for (x , y) in group:
                r = array([x , y]   , dtype="f8")
                groups_distances[i].append( getangle(r - p , xdir_vec ) )
            groups_var[i] = var( groups_distances[i])
        return var(groups_var)

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
