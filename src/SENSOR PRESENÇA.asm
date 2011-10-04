;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ARQUIVOS E DEFINIÇÕES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  #INCLUDE <P16F628A.INC>

  __CONFIG _BODEN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PAGINAÇÃO DE MEMORIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  #DEFINE      BANK0       BCF     STATUS,RP0
  #DEFINE      BANK1       BSF     STATUS,RP0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VARIAVEIS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CBLOCK 0X20
	TEMPO1
	TEMPO2
	TEMPO3
	TEMPO4
	TEMPO5
	TEMPO6
	FLAG
ENDC


#DEFINE BIPE FLAG,1
;ENTRADAS

#DEFINE    BOTAO1  PORTA,0
#DEFINE    BOTAO2  PORTA,1
#DEFINE    LDR     PORTA,2  

;SAIDAS

#DEFINE    LED1    PORTB,0
#DEFINE    LED2    PORTB,1
#DEFINE    LED3    PORTB,2
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
	MOVLW  B'00000111'
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
	BTFSC       BOTAO1			;SENSOR ATIVADO?
	GOTO        BOTAO1_OFF		;NÃO, LIMPA FLAGS	
	GOTO        BOTAO1_ON		;SIM, LIGA

BOTAO1_ON 
	BSF         LED1
	CALL        TEMP_A
	GOTO        MAIN2

BOTAO1_OFF
	BCF         LED1
	BCF         LED3
	BCF			BIPE
	GOTO 		MAIN2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN2      
	BTFSC       BOTAO2
	GOTO        BOTAO2_OFF
	GOTO        BOTAO2_ON

BOTAO2_ON 
	BSF         LED2
	CALL        TEMP_B
	GOTO        MAIN1

BOTAO2_OFF
	BCF         LED2
	BCF         LED3
	BCF 		BIPE
	GOTO        MAIN1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEMP_A   
	BTFSS       BOTAO1
	CALL        ZERA
	BTFSS       BOTAO2
	CALL        ZERA
	BTFSS       BOTAO2
	CALL        RELE
	DECFSZ      TEMPO1,F
	GOTO        TEMP_A
	DECFSZ      TEMPO2,F
	GOTO        TEMP_A
	DECFSZ      TEMPO3,F
	GOTO        TEMP_A
	NOP
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEMP_B   
	BTFSS       BOTAO1
	CALL        ZERA
	BTFSS       BOTAO2
	CALL        ZERA				
	BTFSS       BOTAO1
	CALL        RELE
	DECFSZ      TEMPO1,F
	GOTO        TEMP_B
	DECFSZ      TEMPO2,F
	GOTO        TEMP_B
	DECFSZ      TEMPO3,F
	GOTO        TEMP_B
	NOP
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZERA        
	MOVLW       .93
	MOVWF       TEMPO1
	MOVLW       .38
	MOVWF       TEMPO2
	MOVLW       .11
	MOVWF       TEMPO3
	RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RELE
	 
	BTFSS 		BIPE            ;BIP JÁ TOCOU?
	CALL 		BIP             ;CHAMA BIP
	BSF 		BIPE			;MARCA BIP COMO TOCADO
	BTFSS		LDR				;NÃO ACENDE LÂMPADA SE FOR DIA
	RETURN						;RETORNA DA ROTINA SEM ACENDER LAMPADA
	BSF         LED3
	MOVLW       .110
	MOVWF       TEMPO1
	MOVLW       .94
	MOVWF       TEMPO2
	MOVLW       .26
	MOVWF       TEMPO3
	RETURN						;RETORNA DA ROTINA RELE
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BIP       
	BSF         SOM				;LIGA BIP
	MOVLW       .173			;TEMPO QUE BIP TOCA
	MOVWF       TEMPO4
	MOVLW       .19
	MOVWF       TEMPO5
	MOVLW       .6
	MOVWF       TEMPO6

BIP_A
	DECFSZ      TEMPO4,F
	GOTO        BIP_A
	DECFSZ      TEMPO5,F
	GOTO        BIP_A
	DECFSZ      TEMPO6,F
	GOTO        BIP_A
	NOP
    BCF			SOM				;DESLIGA BIP
	RETURN						;RETORNA DA ROTINA BIP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	END
