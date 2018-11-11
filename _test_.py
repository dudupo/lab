
from lab import functionF
from utility import getdataset , plot_data_set
import matplotlib.pyplot as plt

def test_extracting_input ():
    ds1 , ds2  , ds3 , ds4 = getdataset()
    print(ds1)
    print(ds2)
    print(ds3)
    print(ds4)

    g = ds1.groupby( ['H' , 'measuringround' ])
    for _ in g :
        print(_)

def test_plot_data_set():
    ds1 , ds2 , ds3 , ds4 = getdataset()
    plot_data_set( ds2  )
    plt.pause(0.1)
    plot_data_set( ds1[ds1.measuringround == 1]  )
    plt.pause(0.1)
    plot_data_set( ds1[ds1.measuringround == 2]  )
    plt.pause(0.1)
    plot_data_set( ds3  )
    plt.pause(0.1)
    plot_data_set( ds4  )
def test_functionF() :
    ds1 , ds2 , ds3 , ds4 = getdataset()
    print(ds1)


if __name__ == '__main__' :
    plt.show()
    test_extracting_input()
    test_plot_data_set()
    plt.show()
