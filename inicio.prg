set exclusive off
set date italian
set century on
set dele on
set path to c:\GPLA;f:\gpla
set talk off
set sysmenu to
open DATABASE F:\gpla\pla
Public clspla
SET CLASSLIB TO F:\gpla\clases\barrah
clspla = createobject("planilla4089")
public vvchof,vvperiod
VVCHOF = " "
VVPERIOD = 0
_SCREEN.WINDOWSTATE = 2
SELECT 0
USE INTERCAM
DO MENPLA.MPR
*do form selecondu
READ EVENTS
