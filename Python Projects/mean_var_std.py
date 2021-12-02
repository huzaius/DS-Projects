import numpy as np

def calculate(lsit):
  if len(lsit)==9:
    my_list = np.array(lsit).reshape(3,3)
    
    c_mean = my_list.mean(axis=0).tolist()
    r_mean = my_list.mean(axis=1).tolist()
    f_mean = my_list.reshape(9).mean().tolist()

    c_variance = my_list.var(axis=0).tolist()
    r_variance = my_list.var(axis=1).tolist()
    f_variance = my_list.reshape(9).var().tolist()

    c_std = my_list.std(axis=0).tolist()
    r_std = my_list.std(axis=1).tolist()
    f_std = my_list.reshape(9).std().tolist()

    c_max = my_list.max(axis=0).tolist()
    r_max = my_list.max(axis=1).tolist()
    f_max = my_list.reshape(9).max().tolist()
    
    c_min = my_list.min(axis=0).tolist()
    r_min = my_list.min(axis=1).tolist()
    f_min = my_list.reshape(9).min().tolist()

    c_sum = my_list.sum(axis=0).tolist()
    r_sum = my_list.sum(axis=1).tolist()
    f_sum = my_list.reshape(9).sum().tolist()

    calculations = {
      'mean':[c_mean,r_mean,f_mean],
      'variance':[c_variance,r_variance,f_variance],
      'standard deviation':[c_std,r_std,f_std],
      'max':[c_max,r_max,f_max],
      'min':[c_min,r_min,f_min],
      'sum':[c_sum,r_sum,f_sum]

    }
    return calculations

  else:
    raise ValueError("List must contain nine numbers.")

  