-- Copyright (C) 2023 NORCE

COORD
% for j in range(dic['noCells'][1] + 1):
% for i in range(dic['noCells'][0] + 1):
${f"{dic['xmx'][i]}"} ${f"{dic['ymy'][j]}"} 0.0 ${f"{dic['xmx'][i]}"} ${f"{dic['ymy'][j]}"} 0.0
% endfor
% endfor
/

ZCORN
% for j in range(dic['noCells'][1]):
% for i in range(dic['noCells'][0]):
${f"{dic['elevation']-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% for i in range(dic['noCells'][0]):
${f"{dic['elevation']-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% endfor
% for k in range(dic['noCells'][2] - 1):
% for h in range(2):
% for j in range(dic['noCells'][1]):
% for i in range(dic['noCells'][0]):
 ${f"{dic['elevation']+dic['zcor'][(i * (dic['noCells'][2] + 1)) + k + 1]-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']+dic['zcor'][((i + 1) * (dic['noCells'][2] + 1)) + k + 1]-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% for i in range(dic['noCells'][0]):
 ${f"{dic['elevation']+dic['zcor'][(i * (dic['noCells'][2] + 1)) + k + 1]-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']+dic['zcor'][((i + 1) * (dic['noCells'][2] + 1)) + k + 1]-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% endfor
% endfor
% endfor
% for j in range(dic['noCells'][1]):
% for i in range(dic['noCells'][0]):
 ${f"{dic['elevation']+dic['dims'][2]-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']+dic['dims'][2]-dic['elevation']*(1.-(dic['ymy'][j]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% for i in range(dic['noCells'][0]):
 ${f"{dic['elevation']+dic['dims'][2]-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"} ${f"{dic['elevation']+dic['dims'][2]-dic['elevation']*(1.-(dic['ymy'][j+1]/(0.5*dic['dims'][1])-1)**2.)-dic['ymy'][j+1]*dic['backElevation']/dic['dims'][1]}"}
% endfor
% endfor
/