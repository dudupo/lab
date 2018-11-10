

from utility import getdataset , plot_data_set
import matplotlib.pyplot as plt

def test_extracting_input ():
    ds1 , ds2 = getdataset()
    print(ds1)
    print(ds2)

def test_plot_data_set():
    ds1 , ds2 = getdataset()
    plot_data_set( ds2  )
    plot_data_set( ds1[ds1.measuringround == 1]  )
    plot_data_set( ds1[ds1.measuringround == 2]  )

if __name__ == '__main__' :
    test_extracting_input()
    test_plot_data_set()
    plt.show()
