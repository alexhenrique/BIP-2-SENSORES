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
	TIME4
	TIME5
	TIME6
	FLAG
ENDC

#DEFINE BIPE FLAG,1
;ENTRADAS
#DEFINE    SENSOR1  PORTA,0
#DEFINE    SENSOR2  PORTA,1
#DEFINE    LDR     PORTA,2  

;SAIDAS
#DEFINE    UPSEN1    PORTB,0
#DEFINE    UPSEN2    PORTB,1
#DEFINE    LAMPADA    PORTB,2
#DEFINE    SOM     PORTB,3
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
	MOVLW  B'0000111'
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
	BTFSC       SENSOR1			;SENSOR ATIVADO?
	GOTO        SENSOR1_ON		;SIM, LIGA
	GOTO        SENSOR1_OFF		;NÃO, LIMPA FLAGS	


SENSOR1_ON 
	BSF         UPSEN1
	CALL        UPSEN_A
	GOTO        MAIN2

SENSOR1_OFF
	BCF         UPSEN1
	BCF         LAMPADA
	BCF			BIPE
	GOTO 		MAIN2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN2      
	BTFSC       SENSOR2
	GOTO        SENSOR2_ON
	GOTO        SENSOR2_OFF

SENSOR2_ON 
	BSF         UPSEN2
	CALL        UPSEN_B
	GOTO        MAIN1

SENSOR2_OFF
	BCF         UPSEN2
	BCF         LAMPADA
	BCF 		BIPE
	GOTO        MAIN1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPSEN_A   
	BTFSC       SENSOR1
	CALL        ZERA
	BTFSC       SENSOR2
	CALL        ZERA
	BTFSC       SENSOR2
	BSF         UPSEN2
	BTFSC       SENSOR2
	CALL        RELE
	DECFSZ      TIME1,F
	GOTO        UPSEN_A
	DECFSZ      TIME2,F
	GOTO        UPSEN_A
	DECFSZ      TIME3,F
	GOTO        UPSEN_A
	NOP
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPSEN_B   
	BTFSC       SENSOR1
	CALL        ZERA
	BTFSC       SENSOR2
	CALL        ZERA
	BTFSC       SENSOR1
	BSF         UPSEN1				
	BTFSC       SENSOR1
	CALL        RELE
	DECFSZ      TIME1,F
	GOTO        UPSEN_B
	DECFSZ      TIME2,F
	GOTO        UPSEN_B
	DECFSZ      TIME3,F
	GOTO        UPSEN_B
	NOP
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZERA        
	MOVLW       .193			;TEMPO DA COINCIDÊNCIA
	MOVWF       TIME1
	MOVLW       .118
	MOVWF       TIME2
	MOVLW       .118
	MOVWF       TIME3
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RELE	 
	
	CALL 		BIP             ;CHAMA BIP
	BTFSS		LDR				;NÃO ACENDE LÂMPADA SE FOR DIA
	RETURN						;RETORNA DA ROTINA SEM ACENDER LAMPADA
	BSF         LAMPADA
	MOVLW       .101			;50 SEGUNDOS
	MOVWF       TIME1
	MOVLW       .167
	MOVWF       TIME2
	MOVLW       .254
	MOVWF       TIME3
	RETURN						;RETORNA DA ROTINA RELE
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BIP   
	BTFSC 		BIPE            ;BIP JÁ TOCOU?  
	RETURN  
	BSF 		BIPE			;MARCA BIP COMO TOCADO
	NOP
	BSF         SOM				;LIGA BIP
	MOVLW       .173			;TIME QUE BIP TOCA 
	MOVWF       TIME4			;1 SEGUNDO DE BIP
	MOVLW       .19
	MOVWF       TIME5
	MOVLW       .6
	MOVWF       TIME6
BIP_LASSO
	DECFSZ      TIME4,F
	GOTO        BIP_LASSO
	DECFSZ      TIME5,F
	GOTO        BIP_LASSO
	DECFSZ      TIME6,F
	GOTO        BIP_LASSO
	NOP
    BCF			SOM				;DESLIGA BIP
	RETURN						;RETORNA DA ROTINA BIP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	END
