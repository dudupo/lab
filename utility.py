

from constants import DATAPATH as datapath

# math :
from numpy import *
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
# ~ loading data : ~ #
def getdata():
    dtype = [('Col{0}'.format(i),'f8') for i in range(6)]
    return genfromtxt(datapath, dtype=dtype,
     names = ["point" ,"measuringround" ,"H" ,"Rx",
     "Ry","R"] , delimiter=None)

def getangle(p , r):
    ret = arccos( inner(p , r) / (linalg.norm(p) * linalg.norm(r))  )
    return ret if str(ret) != "nan" else 0


def getdataset( ):
    namesList =[
        ["point", "measuringround", "H", "Rx", "Ry", "R"],
        ["R" , "H"],["R" , "H"],["R" , "H"]
    ]
    datasets = []
    for _datapath , _names in zip(datapath, namesList)  :
        datasets.append( pd.read_csv( _datapath , sep="\t", header=None, names=_names))
    return datasets

#--------------------------------------#

def hist(ds, col, _hist):
    pass

def plot_data_set(ds):
    #sns.set(style="darkgrid")
    sns.set_context("paper")
    sns.lineplot( x = ds.H , y=ds.R , ci=100)
    sns.scatterplot(x = ds.H , y=ds.R, ci=100)
    #sns.pointplot(x = ds.H , y=ds.R)
