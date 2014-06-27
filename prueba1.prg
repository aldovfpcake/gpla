SET PATH TO F:\GPLA
SET EXCLUSIVE OFF
SET DATE ITALIAN
SET PROCEDURE TO c:\gpla\classplas
OPEN DATABASE F:\gpla\pla SHARED
SELECT 0
USE L4089 AGAIN
SELECT 0
USE PLANILLA4089 NODATA
x = CREATEOBJECT("CLSPLA")

*x.chofer = "TORRES ALB"
*X.chofer = "GARCIA A"
x.chofer = "EBERLE"  
*x.chofer = "RONCATI"
*x.chofer =  "DEAN PABLO"
*x.chofer = "ACOSTA"
*x.chofer = "ESTRIBOU"
*x.chofer = "GASTON CAR"
*x.chofer = "CASTELNUOV"
*x.chofer = "MOSSELLO"
*x.chofer = "ARANDA"
*x.chofer = "RAMIREZ"
*x.chofer = "GEDES"
*x.chofer = "MAYO MARCE"
*x.chofer = "SALVAGGIO"
*x.chofer = "DRESCH"
*x.chofer = "LACHA"
*x.chofer = "NASE RENAT"
*x.chofer = "TORR PADIN"
*x.chofer = "BUSS"
*x.chofer = "VENE EDUAR"
x.mes = 2
x.ano = 2014
x.periodo = 22014
*x.agregaviaj
*x.reordenar
*x.completar
*x.actualizar
*x.actukilom
BROWSE

CLOSE TABLES all
