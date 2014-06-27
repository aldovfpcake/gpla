DEFINE CLASS CLSPLA AS Custom
chofer = "  "
mes = 0
ano = 0
periodo = 0


****************************
PROCEDURE AGREGAVIAJ
****************************

messale  = this.mes
anosale  =  this.ano
*mesllega = 0
*do case
*    case this.mes = 1
*         messale = 12   
*         anosale = (this.ano - 1)
*    case this.mes > 1
*         messale = this.mes    
*         anosale = this.ano    
*endcase

vvfechsa = CTOD("1"+ "-"+ str(messale,2)+ "-" + str(anosale,4))
vvhasta  = CTOD("28"+ "-"+ str(messale,2)+ "-" + str(anosale,4))

SELECT * FROM F:\FOXPRO2\TRANS12.DAT\CONSTAN WHERE CHOFER = this.CHOFER .AND. BETWEEN (FECHA,vvfechsa,vvhasta) INTO CURSOR PLNICH

SELE PLNICH
IF RECCOUNT() = 0
   messagebox( "Error",1, "No hay registros")
endif
GO TOP
orden = 2
DO WHILE .NOT. EOF()
    VVEXIST = 0
    VVREG = 0
    SELE PLANILLA4089
    SCAN FOR CONSTAN = PLNICH.CONSTAN
      VVEXIST = 1   
      WAIT WINDOW "CONSTANCIA EXISTENTE" + STR(CONSTAN,8) 
    ENDSCAN
       
   IF VVEXIST = 0
      INSERT INTO PLANILLA4089 (SERIE,CONSTAN,FECSAL,FECDEST,ORIGEN,DESTINO,CHOFER,PERIODO,VALOR)VALUES(PLNICH.SERIE,PLNICH.CONSTAN,PLNICH.FECSAL,PLNICH.FECDEST,;
      PLNICH.ORIGEN,PLNICH.DESTINO,this.chofer,this.periodo,ORDEN)
      ORDEN = ORDEN + 2
   ENDIF
   SELE PLNICH
   SKIP
ENDDO
ENDPROC



*****************************
PROCEDURE REORDENAR
*************************
SELECT planilla4089
VVCHOF = this.chofer
VVPERIOD = this.periodo
REQUERY()


orden = 2
create cursor vuelta(fecsal d(8),origen c(10),fecdest d(8),destino c(10),constan n(8),orden n(2))
SELECT planilla4089
SCAN
    *UPDATE L4089 SET valor = orden WHERE chofer = this.chofer .and. periodo = this.periodo
    replace valor WITH orden
    orden = orden +2

ENDSCAN
BROWSE
GO TOP
XORDEN  = 3
SELECT planilla4089
do while .not. eof()
 *  WAIT WINDOW STR(PLANILLA4089.CONSTAN,4)
   vvdestino = planilla4089.destino
   vvfsale   = planilla4089.fecdest
   skip
   vvorigen = planilla4089.origen
   vvfelle  = planilla4089.fecsal
   *if planilla4089.constan <> 0
   *   insert into planilla4089(serie,origen,destino,fecsal,fecdest,chofer,periodo) values(int(1000*rand()),vvdestino,vvorigen,vvfsale,vvfelle,vvchof,vvperiod)
   *endif 
    sele vuelta
    vvorden = xorden 
    append blank
    replace fecsal  with vvfsale
    replace fecdest with planilla4089.fecdest
    replace origen  with vvdestino
    replace destino with vvorigen
    replace constan with planilla4089.constan  
    replace  orden  WITH vvorden
    xorden = xorden + 2
    sele planilla4089   
enddo
SELECT vuelta
browse
vvorigen  = " "
vvdestino = " "
vvfsale  = CTOD("  -  -  ")
vvfelle  = CTOD("  -  -  ")
GO TOP
ORDEN  = 3
SELECT planilla4089
INDEX on STR(valor,2) TO F:\gpla\xpla
*SET INDEX TO  f:\gpla\xpla
SCAN
   APPEND BLANK
   replace valor   WITH orden
   replace periodo WITH this.periodo
   replace chofer  WITH this.chofer
   replace serie   WITH int(1000*rand())
   orden = orden +2 
ENDSCAN
SELECT PLANILLA4089
GO TOP
BROWSE

SELECT vuelta
DO WHILE .not.eof()
   SELECT planilla4089
   SEEK STR(vuelta.orden,2)
   IF .not. EOF()
       replace fecsal  WITH vuelta.fecsal
       replace origen  WITH vuelta.origen
       replace fecdest WITH vuelta.fecdest
       replace destino WITH vuelta.destino
       replace constan WITH vuelta.constan
   ENDIF
   SELECT vuelta
   skip    

ENDDO

GO TOP

SCAN
  IF origen = destino
     DELETE
  ENDIF   

ENDSCAN

SET DELETED ON
GO top

SELECT planilla4089
browse   


ENDPROC











*****************************
PROCEDURE COMPLETAR
****************************
sele planilla4089
go top
vvorigen  = " "
vvdestino = " "
vvfsale   = date()
vvfelle  = date()  

create cursor vuelta(fecsal d(8),origen c(10),fecdest d(8),destino c(10),constan n(8))
SELE PLANILLA4089
VVCHOF = this.chofer
VVPERIOD = this.periodo
REQUERY()
GO TOP
BROWSE
do while .not. eof()
   WAIT WINDOW STR(PLANILLA4089.CONSTAN,4)
   vvdestino = planilla4089.destino
   vvfsale   = planilla4089.fecdest
   skip
   vvorigen = planilla4089.origen
   vvfelle  = planilla4089.fecsal
   *if planilla4089.constan <> 0
   *   insert into planilla4089(serie,origen,destino,fecsal,fecdest,chofer,periodo) values(int(1000*rand()),vvdestino,vvorigen,vvfsale,vvfelle,vvchof,vvperiod)
   *endif 
   if vvorigen <> vvdestino  
      sele vuelta
      append blank
      replace fecsal  with vvfsale
      replace fecdest with planilla4089.fecdest
      replace origen  with vvdestino
      replace destino with vvorigen
      replace constan with planilla4089.constan  
   endif
   sele planilla4089   
enddo

sele vuelta
GO TOP
do while .not. eof()
    insert into planilla4089(serie,origen,destino,fecsal,fecdest,chofer,periodo,constan) values(int(1000*rand()),vuelta.origen,vuelta.destino,vuelta.fecsal,vuelta.fecdest,this.chofer,this.periodo,vuelta.constan)
    sele vuelta 
    skip
enddo
sele  vuelta
use
SELECT PLANILLA4089
ENDPROC


*************************
PROCEDURE ACTUALIZAR
*********************
sele planilla4089
vvorigen = " "
vvkmn    = 0
vvkms100 = 0
VVCHOF   = this.chofer
VVPERIOD = this.periodo
REQUERY()
GO TOP
do while .not. eof()
   vvdiasem = "  "
   vvorigen = origen
   vvfech = cdow(fecdest)
   if empty(dialle)
      replace dialle with diasem(fecdest)
    endif
   if empty(diasal)
      replace diasal with diasem(fecsal)
   endif
   skip
   if origen = vvorigen
      wait window "Incosistencia  "
      replace origen with "Error"
   endif   
   
     
enddo   
*SUM KMSCU TO VVKMN
*SUM KMS100 TO VVKMS100
   
this.actukilom     
ENDPROC


***************************
PROCEDURE ACTUKILOM
**************************
SELECT PLANILLA4089
VVCHOF   = this.chofer
VVPERIOD = this.periodo
REQUERY()
GO TOP
DO WHILE .NOT. EOF()
   IF ORIGEN = "MONTEVIDEO"  OR  DESTINO = "MONTEVIDEO"
        REPLACE PLANILLA4089.CRUCE WITH 1 
   ENDIF 
   SELECT  * FROM TVALVI WHERE ORIGEN = PLANILLA4089.ORIGEN .AND. DESTINO = PLANILLA4089.DESTINO;
   INTO CURSOR TABLA
   SELE TABLA
   IF RECCOUNT() = 0
        * MESSAGEBOX( "No se Encuentra distancia "+PLANILLA4089.ORIGEN +" "+PLANILLA4089.DESTINO ,1,"Atención")    
        * DO FORM ACTUTABLA
    
   ElSE
        IF PLANILLA4089.KMSCU = 0 
          REPLACE PLANILLA4089.KMSCU WITH TABLA.KILOM
       ENDIF
   ENDIF
   SELE PLANILLA4089
   SKIP
ENDDO 
ENDPROC






















ENDDEFINE









