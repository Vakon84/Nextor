;2006/10/08
;1chip MSX�p

;2005/12/16
;AMD41�Ή�

;SD/MMC�A�N�Z�X���[�`���܂߂�
;2005/06/21

;����MSX�p�i����RAM�f�B�X�N�ASPC�֌W�폜�j
;2005/06/06

;�\�[�X�R�[�h�̐���
;SD/MMC��p
;2005/05/16

;����MSX�p
;2004/02/14



	ORG	07417H

KERNEL	equ	4969h		;bank3=5897h
DOSBK	equ	00h		;bank3=06h
TBLBK	equ	87h		;bank3=81h
SLTWRK	equ	4DD8h		;bank3=5FC2h
MEGFUN	EQU	07FCDh
	

;**********************************************	
;����:  CK_SPC
;�@�\:  �p�[�e�B�V�����e�[�u���𓾂�
;����:  A=���[�J���ȃh���C�u�ԍ�
;�o��:  IX=�p�[�e�B�V�����e�[�u���̃A�h���X
;���l:�@����AF��AF'�Ƃ��ĕۑ������
;***********************************************

CK_SPC:	JR	CK_SUB		;7417
	DB	74h		;7419
CK_SUB:	EXX			;741A
	LD	L,A		;741B DOS�h���C�u0�`�@���zFD 40�`
	EX	AF,AF'		;741C
	ADD	HL,HL		;741D
	ADD	HL,HL		;741E
	ADD	HL,HL		;741F
	ADD	HL,HL		;7420
	BIT	2,H		;7421
	LD	H,07FH		;7423  
	JR	Z,CK_DON		;7425
	DEC	H		;7427�@���zFD�̃e�[�u����7E00h�`
CK_DON:	LD	A,(HL)		;7428
	PUSH	HL		;7429
	POP	IX		;742A
	EXX			;742C
	SUB	0FFh
	RET	NC
	DEC	A
	RET			;7431

;***********************************************
;����:  CK_EFD	
;�@�\:  ���zFD�g�p���A�p�[�e�B�V�����e�[�u���𓾂�
;����:�@A=���[�J���ȃh���C�u�ԍ�
;�o��:�@IX=�p�[�e�B�V�����e�[�u���̃A�h���X
;***********************************************


CK_EFD:	EXX			;7432
	LD	C,A		;7433
	EX	AF,AF'		;7434
	DI			;7435
	LD	A,02H		;7436
	OUT	(099H),A	;7438
	LD	A,08FH		;743A
	OUT	(099H),A	;743C
CK_VDP:	IN	A,(099H)	;743E
	AND	081H		;7440
	DEC	A		;7442
	JR	Z,CK_VDP	;7443 �R�}���h���s��
	XOR	A		;7445 VDP S#0�ɖ߂�
	OUT	(099H),A	;7446
	LD	A,08FH		;7448
	OUT	(099H),A	;744A
	LD	A,C		;744C
	ADD	A,08CH		;744D �h���C�u�e�[�u��7F8Ch�`
	LD	C,A		;744F
CEFD_1:	LD	HL,(07FAAH)	;7450
	CALL	KEYCHK		;7453 �L�[���̓`�F�b�N
	JR	Z,CEFD_6	;7456 �f�B�X�N����
	EX	AF,AF'		;7458
	LD	B,07FH		;7459
	LD	A,(BC)		;745B
	SET	6,A		;745C
	EXX			;745E
	EI			;745F
	RET			;7460
	
CEFD_6:	IN	A,(0AAH)	;7461
	LD	L,A		;7463
CEFD_7:	CALL	CEFD_2		;7464
	JR	Z,CEFD_7		;7467
CEFD_8:	CALL	CEFD_2		;7469
	JR	NZ,CEFD_8	;746C
	LD	A,L		;746E
	OUT	(0AAH),A	;746F
	JR	CEFD_1		;7471
CEFD_2:	PUSH	HL		;7473
	LD	H,010H		;7474 �e���L�[
	LD	DE,KTBL		;7476 �L�[�e�[�u���̃|�C���^
CEFD_3:	DJNZ	CEFD_3		;7479 �����v�_�ő��x�������[�v

	
CEFD_4:	PUSH	HL		;747B
	LD	A,(DE)		;747C �e���L�[
	LD	L,A		;747D
	CALL	KEY_IN		;747E
	INC	DE
	JR	Z,CEF_4A
	LD	A,(DE)		;�@�t���L�[
	LD	L,A
	CALL	KEY_IN
	JR	NZ,CEFD_5	;7481
CEF_4A:	CALL	TE_TBL		;7483
	LD	A,050H		;7486
	SUB	H		;7488
	LD	B,05FH		;7489 �L�[�������ꂽ���t���O���p
	LD	(BC),A		;748B
	ADD	A,A		;748C
	ADD	A,A		;748D
	ADD	A,A		;748E
	ADD	A,A		;748F
	LD	L,A		;7490
	LD	H,05EH		;7491
	INC	HL		;7493
	RES	7,(HL)		;7494 �f�B�X�N�������ꂽ��������
	CALL	TE_SYN		;7496
CEFD_5:	POP	HL		;7499
	INC	DE		;749A
	DEC	H		;749B
	JR	NZ,CEFD_4	;749C
	
	LD	L,074H		;749E R800-ROM mode
	CALL	CEFD_A		;74A0
	LD	L,075H		;74A3 Z80 mode
	CALL	CEFD_A		;74A5
	
	POP	HL		;74A8
	INC	H		;74A9
	LD	A,H		;74AA
	AND	040H		;74AB
	XOR	L		;74AD
	OUT	(0AAH),A	;74AE
	BIT	6,B		;74B0
	RET			;74B2


	
	
CEFD_A:	CALL	KEY_IN		;74B3
	RET	NZ		;74B6
	EX	AF,AF'		;74B7
	PUSH	AF		;74B8
	PUSH	BC		;74B9
	LD	A,L		;74BA
	CPL			;74BB
	AND	081H		;74BC
	EXX			;74BE
	RST	30H		;74BF CALLF
	DB	80h		;74C0
	DW	180h		;74C1
	
	DI			;74C3
	EXX			;74C4
	POP	BC		;74C5
	POP	AF		;74C6
	EX	AF,AF'		;74C7
	LD	B,05FH		;74C8 �L�[�������ꂽ���t���O���p
	RET			;74CA
	
;***************************************
;SEMAPH
;����: Cy=0:�J�� Cy=1:�m��
;���FFh��Ԃ�
;****************************************

SEMAPH:	PUSH	HL		;74CB
	LD	HL,__FF__	;74CC
	JR	C,SMF_R1	;74CF
	LD	(HL),01H	;74D1 �J��
	POP	HL		;74D3
	RET			;74D4
	
SMF_R1:	SRA	(HL)		;74D5 �m��
	POP	HL		;74D7
	CCF			;74D8
	RET	NC		;74D9
	LD	A,06H		;74DA �G���[�R�[�h'drive busy'
	RET			;74DC
	
;***************************************
;KEYCHK
;�w�肵���Q�̃L�[��������Ă��邩�𒲂ׂ�
;****************************************

KEYCHK:	CALL	KEY_R1		;74DD
	RET	NZ		;74E0
	LD	L,H		;74E1
KEY_R1:	PUSH	HL		;74E2
	LD	A,L		;74E3
	AND	0FH		;74E4
	LD	H,A		;74E6
	IN	A,(0AAH)	;74E7
	AND	0F0H		;74E9
	OR	H		;74EB
	OUT	(0AAH),A	;74EC
	IN	A,(0A9H)	;74EE
	LD	H,A		;74F0
	LD	A,L		;74F1
	RLCA			;74F2
KEY_L1:	RLC	H		;74F3
	ADD	A,020H		;74F5
	JR	NC,KEY_L1	;74F7
	XOR	H		;74F9
	RRA			;74FA
	SBC	A,A		;74FB
	POP	HL		;74FC
	RET			;74FD
KEY_IN:	CALL	KEY_R1		;74FE
	RET	NZ		;7501
KEY_R2:	CALL	KEY_R1		;7502
	JR	Z,KEY_R2	;7505
	XOR	A		;7507
	RET			;7508
	
;***************
;DISCON
;SCSI��p�t�@���N�V����
SCSI:	RET			;7509


	
;***************************************
;TO_TBL
;�p�[�e�B�V�����e�[�u����4000-5FFFh�ɏo��
;***************************************
TO_TBL:	SCF			;751B
	CALL	SEMAPH		;751C
	RET	C		;751F
	
TE_TBL:	PUSH	AF		;7520
	LD	A,DOSBK+081H	;7521
	LD	(06000H),A	;7523
	POP	AF		;7526
	RET			;7527
	
;****************************************
;����:	SECALC
;�@�\:	�Z�N�^�ԍ��֌W�̏���������
;����:	B,CDE�ɃZ�N�^����Z�N�^�ԍ������Ă�����
;       DE'�� D'=00  C'=�Z�N�^�� 
;	IX=�p�[�e�B�V�����e�[�u��
;�o��:	Cy=1,A=E_OTHR�Ȃ�΁A�p�[�e�B�V�����O�ւ̃A�N�Z�X
;	DE�ɘ_���u���b�N�ԍ�,E'�ɘ_���u���b�N��
;*****************************************

SECALC:	LD	A,C		;7528 �Z�N�^�ԍ�(��ʁj
	PUSH	DE		;7529 �Z�N�^�ԍ�(���ʁj
	EXX			;752A ���ɂ���
	POP	HL		;752B �Z�N�^�ԍ�(���ʁj
	ADD	HL,DE		;752C
	ADC	A,D		;752D �Z�N�^�ԍ�(��ʁj
	LD	D,A		;752E DHL=�ŏI�Z�N�^�ԍ�
	LD	A,(IX+7D)	;752F
	SUB	L		;7532
	LD	A,(IX+6D)	;7533
	SBC	A,H		;7536
	LD	A,(IX+5D)	;7537
	SBC	A,D		;753A
	EXX			;753B
	LD	A,0CH		;753C
	RET	C		;753E �u���b�N�������z���Ă��܂�
	LD	A,E		;753F �J�n�u���b�N�{�Z�N�^�ԍ�
	ADD	A,(IX+4D)	;7540
	LD	E,A		;7543
	LD	A,D		;7544
	ADC	A,(IX+3D)	;7545
	LD	D,A		;7548
	LD	A,C		;7549
	ADC	A,(IX+2D)	;754A
	LD	C,A		;754D
	XOR	A		;754E
	RET			;754F
	



;*****************************************
;����:	DISKIO
;�@�\:	�_���Z�N�^�̓ǂݏ���
;����:	A=���[�J���ȃh���C�u�ԍ�(0-7)
;	Cy=0:�ǂݍ���,Cy=1:��������
;	B=�ǂݍ��ރZ�N�^��
;	DE=�ǂݍ��ރZ�N�^�ԍ�
;	HL=�ǂݍ��ރA�h���X
;�o��:	Cy=0:����I��,Cy=1:�G���[
;	A=�G���[�R�[�h
;�j��:	C,DE,AF',BC',DE',HL',IX,IY
;*****************************************

DISKIO:	EI			;75E5
	CALL	CK_SPC		;75E6
DSKIO:	JP	NZ,SDMMC	;75E9 SD/MMC

	EX	AF,AF'
	LD	IX,4010h
	
CALDSK:	EX	AF,AF'
	PUSH	AF
	LD	A,(7F88h)
	DEC	A
	CP	08Fh
	JR	C,CAL_R1
	POP	AF
	EX	AF,AF'
	LD	A,02H		;75FF
	SCF			;7601
	RET			;7602
	
CAL_R1:	EX	AF,AF'
	LD	A,00h
	LD	IY,(7F87h)
	CALL	001Ch
	EX	AF,AF'
	POP	AF
	EX	AF,AF'
	RET
	

	
;*************
;TO_DOS
	
TO_DOS:	PUSH	AF		;7642
	LD	A,DOSBK		;7643
	LD	(06000H),A	;7645
	XOR	A		;7648
	CALL	SEMAPH		;7649
	POP	AF		;764C
	RET			;764D
	
;*************
;TE_DOS

TE_DOS:	PUSH	AF		;764E
	LD	A,DOSBK		;764F
	LD	(06000H),A	;7651
	POP	AF		;7654
	RET			;7655
	
;***************************************************************************
;����:	TO_SYN
;�@�\:	���o���N�̃e�[�u���Ɠ��e����v�����A�c�n�r�o���N�ɖ߂�
;����:	����
;�o��:	�Փ˂̋��ꂪ����΁ACy=1,A=�G���[�R�[�h
;�j��:	AF
;***************************************************************************

TO_SYN:	call	TE_SYN
	jr	TO_DOS

;***************************************************************************
;����:	TE_SYN
;�@�\:	���o���N�̃e�[�u���Ɠ��e����v�����A�ꎞ�I�ɂc�n�r�o���N�ɖ߂�
;����:	����
;�o��:	����
;�j��:	����
;***************************************************************************

TE_SYN:	push	af
	push	bc
	push	de
	push	hl
	
	ld	a,TBLBK			;�������݂��ł���l�ɂ���
	ld	(6000h),a		;�����P�̃e�[�u���̃o���N�ɐ؂�ւ���

	ld	bc,01CDh
	ld	de,5E00h
	ld	hl,7E00h
	ldir
	pop	hl
	pop	de
	pop	bc
	pop	af
	jr	TE_DOS



;******************************************
;DSKCHG
;�@�\:	�f�B�X�N���������ꂽ���𒲂ׂ�
;����:	A=���[�J���ȃh���C�u�ԍ�(0-7)
;	HL=�ǂݍ��ރA�h���X
;�o��:	����I��:Cy=0	B= 1:��������Ă��Ȃ�
;			B= 0:�������ꂽ���s��
;			B=-1:�������ꂽ
;	�ُ�I��:Cy=1	A=�G���[�R�[�h
;			B= 0:�������ꂽ���s��
;�j��:	C,AF',BC',DE',HL',IX,IY
;******************************************

DSKCHG:	EI			;7675
	CALL	CK_SPC		;7676
		
DCG_R1:	PUSH	HL		;7679
	CALL	DCG_S1		;767A �f�B�X�N�����𒲂ׂ�
	POP	DE		;767D
	LD	B,00H		;767E
	RET	C		;7680 Cy=1 B=0 �ُ�I��
	INC	B		;7681
	DB	0DDh,0CBh,01h,7Eh	;BIT  7,(IX+01h)
	RET	NZ		;7686 Cy=0 B=1 ��������Ă��Ȃ�
	LD	A,(IX+00h)	;7687

DCG_R2:	RRCA			;7690
	JR	NC,DCG_R2	;7691
	ADD	A,A		;7693
	JR	NZ,DCG_R4	;7694 �t���O�𗧂ĂȂ�
	
DCG_R3:	CALL	TO_TBL		;7696
	DEC	B		;7699
	RET	C		;769A
	PUSH	IX		;769B
	POP	HL		;769D
	INC	HL		;769E
	RES	5,H		;769F �e�[�u���A�h���X-2000h
	SET	7,(HL)		;76A1 �����t���O�𗧂Ă�
	CALL	TO_SYN		;76A3
DCG_R4:	EX	AF,AF'		;76A6
	EX	DE,HL		;76A7
	OR	A		;76A8
	CALL	CK_SUB		;76A9
	

	CALL	GTDPB_		;76AC DPB�e�[�u��������
	LD	B,0FFH		;76AF �������ꂽ
	RET	NC		;76B1 ����I��
	CP	0AH		;76B2
	RET	Z		;76B4
	SCF			;76B5
	INC	B		;76B6
	RET			;76B7
	
DCG_S1:	JR	NZ,DCG_S2	;76B8
	LD	IX,04013H	;76BA
	JP	CALDSK		;76BE
	
DCG_S2:	
	CALL	DCG_A1		;76C4 �Z�N�^�O�̓ǂݏo��
	OR	A		;76CD 
	RET	Z		;76CE ����ɓǂݏo���ł����@��������ĂȂ�
	CP	02H		;76CF
	SCF			;76D1 �G���[
	RET	Z		;76D2
DCG_S4:	CALL	TO_TBL		;76D3
	RET	C		;76D6
	LD	B,018H		;76D7 �e�[�u���̐�
	LD	DE,0FH		;76D9 �P�e�[�u��������16�o�C�g
	LD	HL,05E00H	;76DC
	LD	A,(IX+0D)	;76DF
DCG_S5:	CP	(HL)		;76E2
	INC	HL		;76E3
	JR	NZ,DCG_S6	;76E4
	RES	7,(HL)		;76E6
DCG_S6:	ADD	HL,DE		;76E8
	DJNZ	DCG_S5		;76E9
	XOR	A		;76EB
	JP	TO_SYN		;76EC
	
;*************
;GETDPB

GETDPB:	EI			;76EF
	OR	A		;76F0
	CALL	CK_SPC		;76F1 E-RAM DISK Cy=0 Z=1
	                        ;     MMC        Cy=1 Z=0
	                        ;     FDD        Cy=1 Z=1
	
GTDPB_:	PUSH	HL		;76F4
	LD	HL,(0F34DH)	;76F5
	LD	DE,00H		;76F8
	LD	BC,01FFH	;76FB
	CALL	DSKIO		;76FE
	POP	HL		;7701
	RET	C		;7702
DPB_R1:	LD	IY,(0F34DH)	;7703
	INC	HL		;7707
	PUSH	HL		;7708
	LD	BC,012H		;7709
	EX	DE,HL		;770C
	LD	HL,07405H	;770D DPBDAT
	LDIR			;7710
	POP	HL		;7712
	LD	A,(IY+15h)	;7713
	CP	0F9H		;7716 2DD?
	RET	Z		;7718
	LD	(HL),A		;7719 MEDIA ID
	INC	HL		;771A
	INC	HL		;771B
	INC	HL		;771C
	INC	HL		;771D
	INC	HL		;771E
	LD	A,(IY+0Dh)	;771F
	DEC	A		;7722
	LD	(HL),A		;7723 �N���X�^�@�}�X�N
	INC	HL		;7724
	ADD	A,01H		;7725
	LD	B,00H		;7727
DPB_L1:	INC	B		;7729
	RRA			;772A
	JR	NC,DPB_L1	;772B
	LD	(HL),B		;772D �N���X�^�@�V�t�g
	INC	HL		;772E
	PUSH	BC		;772F
	LD	A,(IY+0Eh)	;7730
	LD	(HL),A		;7733�@FAT�擪�Z�N�^�ԍ��@����
	INC	HL		;7734
	LD	D,(IY+0Fh)	;7735
	LD	(HL),D		;7738 FAT�擪�Z�N�^�ԍ��@���
	INC	HL		;7739
	LD	B,(IY+10h)	;773A
	LD	(HL),B		;773D FAT��
	INC	HL		;773E
DPB_L2:	ADD	A,(IY+16h)	;773F FAT�̈�̃Z�N�^��
	JR	NC,DPB_R2	;7742
	INC	D		;7744
DPB_R2:	DJNZ	DPB_L2		;7745
	LD	C,A		;7747
	LD	B,D		;7748 �f�B���N�g���擪�Z�N�^�ԍ�
	LD	E,(IY+11h)	;7749
	LD	D,(IY+12h)	;774C
	LD	A,D		;774F
	OR	A		;7750
	LD	A,0FEH		;7751
	JR	NZ,DPB_R3	;7753
	LD	A,E		;7755
DPB_R3:	LD	(HL),A		;7756 �f�B���N�g����
	INC	HL		;7757
	DEC	DE		;7758
	LD	A,04H		;7759
DPB_L3:	SRL	D		;775B
	RR	E		;775D
	DEC	A		;775F
	JR	NZ,DPB_L3	;7760
	INC	DE		;7762
	EX	DE,HL		;7763
	ADD	HL,BC		;7764
	EX	DE,HL		;7765
	LD	(HL),E		;7766 �f�[�^�̈�擪�Z�N�^
	INC	HL		;7767
	LD	(HL),D		;7768
	INC	HL		;7769
	LD	A,(IY+13h)	;776A ���Z�N�^��
	SUB	E		;776D
	LD	E,A		;776E
	LD	A,(IY+14h)	;776F
	SBC	A,D		;7772
	LD	D,A		;7773
	POP	AF		;7774 �N���X�^�V�t�g
DPB_L4:	DEC	A		;7775 
	JR	Z,DPB_R4		;7776
	SRL	D		;7778
	RR	E		;777A
	JR	DPB_L4		;777C
DPB_R4:	INC	DE		;777E
	LD	(HL),E		;777F �N���X�^���{�P
	INC	HL		;7780
	LD	(HL),D		;7781
	INC	HL		;7782
	LD	A,(IY+16h)	;7783
	LD	(HL),A		;7786
	INC	HL		;7787
	LD	(HL),C		;7788 �f�B���N�g���擪�Z�N�^
	INC	HL		;7789
	LD	(HL),B		;778A
	XOR	A		;778B
	RET			;778C
	
;**************
;CHOICE

CHOICE:	CALL	CK_SPC		;778D
	LD	HL,00H		;7790
	RET	NC		;7793 ERAM DISK
	LD	HL,CHO_D1	;7794
MTROFF:	XOR	A		;7797
	RET			;7798
	
CHO_D1:	DB	0,'SCSI5FF0',0	;7799

;**************
;DSKFMT

Z0057:	LD	A,010H		;77A3
	SCF			;77A5
	RET			;77A6
	
;********************
;INIHRD
;�o���N0 47D6h����Ă΂��
	
INIHRD:	LD	HL,(07FA2H)	;77A7
	CALL	KEYCHK		;77AA
	JR	NZ,IHRD_1	;77AD
	POP	AF		;77AF �h���C�u�؂藣��
	RET			;77B0
	

IHRD_1:				;77B1
	CALL	SCSI		;77B4
	LD	HL,(07FA4H)	;77B7 �o�X���Z�b�g GRAPH+TAB
	CALL	KEYCHK		;77BA
	CALL	Z,SCSI		;77BD
	CALL	TE_DOS		;77C0
	CALL	TE_TBL		;77C3
	LD	HL,(07FA0H)	;77C6 ������ GRAPH+ESC
	CALL	KEYCHK		;77C9
	JR	NZ,IHRD_2	;77CC
	LD	HL,05E00H	;77CE
	LD	DE,05E01H	;77D1
	LD	BC,0197H	;77D4
	LD	(HL),L		;77D7
	LDIR			;77D8
	LD	A,0FFH		;77DA
	LD	(05F00H),A	;77DC
	LD	A,01H		;77DF
	LD	(05F80H),A	;77E1
	LD	HL,0307H	;77E4
	LD	(05F90H),HL	;77E7
	
IHRD_2:	LD	B,018H		;77EA
	LD	DE,0FH		;77EC
	LD	HL,05E00H	;77EF
IHRD_3:	LD	A,(HL)		;77F2
	INC	HL		;77F3
	OR	A		;77F4
	JR	Z,IHRD_4		;77F5
	SET	7,(HL)		;77F7
IHRD_4:	ADD	HL,DE		;77F9
	DJNZ	IHRD_3		;77FA
	LD	HL,(07FA8H)	;77FC
	CALL	KEYCHK		;77FF
	JR	NZ,IHRD_5	;7802
	LD	(05F88H),A	;7804 ���zFD���[�h����
IHRD_5:	LD	A,(07F88H)	;7807
	CP	0FEH		;780A
	JR	IHRD_6		;780C ���zFD�t���O��FEh�̎��͕��ʂɃh���C�u�m��
	POP	AF		;780E
IHRD_6:	JP	TE_SYN		;780F

;************
;DRIVES

	PUSH	AF		;7812
	PUSH	BC		;7813
	PUSH	DE		;7814
	CALL	SLTWRK		;7815
	LD	A,DOSBK+081H	;7818
	CALL	IWRK_S		;781A
	LD	A,TBLBK		;781D
	CALL	IWRK_S		;781F
	LD	(HL),01H	;7822
	INC	HL		;7824
	LD	(HL),0EDH	;7825
	INC	HL		;7827
	LD	(HL),0B0H	;7828
	INC	HL		;782A
	LD	(HL),0C9H	;782B
	
	ld	hl,0D000h
	ld	(0F34Dh),hl
	ld	a,0		;�e�[�u���ǂݏo��
	call	SETBLK		;�p�[�e�B�V�����ݒ�
	ld	hl,0
	ld	(0F34Dh),hl
	
	LD	A,(07F99H)	;782D
	LD	(07000H),A	;7830
	INC	A		;7833
	LD	(07800H),A	;7834
	LD	A,(07F88H)	;7837
	OR	A		;783A
	JR	NZ,DRV_R5	;783B
	LD	HL,(07FA6H)	;783D
	CALL	KEYCHK		;7840
	AND	02H		;7843
	LD	(0F33FH),A	;7845
	JR	DRV_R5		;7848
	
DRV_R4:	LD	HL,0FD99H	;784A ���zFD�ł������ɗ��Ȃ�
	INC	(HL)		;784D ���ʂɃh���C�u�m��
	POP	DE		;784E
	
DRV_R5:	LD	HL,(07F80H)	;784F
	POP	DE		;7852
	POP	BC		;7853
	POP	AF		;7854
	RET			;7855
	
;************
;INIWRK

IWRK_S:	
	LD	(06000H),A	;7856
	PUSH	HL		;7859

	LD	A,(07F88H)	;785A
	OR	A		;785D
	LD	HL,032CDH	;785E
	JR	NZ,IHRD_8	;7861
	LD	C,0FFH		;7863
	LD	DE,05E01H	;7865
	LD	HL,05E00H	;7868
	LD	(HL),L		;786B
	LDIR			;786C
	LD	HL,0118H	;786E
IHRD_8:	LD	(05417H),HL	;7871
	POP	HL		;7874
	JP	TE_DOS		;7875
	
;*************
;E_RUNC

E_RUNC:	LD	A,(07F88H)	;7878
	OR	A		;787B
	JR	Z,RUNC_2		;787C
	CALL	TE_TBL		;787E
	LD	A,(0FB22H)	;7881
	LD	(05F88H),A	;7884
	CALL	TE_SYN		;7887
	CALL	0402DH		;788A
	LD	(0FB22H),A	;788D
	LD	(0FB2CH),A	;7890
	LD	HL,07FDAH	;7893
	LD	(0FB2DH),HL	;7896
	JR	RUNC_4		;7899
RUNC_2:	LD	A,(07F81H)	;789B
	OR	A		;789E
	JR	Z,RUNC_4		;789F
	LD	(0F2FDH),A	;78A1
RUNC_4:	JP	KERNEL		;78A4


;*****************
;M_SFNC

	PUSH	HL		;78A7
	PUSH	AF		;78A8
	LD	HL,FNCTBL	;78A9
SFC_L1:	SUB	(HL)		;78AC
	INC	HL		;78AD
	JR	C,SFC_R1	;78AE
	INC	HL		;78B0
	INC	HL		;78B1
	JR	SFC_L1		;78B2
SFC_R1:	LD	A,(HL)		;78B4
	INC	HL		;78B5
	LD	H,(HL)		;78B6
	LD	L,A		;78B7
	POP	AF		;78B8
	EX	(SP),HL		;78B9
	LD	IY,05FF0H	;78BA
	RET			;78BE
	
FNCTBL:	DB	8
	DW	SFC_00			;func 00h (DISKIO)
	DB	8
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����
	DB	8
	DW	SFC_10			;func 10h (DSKCHG)
	DB	40h-18h
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����

	DB	16
	DW	SFC_40			;func 40h (ex-DISKIO)
	DB	16
	DW	SFC_50			;func 50h (ex-DSKCHG)
	DB	80h-60h
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����

	DB	4
	DW	SFC_80			;func 80h (table get/free)
	DB	4
	DW	SFC_84			;func 84h (table read/write)
	DB	0a0h-88h
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����

	DB	1
	DW	SFC_A0			;func A0h (get information)
	DB	1
	DW	SFC_ER
	DB	2
	DW	SFC_A2			;func A2h (table read/write)
	DB	2
	DW	SFC_A4			;func A4h (table read/write)
	DB	2
	DW	SFC_A6			;func A6h (table read/write)
	DB	2
	DW	SFC_A8			;func A8h (table read/write)
	DB	2
	DW	SFC_AA			;func AAh (table read/write)
	DB	0c0h-0ach
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����

	DB	3			;C0h-C2h
	DW	SCSI			;SCSI��p�t�@���N�V����

	DB	1
	DW	SEMAPH			;C3h ���܂ӂ����ӂ�
	DB	1
	DW	TO_DOS			;C4h �c�n�r�o���N�ɖ߂�
	DB	1
	DW	TE_DOS			;C5h �ꎞ�I�ɂc�n�r�o���N�ɖ߂�
	DB	8			;C6h-CDh
	DW	SCSI			;SCSI��p�t�@���N�V����


__FF__:	DB	-1			;�Ō�Ƀ_���������_�~�[�Z�}�t�H���W�X�^
	DW	SFC_ER			;����ȃt�@���N�V�����͖�����

SFC_ER:	scf
	sbc	a,a
	ret
	

SFC_00:				;     00h-07h
SFC_40:	CALL	CK_SUB		;7922 40h-4Fh
	JP	SECSIZ		;7928

SFC_10:
SFC_50:
	CALL	CK_SUB		;792C
	JP	DCG_R1		;792F

SFC_80:	RRA			;7932
	JR	C,SFC_P1	;7933

SFC_01:	PUSH	HL		;7935
	RRA			;7936
	LD	BC,0800H	;7937
	LD	DE,010H		;793A
	LD	HL,07F00H	;793D
	JR	NC,SFC_02	;7940
	SLA	B		;7942
	DEC	H		;7944
SFC_02:	LD	A,(HL)		;7945
	OR	A		;7946
	JR	Z,SFC_03	;7947
	ADD	HL,DE		;7949
	INC	C		;794A
	DJNZ	SFC_02		;794B
	POP	HL		;794D
	LD	A,0CH		;794E
	SCF			;7950
	RET			;7951
SFC_03:	POP	DE		;7952
	RES	5,H		;7953
	PUSH	BC		;7955
	CALL	SFC_T2		;7956
	POP	BC		;7959
	RET			;795A
SFC_P1:	LD	HL,07FC0H	;795B
	RLA			;795E
SFC_84:	LD	D,05FH		;795F
	BIT	1,A		;7961
	JR	Z,SFC_T1	;7963
	DEC	D		;7965
SFC_T1:	LD	B,A		;7966
	LD	A,C		;7967
	ADD	A,A		;7968
	ADD	A,A		;7969
	ADD	A,A		;796A
	ADD	A,A		;796B
	LD	E,A		;796C
	LD	A,B		;796D
SFC_T2:	LD	C,010H		;796E
SFC_T3:	LD	B,00H		;7970
	RRA			;7972
	JR	C,SFC_T4	;7973
	EX	DE,HL		;7975
SFC_T4:	CALL	TO_TBL		;7976
	RET	C		;7979
	LDIR			;797A
SFC_RE:	XOR	A		;797C
	JP	TO_SYN		;797D

SFC_A0:	XOR	A		;7980
_TYPE:	LD	A,02H		;7981
	LD	BC,0215H	;7983
	RET			;7986
SFC_A2:	LD	C,02H		;7987
	LD	DE,05F90H	;7989
	JR	SFC_T3		;798C
SFC_A4:	LD	C,04H		;798E
	LD	DE,05F98H	;7990
	JR	SFC_T3		;7993
SFC_A6:	LD	C,08H		;7995
	LD	DE,05F80H	;7997
	JR	SFC_T3		;799A
SFC_A8:	LD	C,08H		;799C
	LD	DE,05F88H	;799E
	JR	SFC_T3		;79A1
SFC_AA:	LD	C,0CH		;79A3
	LD	DE,05FA0H	;79A5
	JR	SFC_T3		;79A8


;*******************************************
;SD/MMC 
;����: CDE=�Z�N�^�ԍ� B=�Z�N�^��


SDMMC:	
	ld	a,(7f88h)	;���zFD�t���O������
	or	a
	jr	nz,SDMMC1	;���zFD�N��

	call	SDBOOT		;�p�[�e�B�V�����ݒ�
	ret	c

SDMMC1:	BIT	7,C		;7C52 
	JR	Z,SECSIZ	;7C54 C=�Z�N�^�ԍ����
	LD	C,00H		;7C56
SECSIZ:	LD	A,B		;7C58 �Z�N�^��
	EXX			;7C59
	LD	E,A		;7C5A DE'=�Z�N�^��
	LD	D,00H		;7C5B
	EXX			;7C5D
	CALL	SECALC		;7C5E �Z�N�^�ԍ��{�J�n�u���b�N�̌v�Z
	RET	C		;7C61
	SCF			;7C62
	CALL	SEMAPH		;7C63
	RET	C		;7C66
	
	ld	a,(ix+0)	;get ID  01=slot 1,  02=slot 2
	dec	a		;a=slot number
	call	TE_SPC		;bank 40h
	ld	(5fffh),a	;change slot  0=slot1, 01=slot2
	
	
	EX	AF,AF'		;7C67
	JR	C,SD_WR		;7C68
	CALL	RD_R1		;7C6A read
	JR	SD_DON		;7C6D
	
SD_WR:	CALL	WR_R1		;7C6F write
SD_DON:	JP	TO_DOS		;7C72



;********************
;�o���N0  4904h����Ă΂��

	LD	A,01H		;7C80
	LD	(07000H),A	;7C82
	LD	A,(07F88H)	;7C85
	OR	A		;7C88
	RET	Z
	LD	A,08BH		;7C8A
	LD	E,04H		;7C8C
	LD	HL,07FF0H	;7C8E
	CALL	014H		;7C91
	RET			;7C94

	
;**************
;DSKCHG����Ă΂��
;�f�B�X�N�̔����������`�F�b�N

DCG_A1:	EX	AF,AF'		;7CA0
	PUSH	AF		;7CA1
	OR	A		;7CA2
	CALL	CK_SUB		;7CA3  CALL  741Ah
	LD	DE,00H		;7CA6
	LD	HL,(0F34DH)	;7CA9
	LD	BC,0100H	;7CAC
	
	CALL	TE_SPC		;7CC6
	ld	a,(ix+0)
	dec	a
	ld	(5fffh),a	;change slot
	call	DCG_A4		;7CC9
	call	TE_DOS		;7CCC
	ex	af,af'
	pop	af
	ex	af,af'
	ret
	
	
DCG_A5:	SCF			;7CCF
DCG_A6:	LD	A,02H		;7CD0
	RET			;7CD2
DCG_A7:	CALL	INIT		;7CD3
	POP	BC		;7CD6
	POP	DE		;7CD7
	POP	HL		;7CD8
	JR	NZ,DCG_A5	;7CD9
	JR	C,DCG_A6	;7CDB
	LD	A,04H		;7CDD
	RET			;7CDF
	
DCG_A4:	PUSH	HL		;7CE0
	PUSH	DE		;7CE1
	PUSH	BC		;7CE2
	LD	B,051H		;7CE3
	LD	HL,04000H	;7CE5
	CALL	MMCCMD		;7CE8
	JR	C,DCG_A7	;7CEB
	POP	BC		;7CED
	POP	DE		;7CEE
	POP	HL		;7CEF
	OR	A		;7CF0
	JR	NZ,DCG_A5	;7CF1
	PUSH	DE		;7CF3
	PUSH	BC		;7CF4
	EX	DE,HL		;7CF5
	LD	BC,0200H	;7CF6
	LD	HL,04000H	;7CF9
DCG_A8:	LD	A,(HL)		;7CFC
	CP	0FEH		;7CFD
	JR	NZ,DCG_A8	;7CFF
	BIT	7,D		;7D01
	JR	NZ,DCG_A9	;7D03
	DEC	DE		;7D05
	LD	A,D		;7D06
	INC	DE		;7D07
	CP	03EH		;7D08
	JR	C,DCG_A9	;7D0A
	PUSH	DE		;7D0C
	LD	DE,(0F34DH)	;7D0D
	PUSH	DE		;7D11
	LDIR			;7D12
	LD	A,(HL)		;7D14
	LD	A,(HL)		;7D15
	POP	HL		;7D16
	POP	DE		;7D17
	LD	BC,0200H	;7D18
	CALL	0F1D9H		;7D1B
	JR	DCG_B1		;7D1E
DCG_A9:	LDIR			;7D20
	LD	A,(HL)		;7D22
	LD	A,(HL)		;7D23
DCG_B1:	EX	DE,HL		;7D24
	POP	BC		;7D25
	POP	DE		;7D26
	INC	DE		;7D27
	LD	A,D		;7D28
	OR	E		;7D29
	JR	NZ,DCG_B2	;7D2A
	INC	C		;7D2C
DCG_B2:	DJNZ	DCG_A4		;7D2D
	XOR	A		;7D2F
	RET			;7D30
	
;***********
;�����Ȃ�FAT16
;�o���N0 4B19h����Ă΂��

	CALL	05243H		;7D31�@�u�[�g�Z�N�^��+20h����uVOL_ID�v��T��
	RET	Z		;7D34�@�������MSX-DOS2
	CALL	CHK_V1		;7D35�@������΁uFAT1�v��T��
	RET	NZ		;7D38�@�ǂ����������Ȃ���DOS1�N��
	LD	A,0C9H		;7D39  Windows�Ńt�H�[�}�b�g�����f�B�X�N
	LD	(0C01EH),A	;7D3B�@�u�[�g�Z�N�^��MSX�ƈ���Ă���̂ō׍H����
	RET			;7D3E
	NOP			;7D3F
CHK_V1:	LD	HL,0C000H	;7D40
	LD	BC,0100H	;7D43
CHK_V5:	LD	A,046H		;7D46
	CPIR			;7D48
	JR	Z,CHK_V2	;7D4A
	RET			;7D4C
CHK_V2:	PUSH	HL		;7D4D
	PUSH	BC		;7D4E
	LD	B,03H		;7D4F
	LD	DE,MOJI		;7D51
CHK_V4:	LD	A,(DE)		;7D54
	XOR	(HL)		;7D55
	JR	NZ,CHK_V3	;7D56
	INC	HL		;7D58
	INC	DE		;7D59
	DJNZ	CHK_V4		;7D5A
CHK_V3:	POP	BC		;7D5C
	POP	HL		;7D5D
	JR	NZ,CHK_V5	;7D5E
	RET			;7D60
	
MOJI:	DB	'AT1'		;7D61

;**************************************
SDBOOT:
	ld	a,d
	or	e
	ret	nz		;�u�[�g�Z�N�^�ȊO�̃A�N�Z�X
	ld	a,(ix+5)
	or	a
	ret	z		;���zFD�̃h���C�u���蓖��
	
	push	hl
	push	de
	push	bc
	push	ix
	ex	af,af'
	push	af		;drive
	call	SETBLK
	pop	af
	ex	af,af'
	pop	ix
	pop	bc
	pop	de
	pop	hl
	ret
	
	

	
;**************************************
;�J�n�u���b�N�����ݒ�
SETBLK:
	ld	c,a		;lorcal drive
	ld	a,84h		;�e�[�u���ǂݏo��
	call	FUNC

	ld	hl,(0F34Dh)
	ld	a,(hl)
	inc	a
	ret	z		;����RAM
	xor	a
	inc	hl
	inc	hl
	ld	(hl),a		;sector h
	inc	hl
	ld	(hl),a		;sector m
	inc	hl
	ld	(hl),a		;sector l
	dec	a
	inc	hl
	ld	(hl),a		;�u���b�N�� ff ff ff
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a

	ld	a,85h		;�e�[�u����������
	call	FUNC

	push	bc
	ld	a,c		;�h���C�u
	ld	c,0		;Read sector 0
	ld	de,0
	ld	b,01h
	or	a
	call	FUNC		;�Z�N�^�O�̓ǂݏo��
	pop	bc
	
	call	FTYPE		;�t�H�[�}�b�g�̎�ނ́H
	ret	c		;super floppy?
	
	ld	a,84h		;�h���C�u�e�[�u���ǂݏo��
	call	FUNC

	push	bc
	call	GETPTN		;HDD�t�H�[�}�b�g�͊J�n�u���b�N�����߂�
	pop	bc
	ret	c		;�p�[�e�B�V������񂪖����J�n�u���b�N00
	ld	a,85h		;�e�[�u����������
FUNC:	push	bc
	ld	hl,(0F34Dh)
	call	MEGFUN
	pop	bc
	ret
	
	
;-----------------------------------------------------
;�t�H�[�}�b�g�̎�ނ́H
;-----------------------------------------------------
FTYPE:	push	bc
	ld	hl,(0F34Dh)
	ld	bc,0100h
FTYPE1:	ld	a,46h		;'F'
	cpir
	jr	z,FTYPE2
	pop	bc
	or	a		;HDD�t�H�[�}�b�g
	ret
	
FTYPE2:	push	hl
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	ld	hl,4154h	;'A' 'T'
	or	a
	sbc	hl,de
	pop	hl
	jr	nz,FTYPE1
	pop	bc
	scf			;�uFAT�v�̕����������super floppy
	ret
	
	
	
;-----------------------------------------------------
;�p�[�e�B�V�����e�[�u����������
;-----------------------------------------------------
GETPTN:	
	ld	b,04h		;+1c6�`1f6����p�[�e�B�V�����e�[�u����
	ld	hl,(0F34Dh)	;������
	ld	de,01c6h
	add	hl,de
GETP_1:
	push	hl
	ld	e,(hl)		; l
	inc	hl
	ld	d,(hl)		; m
	inc	hl
	ld	c,(hl)		; h
	ld	a,c
	or	d
	or	e
	pop	hl
	jr	nz,GETP_2	;�p�[�e�B�V�����e�[�u��������
	ld	de,0010h
	add	hl,de
	djnz	GETP_1
	scf			;������Ȃ�
	ret			;

GETP_2:	ld	hl,(0F34Dh)
	inc	hl
	inc	hl
	ld	(hl),c		;�J�n�u���b�Nh
	inc	hl
	ld	(hl),d		;�J�n�u���b�Nm
	inc	hl
	ld	(hl),e		;�J�n�u���b�Nl
	or	a		;�J�n�u���b�N�ݒ�
	ret
	
;***********************************************
;SD/MMC�A�N�Z�X���[�`��



;*** initialize work area
TE_SPC:	push	af
	ld	a,40h
	ld	(6000h),a
	pop	af
	ret





;*** MMC command handler
MMCCMD:	ld	a,(hl)		;dummy cycle 8 clocks
	sla	e
	rl	d
	rl	c
	ld	(hl),b		;command
	nop
	ld	(hl),c		;sector(H)
	nop
	ld	(hl),d		;sector(M)
	nop
	ld	(hl),e		;sector(L)
	ld	(hl),0		;sector(0)
	ld	(hl),95h	;CRC
	nop
	ld	a,(hl)
	ld	bc,10h		;ese-16f
CMD_L1:	ld	a,(hl)
	cp	0ffh
	ccf
	ret	nc
	dec	bc
	ld	a,b
	or	c
	jr	nz,CMD_L1
	scf			;timeout error
	ret

;*** Initialize / set to SPI mode
INIT:	ld	b,10		;dummy cycle > 76 clocks
INIT_L:	ld	a,(5000h)
	djnz	INIT_L

	ld	bc,4000h	;CMD0
	ld	de,0
	ld	hl,4000h
	call	MMCCMD

	ret	c		;response timeout
	and	0f7h
	cp	01h
	ret	nz


	
INIT_M:	ld	bc,7700h	;CMD55 for ACMD41
	ld	de,0
	ld	hl,4000h
	call	MMCCMD
	and	04h
	jr	z,INIT_S
	
	ld	bc,4100h	;CMD1 for MMC
	ld	de,0
	ld	hl,4000h
	call	MMCCMD
	jr	INIT_T
	
INIT_S:	ld	bc,6900h	;ACMD41 for SD-Memory
	ld	de,0
	ld	hl,4000h
	call	MMCCMD
INIT_T:	ret	c		;response timeout
	cp	01h
	jr	z,INIT_M
	or	a		;z=1: OK  z=0: error 
	ret


;*************************************************

	
RD_E1:	scf			;Cy=1 
RD_E2:	ld	a,02h		;error code
	ret


RD_R0:	call	INIT
	pop	bc
	pop	de
	pop	hl
	jr	nz,RD_E1	;response error
	jr	c,RD_E2		;command error
	

RD_R1:	
	push	hl
	push	de
	push	bc
	ld	b,51h
	ld	hl,4000h
	call	MMCCMD
	jr	c,RD_R0
	pop	bc
	pop	de
	pop	hl
	or	a
	jr	nz,RD_E1	;Cy=0 A=02

	push	de
	push	bc

	ex	de,hl
	ld	bc,200h
	ld	hl,04000h
	
RD_W1:	ld	a,(hl)		
	cp	0feh		;start data token
	jr	nz,RD_W1

	bit	7,d
	jr	nz,RD_W2
	dec	de
	ld	a,d
	inc	de
	cp	3eh
	jr	c,RD_W2
	push	de		;�]����A�h���X
	ld	de,(0f34dh)
	push	de
	ldir
	ld	a,(hl)		;CRC(dummy)
	ld	a,(hl)

	pop	hl		;(f34dh)
	pop	de		;�]����A�h���X
	ld	bc,200h
	call	TE_DOS		;bank 0
	call	0f36eh
	call	TE_SPC		;bank 40h
	jr	RD_W3

RD_W2:	ldir			;transfer read data

	ld	a,(hl)		;CRC (dummy)
	ld	a,(hl)		;CRC (dummy)

RD_W3:	ex	de,hl
	pop	bc
	pop	de
	inc	de		;CDE = sector number
	ld	a,d
	or	e
	jr	nz,RD_W4
	inc	c
RD_W4:	djnz	RD_R1

	xor	a		;A=00 Cy=0 ����I��
	ret

;*************************************************
;write

WR_E0:	pop	bc
	pop	de
	
WR_E1:	scf			;Cy=1 

WR_E2:	ld	a,02h		;Cy=1 A=02
	ret

WR_R0:	call	INIT
	pop	bc
	pop	de
	pop	hl
	jr	nz,WR_E1	;response error
	jr	c,WR_E2		;command error
	

WR_R1:	
	push	hl
	push	de
	push	bc
	ld	b,58h		;CMD24
	ld	hl,4000h
	call	MMCCMD
	jr	c,WR_R0
	pop	bc
	pop	de
	pop	hl
	or	a
	jr	nz,WR_E1	;command error

	push	de
	push	bc
	
	ld	bc,200h
	ld	de,04000h

	ld	a,(de)		;dummy
	ld	a,0feh		;start data token
	ld	(de),a

	bit	7,h
	jr	nz,WR_W2
	dec	hl
	ld	a,h
	inc	hl
	cp	3eh
	jr	c,WR_W2
	ld	de,(0f34dh)
	call	TE_DOS		;bank 0
	call	0f36eh
	call	TE_SPC		;bank 40h
	push	hl
	ld	hl,(0f34dh)
	ld	de,04000h
	ld	bc,200h
	ldir
	pop	hl
	jr	WR_W3
	

WR_W2:	ldir			;transfer write data

WR_W3:	ex	(sp),hl
	ld	a,(de)		;CRC (dummy)
	ex	(sp),hl
	ld	a,(de)		;CRC (dummy)
	
	ld	a,(de)		;dummy
	ld	a,(de)		;receive data response

	and	01fh
	cp	005h
	jr	nz,WR_E0	;response error

WR_W1:	ld	a,(de)		;busy state
	cp	0ffh
	jr	nz,WR_W1

	pop	bc
	pop	de
	inc	de		;CDE = sector number
	ld	a,d
	or	e
	jr	nz,WR_W4
	inc	c
WR_W4:	djnz	WR_R1

	xor	a		;A=00 Cy=0 ����I��
	ret


;**************************************
;���zFD�@�L�[�e�[�u��

KTBL:	DB	39h,00h,49h,10h,59h,20h,69h,30h
	DB	79h,40h,0Ah,50h,1Ah,60h,2Ah,70h		;
	DB	3Ah,01h,4Ah,02h,7Ah,62h,6Ah,72h
	DB	19h,03h,5Ah,13h,09h,23h,29h,33h

	

	

	END
