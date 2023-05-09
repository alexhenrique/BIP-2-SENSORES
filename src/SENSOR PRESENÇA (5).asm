;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ARQUIVOS E DEFINIÇÕES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  #INCLUDE <P16F628A.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT  & _LVP_OFF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PAGINAÇÃO DE MEMORIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  #DEFINE      BANK0       BCF     STATUS,RP0
  #DEFINE      BANK1       BSF     STATUS,RP0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VARIAVEIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CBLOCK 0X20
	TIME1
	TIME2
	TIME3
ENDC


;ENTRADAS
#DEFINE    SENSOR1  PORTA,0
#DEFINE    SENSOR2  PORTA,1
#DEFINE    SENSOR3  PORTA,2
#DEFINE    SENSOR4  PORTA,6 

;SAIDAS
#DEFINE    SAIDA1    PORTB,0
#DEFINE    SAIDA2    PORTB,1
#DEFINE    SAIDA3    PORTB,2
#DEFINE    SAIDA4    PORTB,3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VETOR RESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG       	0X00
GOTO	    INICIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INTERRUPÇÃO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG 0X04
RETFIE			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INICIO DO PROGRAMA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INICIO
	CLRF  PORTA
	CLRF  PORTB
	BANK1
	MOVLW  B'01000111'
	MOVWF  TRISA
	MOVLW  B'00000000'
	MOVWF  TRISB
	MOVLW  B'10000000'
	MOVWF  OPTION_REG
	MOVLW  B'00000000'
	MOVWF  INTCON
	BANK0
	MOVLW  B'00000111'
	MOVWF  CMCON

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ROTINA PRINCIPAL DO PROGRAMA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN1
	BTFSC       SENSOR1			;
	GOTO        SENSOR1_ON		;
	GOTO        SENSOR1_OFF		;	
	
SENSOR1_ON 
	BSF         SAIDA1
	CALL        CHAVES
	GOTO        MAIN2

SENSOR1_OFF
	BCF         SAIDA1
	BCF         SAIDA2
	BCF         SAIDA3
	BCF			SAIDA4
	GOTO 		MAIN2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN2      
	BTFSC       SENSOR2
	GOTO        SENSOR2_ON
	GOTO        SENSOR2_OFF

SENSOR2_ON 
	BSF         SAIDA2
	CALL        CHAVES
	GOTO        MAIN3

SENSOR2_OFF
	BCF         SAIDA1
	BCF         SAIDA2
	BCF         SAIDA3
	BCF			SAIDA4
	GOTO        MAIN3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN3      
	BTFSC       SENSOR3
	GOTO        SENSOR3_ON
	GOTO        SENSOR3_OFF

SENSOR3_ON 
	BSF         SAIDA3
	CALL        CHAVES
	GOTO        MAIN4

SENSOR3_OFF
	BCF         SAIDA1
	BCF         SAIDA2
	BCF         SAIDA3
	BCF			SAIDA4
	GOTO        MAIN4	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAIN4      
	BTFSC       SENSOR4
	GOTO        SENSOR4_ON
	GOTO        SENSOR4_OFF

SENSOR4_ON 
	BSF         SAIDA4
	CALL        CHAVES
	GOTO        MAIN1

SENSOR4_OFF
	BCF         SAIDA1
	BCF         SAIDA2
	BCF         SAIDA3
	BCF			SAIDA4
	GOTO        MAIN1	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHAVES
	BTFSC       SENSOR1
	CALL        ZERA
	BTFSC       SENSOR2
	CALL        ZERA
	BTFSC       SENSOR3
	CALL        ZERA
	BTFSC       SENSOR4
	CALL        ZERA
	BTFSC       SENSOR1
	BSF         SAIDA1
	BTFSC       SENSOR2
	BSF         SAIDA2
	BTFSC       SENSOR3
	BSF         SAIDA3
	BTFSC       SENSOR4
	BSF         SAIDA4
	DECFSZ      TIME1,F
	GOTO        CHAVES
	DECFSZ      TIME2,F
	GOTO        CHAVES
	DECFSZ      TIME3,F
	GOTO        CHAVES
RETURN	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZERA        
	MOVLW       .93			
	MOVWF       TIME1
	MOVLW       .38
	MOVWF       TIME2
	MOVLW       .11
	MOVWF       TIME3
RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	


	END
