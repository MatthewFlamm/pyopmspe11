-- Copyright (C) 2023 NORCE
-- This deck was generated by pyopmspe11 https://github.com/OPM/pyopmspe11
----------------------------------------------------------------------------
RUNSPEC
----------------------------------------------------------------------------
DIMENS 
${dic['noCells'][0]} ${dic['noCells'][1]} ${dic['noCells'][2]} /

EQLDIMS
/

TABDIMS
${dic['noSands']} 1* ${dic['tabdims']} /

% if dic["co2store"] == "gaswater":
WATER
% else:
OIL
% endif
GAS
CO2STORE
% if dic['model'] == 'complete':
% if dic["co2store"] == "gaswater":
DISGASW
VAPWAT
% if dic["flow_version"] != "2023.10" and (dic["diffusion"][0] + dic["diffusion"][1]) > 0:
DIFFUSE
% endif
% else:
DISGAS
VAPOIL
% if (dic["diffusion"][0] + dic["diffusion"][1]) > 0:
DIFFUSE
% endif
% endif
THERMAL
% endif

METRIC

START
1 'JAN' 2025 /

% if sum(dic['radius']) > 0:
WELLDIMS
${len(dic['wellijk'])} ${dic['noCells'][2]} ${len(dic['wellijk'])} ${len(dic['wellijk'])} /
% endif

UNIFIN
UNIFOUT
----------------------------------------------------------------------------
GRID
----------------------------------------------------------------------------
INIT
%if dic["grid"] == 'corner-point':
INCLUDE
'GRID.INC' /
%elif dic["grid"] == 'tensor':
INCLUDE
'DX.INC' /
DY 
${dic['noCells'][0]*dic['noCells'][1]*dic['noCells'][2]}*${dic['ymy'][1]} /
INCLUDE
'DZ.INC' /
TOPS
${dic['noCells'][0]}*0.0 /
%else:
INCLUDE
'DX.INC' /
DY 
${dic['noCells'][0]*dic['noCells'][1]*dic['noCells'][2]}*${dic['dsize'][1]} /
DZ 
${dic['noCells'][0]*dic['noCells'][1]*dic['noCells'][2]}*${dic['dsize'][2]} /
TOPS
${dic['noCells'][0]}*0.0 /
%endif

INCLUDE
'PERMX.INC' /

COPY 
PERMX PERMY /
PERMX PERMZ /
/

% if dic["kzMult"] > 0:
MULTIPLY
PERMZ ${dic["kzMult"]} /
/
% endif

INCLUDE
'PORO.INC' /

% if dic['model'] == 'complete':
INCLUDE
'THCONR.INC' /
% endif

% if dic['model'] == 'complete' and dic["flow_version"] != "2023.10":
BCCON 
1 1 ${dic['noCells'][0]} 1 1 1 1 Z-/
2 1 ${dic['noCells'][0]} 1 1 ${dic['noCells'][2]} ${dic['noCells'][2]} Z/
/
% endif

% if dic["version"] == "master" and sum(dic["dispersion"]) > 0 and dic["flow_version"] != "2023.10":
INCLUDE
'DISPERC.INC' /
% endif
----------------------------------------------------------------------------
EDIT
----------------------------------------------------------------------------
INCLUDE
'PVBOUNDARIES.INC' /
----------------------------------------------------------------------------
PROPS
----------------------------------------------------------------------------
INCLUDE
'TABLES.INC' /

% if dic['model'] == 'complete':
% if dic["co2store"] == "gaswater":
% if dic["flow_version"] != "2023.10" and (dic["diffusion"][0] + dic["diffusion"][1]) > 0:
DIFFAWAT
${dic["diffusion"][0]} ${dic["diffusion"][0]} /

DIFFAGAS
${dic["diffusion"][1]} ${dic["diffusion"][1]} /
% endif
% else:
% if (dic["diffusion"][0] + dic["diffusion"][1]) > 0:
DIFFC
18.01528E-3 44.018E-3 ${dic["diffusion"][1]} ${dic["diffusion"][1]} ${dic["diffusion"][0]} ${dic["diffusion"][0]} /
% endif
% endif

SPECROCK
% for i in range(dic['noSands']): 
${dic["temperature"][1]} ${dic["rockExtra"][0]}
${dic["temperature"][0]} ${dic["rockExtra"][0]} /
% endfor
% endif
----------------------------------------------------------------------------
REGIONS
----------------------------------------------------------------------------
INCLUDE
'SATNUM.INC' /
INCLUDE
'FIPNUM.INC' /
----------------------------------------------------------------------------
SOLUTION
---------------------------------------------------------------------------
EQUIL
${dic['dims'][2]-dic['datum']} ${dic['pressure']/1.E5} ${0 if dic["co2store"] == "gaswater" else dic['dims'][2]} 0 0 0 1 1 0 /

RPTRST
% if dic['model'] == 'immiscible': 
'BASIC=2' FLOWS FLORES DEN/
% else:
'BASIC=2' DEN ${'PCGW' if dic["co2store"] == "gaswater" else ''}/
% endif

% if dic['model'] == 'complete':
% if dic["co2store"] == "gasoil":
RSVD
0   0.0
${dic['dims'][2]} 0.0 /

RVVD
0   0.0
${dic['dims'][2]} 0.0 /
% endif

RTEMPVD
0   ${dic["temperature"][1]}
${dic['dims'][2]} ${dic["temperature"][0]} /
%endif
----------------------------------------------------------------------------
SUMMARY
----------------------------------------------------------------------------
PERFORMA
FGIP
FGIR
FGIT
RGCDI
/
RGCDM
/
RGIP
/
RWCD
/
WBHP
/
WGIR
/
WGIT
/
${'BPR' if dic["co2store"] == "gasoil" else 'BWPR'}
% for sensor in dic["sensorijk"]: 
${sensor[0]+1} ${sensor[1]+1} ${sensor[2]+1} /
% endfor
/
----------------------------------------------------------------------------
SCHEDULE
----------------------------------------------------------------------------
RPTRST
% if dic['model'] == 'immiscible': 
'BASIC=2' FLOWS FLORES DEN/
% else:
'BASIC=2' DEN RESIDUAL ${'PCGW' if dic["co2store"] == "gaswater" else ''}/
% endif

% if dic['model'] == 'complete' and dic["flow_version"] != "2023.10":
BCPROP
1 THERMAL /
2 THERMAL /
/
% endif

% if sum(dic['radius']) > 0:
WELSPECS
% for i in range(len(dic['wellijk'])):
% if dic['radius'][i] > 0:
'INJ${i}' 'G1' ${dic['wellijk'][i][0]} ${dic['wellijk'][i][1]} 1* 'GAS' ${dic['radius'][i]}/
% endif
% endfor
/
COMPDAT
% for i in range(len(dic['wellijk'])):
% if dic['radius'][i] > 0:
'INJ${i}' ${dic['wellijk'][i][0]} ${dic['wellijk'][i][1]} ${dic['wellijk'][i][2]} ${dic['wellijk'][i][2]} 'OPEN' 2* ${2.*dic['radius'][i]} /
% endif
% endfor
/
% endif

% for j in range(len(dic['inj'])):
TUNING
1e-2 ${dic['inj'][j][2] / 86400.} 1e-10 2* 1e-12/
/
/
% if max(dic['radius']) > 0:
WCONINJE
% for i in range(len(dic['wellijk'])):
% if dic['radius'][i] > 0:
% if dic['inj'][j][3+3*i] > 0:
'INJ${i}' 'GAS' ${'OPEN' if dic['inj'][j][4+3*i] > 0 else 'SHUT'}
'RATE' ${f"{dic['inj'][j][4+3*i] * 86400 / 1.86843:E}"}  1* 400/
% else:
'INJ${i}' ${'WATER' if dic['co2store'] == 'gaswater' else 'OIL'} ${'OPEN' if dic['inj'][j][4+3*i] > 0 else 'SHUT'}
'RATE' ${f"{dic['inj'][j][4+3*i] * 86400 / 998.108:E}"}  1* 400/
% endif
% endif
% endfor
/
% endif
% if min(dic['radius']) == 0:
SOURCE
% for i in range(len(dic['wellijk'])):
% if dic['radius'][i] == 0:
% if dic['inj'][j][3+3*i] > 0:
${dic['wellijk'][i][0]} ${dic['wellijk'][i][1]} ${dic['wellijk'][i][2]} GAS ${f"{dic['inj'][j][4+3*i] * 86400:E}"} 1* ${f"{dic['inj'][j][5+3*i]:E}"} /
% else:
${dic['wellijk'][i][0]} ${dic['wellijk'][i][1]} ${dic['wellijk'][i][2]} ${'WATER' if dic['co2store'] == 'gaswater' else 'OIL'} ${f"{dic['inj'][j][4+3*i] * 86400:E}"} 1* ${f"{dic['inj'][j][5+3*i]:E}"} /
% endif
% endif
% endfor
/
% endif
% if dic['model'] == 'complete' and max(dic['radius']) > 0:
WTEMP
% for i in range(len(dic['wellijk'])):
% if dic['radius'][i] > 0:
'INJ${i}' ${dic['inj'][j][5+3*i]} /
% endif
% endfor
/
% endif
TSTEP
${round(dic['inj'][j][0]/dic['inj'][j][1])}*${dic['inj'][j][1] / 86400.}
/
% endfor