function [rnewaparc, roigroups]=UBE3A_PVC_AssignFreeSurferROIs_c_new_arranged(raparc,rsuvr)    % input in function raparc (MRI segmenation, PET)

% is there a difference btw. version 5.3 and version 6 of freesurfer
% regarding the ColorLUT? --> no difference

% This assigns ROIs from freesurfer new numerical values counting up from 1
% depending on which ROI group it is assigned to

rnewaparc=zeros(length(rsuvr),1);

PET_threshold = 0; % I think it is not good practise to introduce a threshold here...

%% Cortex (GM)

% 1: L_entorhinal
roigroups{1}.name=['L entorhinal']; roigroups{1}.ind=1;
ind=find(raparc==1006 & rsuvr>PET_threshold);
rnewaparc(ind)=1.*ones(length(ind),1);

% 2: R_entorhinal
roigroups{2}.name=['R entorhinal']; roigroups{2}.ind=2;
ind=find(raparc==2006 & rsuvr>PET_threshold);
rnewaparc(ind)=2.*ones(length(ind),1);

% 3: L_parahippocampal
roigroups{3}.name=['L parahippocampal']; roigroups{3}.ind=3;
ind=find(raparc==1016 & rsuvr>PET_threshold);
rnewaparc(ind)=3.*ones(length(ind),1);

% 4: R_parahippocampal
roigroups{4}.name=['R parahippocampal']; roigroups{4}.ind=4;
ind=find(raparc==2016 & rsuvr>PET_threshold);
rnewaparc(ind)=4.*ones(length(ind),1);

% 5: L_fusiform
roigroups{5}.name=['L fusiform']; roigroups{5}.ind=5;
ind=find(raparc==1007 & rsuvr>PET_threshold);
rnewaparc(ind)=5.*ones(length(ind),1);

% 6: R_fusiform
roigroups{6}.name=['R fusiform']; roigroups{6}.ind=6;
ind=find(raparc==2007 & rsuvr>PET_threshold);
rnewaparc(ind)=6.*ones(length(ind),1);

% 7: L_lingual
roigroups{7}.name=['L lingual']; roigroups{7}.ind=7;
ind=find(raparc==1013 & rsuvr>PET_threshold);
rnewaparc(ind)=7.*ones(length(ind),1);

% 8: R_lingual
roigroups{8}.name=['R lingual']; roigroups{8}.ind=8;
ind=find(raparc==2013 & rsuvr>PET_threshold);
rnewaparc(ind)=8.*ones(length(ind),1);

% 9: L_middletemporal
roigroups{9}.name=['L middletemporal']; roigroups{9}.ind=9;
ind=find(raparc==1015 & rsuvr>PET_threshold);
rnewaparc(ind)=9.*ones(length(ind),1);

% 10: R_middletemporal
roigroups{10}.name=['R middletemporal']; roigroups{10}.ind=10;
ind=find(raparc==2015 & rsuvr>PET_threshold);
rnewaparc(ind)=10.*ones(length(ind),1);

% 11: L_caudantcing
roigroups{11}.name=['L caudantcing']; roigroups{11}.ind=11;
ind=find(raparc==1002 & rsuvr>PET_threshold);
rnewaparc(ind)=11.*ones(length(ind),1);

% 12: R_caudantcing
roigroups{12}.name=['R caudantcing']; roigroups{12}.ind=12;
ind=find(raparc==2002 & rsuvr>PET_threshold);
rnewaparc(ind)=12.*ones(length(ind),1);

% 13: L_rostantcing
roigroups{13}.name=['L rostantcing']; roigroups{13}.ind=13;
ind=find(raparc==1026 & rsuvr>PET_threshold);
rnewaparc(ind)=13.*ones(length(ind),1);

% 14: R_rostantcing
roigroups{14}.name=['R rostantcing']; roigroups{14}.ind=14;
ind=find(raparc==2026 & rsuvr>PET_threshold);
rnewaparc(ind)=14.*ones(length(ind),1);

% 15: L_postcing
roigroups{15}.name=['L postcing']; roigroups{15}.ind=15;
ind=find(raparc==1023 & rsuvr>PET_threshold);
rnewaparc(ind)=15.*ones(length(ind),1);

% 16: R_postcing
roigroups{16}.name=['R postcing']; roigroups{16}.ind=16;
ind=find(raparc==2023 & rsuvr>PET_threshold);
rnewaparc(ind)=16.*ones(length(ind),1);

% 17: L_isthmuscing
roigroups{17}.name=['L isthmuscing']; roigroups{17}.ind=17;
ind=find(raparc==1010 & rsuvr>PET_threshold);
rnewaparc(ind)=17.*ones(length(ind),1);

% 18: R_isthmuscing
roigroups{18}.name=['R isthmuscing']; roigroups{18}.ind=18;
ind=find(raparc==2010 & rsuvr>PET_threshold);
rnewaparc(ind)=18.*ones(length(ind),1);

% 19: L_insula
roigroups{19}.name=['L insula']; roigroups{19}.ind=19;
ind=find(raparc==1035 & rsuvr>PET_threshold);
rnewaparc(ind)=19.*ones(length(ind),1);

% 20: R_insula
roigroups{20}.name=['R insula']; roigroups{20}.ind=20;
ind=find(raparc==2035 & rsuvr>PET_threshold);
rnewaparc(ind)=20.*ones(length(ind),1);

% 21: L_inferiortemporal
roigroups{21}.name=['L inferiortemporal']; roigroups{21}.ind=21;
ind=find(raparc==1009 & rsuvr>PET_threshold);
rnewaparc(ind)=21.*ones(length(ind),1);

% 22: R_inferiortemporal
roigroups{22}.name=['R inferiortemporal']; roigroups{22}.ind=22;
ind=find(raparc==2009 & rsuvr>PET_threshold);
rnewaparc(ind)=22.*ones(length(ind),1);

% 23: L_temppole
roigroups{23}.name=['L temppole']; roigroups{23}.ind=23;
ind=find(raparc==1033 & rsuvr>PET_threshold);
rnewaparc(ind)=23.*ones(length(ind),1);

% 24: R_temppole
roigroups{24}.name=['R temppole']; roigroups{24}.ind=24;
ind=find(raparc==2033 & rsuvr>PET_threshold);
rnewaparc(ind)=24.*ones(length(ind),1);






% 25: L_frontalassociationcortex SUPFR
roigroups{25}.name=['L frontalassociationcortex SUPFR']; roigroups{25}.ind=25;
ind=find(raparc==1028 & rsuvr>PET_threshold);
rnewaparc(ind)=25.*ones(length(ind),1);

% 26: R_frontalassociationcortex SUPFR
roigroups{26}.name=['R frontalassociationcortex SUPFR']; roigroups{26}.ind=26;
ind=find(raparc==2028 & rsuvr>PET_threshold);
rnewaparc(ind)=26.*ones(length(ind),1);

% 27: L_frontalassociationcortex FPORB
roigroups{27}.name=['L frontalassociationcortex FPORB']; roigroups{27}.ind=27;
ind=find((raparc==1012 | raparc==1014 | raparc==1032) & rsuvr>PET_threshold);
rnewaparc(ind)=27.*ones(length(ind),1);

% 28: R_frontalassociationcortex FPORB
roigroups{28}.name=['R frontalassociationcortex FPORB']; roigroups{28}.ind=28;
ind=find((raparc==2012 | raparc==2014 | raparc==2032) & rsuvr>PET_threshold);
rnewaparc(ind)=28.*ones(length(ind),1);

% 29: L_frontalassociationcortex MIDFR
roigroups{29}.name=['L frontalassociationcortex MIDFR']; roigroups{29}.ind=29;
ind=find((raparc==1003 | raparc==1027) & rsuvr>PET_threshold);
rnewaparc(ind)=29.*ones(length(ind),1);

% 30: R_frontalassociationcortex MIDFR
roigroups{30}.name=['R frontalassociationcortex MIDFR']; roigroups{30}.ind=30;
ind=find((raparc==2003 | raparc==2027) & rsuvr>PET_threshold);
rnewaparc(ind)=30.*ones(length(ind),1);

% 31: L_frontalassociationcortex PARSFR
roigroups{31}.name=['L frontalassociationcortex PARSFR']; roigroups{31}.ind=31;
ind=find((raparc==1018 | raparc==1019 | raparc==1020) & rsuvr>PET_threshold);
rnewaparc(ind)=31.*ones(length(ind),1);

% 32: R_frontalassociationcortex PARSFR
roigroups{32}.name=['R frontalassociationcortex PARSFR']; roigroups{32}.ind=32;
ind=find((raparc==2018 | raparc==2019 | raparc==2020) & rsuvr>PET_threshold);
rnewaparc(ind)=32.*ones(length(ind),1);






% 33: L_lateraloccipital
roigroups{33}.name=['L lateraloccipital']; roigroups{33}.ind=33;
ind=find(raparc==1011 & rsuvr>PET_threshold);
rnewaparc(ind)=33.*ones(length(ind),1);

% 34: R_lateraloccipital
roigroups{34}.name=['R lateraloccipital']; roigroups{34}.ind=34;
ind=find(raparc==2011 & rsuvr>PET_threshold);
rnewaparc(ind)=34.*ones(length(ind),1);

% 35: L_parietalsupramarginal
roigroups{35}.name=['L parietalsupramarginal']; roigroups{35}.ind=35;
ind=find(raparc==1031 & rsuvr>PET_threshold);
rnewaparc(ind)=35.*ones(length(ind),1);

% 36: R_parietalsupramarginal
roigroups{36}.name=['R parietalsupramarginal']; roigroups{36}.ind=36;
ind=find(raparc==2031 & rsuvr>PET_threshold);
rnewaparc(ind)=36.*ones(length(ind),1);

% 37: L_parietalinferior
roigroups{37}.name=['L parietalinferior']; roigroups{37}.ind=37;
ind=find(raparc==1008 & rsuvr>PET_threshold);
rnewaparc(ind)=37.*ones(length(ind),1);

% 38: R_parietalinferior
roigroups{38}.name=['R parietalinferior']; roigroups{38}.ind=38;
ind=find(raparc==2008 & rsuvr>PET_threshold);
rnewaparc(ind)=38.*ones(length(ind),1);

% 39: L_superiortemporal
roigroups{39}.name=['L superiortemporal']; roigroups{39}.ind=39;
ind=find(raparc==1030 & rsuvr>PET_threshold);
rnewaparc(ind)=39.*ones(length(ind),1);

% 40: R_superiortemporal
roigroups{40}.name=['R superiortemporal']; roigroups{40}.ind=40;
ind=find(raparc==2030 & rsuvr>PET_threshold);
rnewaparc(ind)=40.*ones(length(ind),1);

% 41: L_parietalsuperior
roigroups{41}.name=['L parietalsuperior']; roigroups{41}.ind=41;
ind=find(raparc==1029 & rsuvr>PET_threshold);
rnewaparc(ind)=41.*ones(length(ind),1);

% 42: R_parietalsuperior
roigroups{42}.name=['R parietalsuperior']; roigroups{42}.ind=42;
ind=find(raparc==2029 & rsuvr>PET_threshold);
rnewaparc(ind)=42.*ones(length(ind),1);

% 43: L_precuneus
roigroups{43}.name=['L precuneus']; roigroups{43}.ind=43;
ind=find(raparc==1025 & rsuvr>PET_threshold);
rnewaparc(ind)=43.*ones(length(ind),1);

% 44: R_precuneus
roigroups{44}.name=['R precuneus']; roigroups{44}.ind=44;
ind=find(raparc==2025 & rsuvr>PET_threshold);
rnewaparc(ind)=44.*ones(length(ind),1);

% 45: L_bankSTS
roigroups{45}.name=['L bankSTS']; roigroups{45}.ind=45;
ind=find(raparc==1001 & rsuvr>PET_threshold);
rnewaparc(ind)=45.*ones(length(ind),1);

% 46: R_bankSTS
roigroups{46}.name=['R bankSTS']; roigroups{46}.ind=46;
ind=find(raparc==2001 & rsuvr>PET_threshold);
rnewaparc(ind)=46.*ones(length(ind),1);

% 47: L_tranvtemp
roigroups{47}.name=['L tranvtemp']; roigroups{47}.ind=47;
ind=find(raparc==1034 & rsuvr>PET_threshold);
rnewaparc(ind)=47.*ones(length(ind),1);

% 48: R_tranvtemp
roigroups{48}.name=['R tranvtemp']; roigroups{48}.ind=48;
ind=find(raparc==2034 & rsuvr>PET_threshold);
rnewaparc(ind)=48.*ones(length(ind),1);

% 49: L_pericalcarine
roigroups{49}.name=['L pericalcarine']; roigroups{49}.ind=49;
ind=find(raparc==1021 & rsuvr>PET_threshold);
rnewaparc(ind)=49.*ones(length(ind),1);

% 50: R_pericalcarine
roigroups{50}.name=['R pericalcarine']; roigroups{50}.ind=50;
ind=find(raparc==2021 & rsuvr>PET_threshold);
rnewaparc(ind)=50.*ones(length(ind),1);

% 51: L_postcentral
roigroups{51}.name=['L postcentral']; roigroups{51}.ind=51;
ind=find(raparc==1022 & rsuvr>PET_threshold);
rnewaparc(ind)=51.*ones(length(ind),1);

% 52: R_postcentral
roigroups{52}.name=['R postcentral']; roigroups{52}.ind=52;
ind=find(raparc==2022 & rsuvr>PET_threshold);
rnewaparc(ind)=52.*ones(length(ind),1);

% 53: L_cuneus
roigroups{53}.name=['L cuneus']; roigroups{53}.ind=53;
ind=find(raparc==1005 & rsuvr>PET_threshold);
rnewaparc(ind)=53.*ones(length(ind),1);

% 54: R_cuneus
roigroups{54}.name=['R cuneus']; roigroups{54}.ind=54;
ind=find(raparc==2005 & rsuvr>PET_threshold);
rnewaparc(ind)=54.*ones(length(ind),1);

% 55: L_precentral
roigroups{55}.name=['L precentral']; roigroups{55}.ind=55;
ind=find(raparc==1024 & rsuvr>PET_threshold);
rnewaparc(ind)=55.*ones(length(ind),1);

% 56: R_precentral
roigroups{56}.name=['R precentral']; roigroups{56}.ind=56;
ind=find(raparc==2024 & rsuvr>PET_threshold);
rnewaparc(ind)=56.*ones(length(ind),1);

% 57: L_paracentral
roigroups{57}.name=['L paracentral']; roigroups{57}.ind=57;
ind=find(raparc==1017 & rsuvr>PET_threshold);
rnewaparc(ind)=57.*ones(length(ind),1);

% 58: R_paracentral
roigroups{58}.name=['R paracentral']; roigroups{58}.ind=58;
ind=find(raparc==2017 & rsuvr>PET_threshold);
rnewaparc(ind)=58.*ones(length(ind),1);

% 59 - cortex-lh-unkown
roigroups{59}.name=['L cortex unknown']; roigroups{59}.ind=59;
ind=find(raparc==1000 & rsuvr>PET_threshold);
rnewaparc(ind)=59.*ones(length(ind),1);

% 60 - cortex-rh-unkown
roigroups{60}.name=['R cortex unknown']; roigroups{60}.ind=60;
ind=find(raparc==2000 & rsuvr>PET_threshold);
rnewaparc(ind)=60.*ones(length(ind),1);

% 61 - cortex-lh-corpuscallosum
roigroups{61}.name=['L cortex cc']; roigroups{61}.ind=61;
ind=find(raparc==1004 & rsuvr>PET_threshold);
rnewaparc(ind)=61.*ones(length(ind),1);

% 62 - cortex-rh-corpuscallosum
roigroups{62}.name=['R cortex cc']; roigroups{62}.ind=62;
ind=find(raparc==2004 & rsuvr>PET_threshold);
rnewaparc(ind)=62.*ones(length(ind),1);


%% NUCLEI

% 63: L_caudate
roigroups{63}.name=['L caudate']; roigroups{63}.ind=63;
ind=find(raparc==11 & rsuvr>PET_threshold);
rnewaparc(ind)=63.*ones(length(ind),1);

% 64: R_caudate
roigroups{64}.name=['R caudate']; roigroups{64}.ind=64;
ind=find(raparc==50 & rsuvr>PET_threshold);
rnewaparc(ind)=64.*ones(length(ind),1);

% 65: L_putamen
roigroups{65}.name=['L putamen']; roigroups{65}.ind=65;
ind=find(raparc==12 & rsuvr>PET_threshold);
rnewaparc(ind)=65.*ones(length(ind),1);

% 66: R_putamen
roigroups{66}.name=['R putamen']; roigroups{66}.ind=66;
ind=find(raparc==51 & rsuvr>PET_threshold);
rnewaparc(ind)=66.*ones(length(ind),1);

% 67: L_pallidum
roigroups{67}.name=['L pallidum']; roigroups{67}.ind=67;
ind=find(raparc==13 & rsuvr>PET_threshold);
rnewaparc(ind)=67.*ones(length(ind),1);

% 68: R_pallidum
roigroups{68}.name=['R pallidum']; roigroups{68}.ind=68;
ind=find(raparc==52 & rsuvr>PET_threshold);
rnewaparc(ind)=68.*ones(length(ind),1);

% 69: L_accumbens
roigroups{69}.name=['L accumbens']; roigroups{69}.ind=69;
ind=find(raparc==26 & rsuvr>PET_threshold);
rnewaparc(ind)=69.*ones(length(ind),1);

% 70: R_accumbens
roigroups{70}.name=['R accumbens']; roigroups{70}.ind=70;
ind=find(raparc==58 & rsuvr>PET_threshold);
rnewaparc(ind)=70.*ones(length(ind),1);


%%

% 71: L_hippocampus
roigroups{71}.name=['L hippocampus']; roigroups{71}.ind=71;
ind=find(raparc==17 & rsuvr>PET_threshold);
rnewaparc(ind)=71.*ones(length(ind),1);

% 72: R_hippocampus
roigroups{72}.name=['R hippocampus']; roigroups{72}.ind=72;
ind=find(raparc==53 & rsuvr>PET_threshold);
rnewaparc(ind)=72.*ones(length(ind),1);

% 73: L_amygdala
roigroups{73}.name=['L amygdala']; roigroups{73}.ind=73;
ind=find(raparc==18 & rsuvr>PET_threshold);
rnewaparc(ind)=73.*ones(length(ind),1);

% 74: R_amygdala
roigroups{74}.name=['R amygdala']; roigroups{74}.ind=74;
ind=find(raparc==54 & rsuvr>PET_threshold);
rnewaparc(ind)=74.*ones(length(ind),1);

% 75: L_thalamus
roigroups{75}.name=['L thalamus']; roigroups{75}.ind=75;
ind=find(raparc==10 & rsuvr>PET_threshold);
rnewaparc(ind)=75.*ones(length(ind),1);

% 76: R_thalamus
roigroups{76}.name=['R thalamus']; roigroups{76}.ind=76;
ind=find(raparc==49 & rsuvr>PET_threshold);
rnewaparc(ind)=76.*ones(length(ind),1);

% 77 -   left-ventralDienCephalon (http://neuromorphometrics.com/Seg/html/segmentation/ventral%20diencephalon.html)
roigroups{77}.name=['L ventralDC']; roigroups{77}.ind=77;
ind=find(raparc==28 & rsuvr>PET_threshold);
rnewaparc(ind)=77.*ones(length(ind),1);

% 78 -   right-ventralDienCephalon (http://neuromorphometrics.com/Seg/html/segmentation/ventral%20diencephalon.html)
roigroups{78}.name=['R ventralDC']; roigroups{78}.ind=78;
ind=find(raparc==60 & rsuvr>PET_threshold);
rnewaparc(ind)=78.*ones(length(ind),1);


%% Cerebral white matter

% % 79: left-cerebral-white-matter
% roigroups{79}.name=['L cerebral white matter']; roigroups{79}.ind=79;
% ind=find(raparc==2 & rsuvr>PET_threshold);
% rnewaparc(ind)=79.*ones(length(ind),1); 
% 
% % 80: right-cerebral-white-matter
% roigroups{80}.name=['R cerebral white matter']; roigroups{80}.ind=80;
% ind=find(raparc==41 & rsuvr>PET_threshold);
% rnewaparc(ind)=80.*ones(length(ind),1); 


%% Corpus callosum (CC)
% cc = corpus callosum (part of white-matter)
% 251-255 = CC_posterior/mid_posterior/central/mid_anterior/anterior

% 81: hemispheric white
roigroups{81}.name=['corpus callosum']; roigroups{81}.ind=81;
ind=find((raparc==251 | raparc==252 | raparc==253 | raparc==254 | raparc==255) & rsuvr>PET_threshold);
rnewaparc(ind)=81.*ones(length(ind),1);


%% Cerebellum

% 82: superior cerebellar gray - right name?
roigroups{82}.name=['cerebellar cortex']; roigroups{82}.ind=82;
ind=find((raparc==8 | raparc==47) & rsuvr>PET_threshold);
rnewaparc(ind)=82.*ones(length(ind),1);

% 83: cerebellar white
roigroups{83}.name=['cerebellar white matter']; roigroups{83}.ind=83;
ind=find((raparc==7 | raparc==46) & rsuvr>PET_threshold);
rnewaparc(ind)=83.*ones(length(ind),1);

%% Brainstem (GM and WM)

% 84: brainstem
roigroups{84}.name=['brainstem']; roigroups{84}.ind=84;
ind=find(raparc==16 & rsuvr>PET_threshold);
rnewaparc(ind)=84.*ones(length(ind),1);

%% Other

% 85 -   left-vessel (blood)
roigroups{85}.name=['L blood_vessel']; roigroups{85}.ind=85;
ind=find(raparc==30 & rsuvr>PET_threshold);
rnewaparc(ind)=85.*ones(length(ind),1);

% 86 -   right-vessel (blood)
roigroups{86}.name=['R blood_vessel']; roigroups{86}.ind=86;
ind=find(raparc==62 & rsuvr>PET_threshold);
rnewaparc(ind)=86.*ones(length(ind),1);

% 87 -   wm-hypointensities
roigroups{87}.name=['wm hypo']; roigroups{87}.ind=87;
ind=find(raparc==77 & rsuvr>PET_threshold);
rnewaparc(ind)=87.*ones(length(ind),1);

% 88 -   non-wm-hypointensities
roigroups{88}.name=['non wm hypo']; roigroups{88}.ind=88;
ind=find(raparc==80 & rsuvr>PET_threshold);
rnewaparc(ind)= 88.*ones(length(ind),1);

% 89 -   optic-chiasm
roigroups{89}.name=['optic chiasm']; roigroups{89}.ind=89;
ind=find(raparc==85 & rsuvr>PET_threshold);
rnewaparc(ind)=89.*ones(length(ind),1);