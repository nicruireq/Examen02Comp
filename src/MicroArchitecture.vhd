----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolas Ruiz Requejo
-- 
-- Create Date:    22:04:54 01/22/2018 
-- Design Name: 
-- Module Name:    MicroArchitecture - Behavioral 
-- Project Name: 	 Examen02
-- Target Devices: 
-- Tool versions: 
-- Description:    computer's microarchitecture with
--						 datapath, ram memory conections
--						 and control signals inputs
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	MicroArchitecture.vhd  -- This file is part of Examen02Comp
--
--	Copyright (C) 2017-2018 Nicolas Ruiz Requejo
--
--  This file is part of Examen02Comp.
--
--  Examen02Comp is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  Examen02Comp is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with Examen02Comp.  If not, see <https://www.gnu.org/licenses/>.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ComputerComponents.all;

entity MicroArchitecture is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
			  RST : in STD_LOGIC;
			  selRst : in STD_LOGIC;
           LPC : in STD_LOGIC;
           selPC : in STD_LOGIC;
           selComp : in STD_LOGIC;
			  checkMode : in STD_LOGIC;
           LMAR : in STD_LOGIC;
           LIR : in STD_LOGIC;
           WE : in STD_LOGIC;
           RW : in STD_LOGIC;
           LB : in STD_LOGIC;
           LA : in STD_LOGIC;
           LO : in STD_LOGIC;
           LFZ : in STD_LOGIC;
           selBSrc : in STD_LOGIC_VECTOR (1 downto 0);
           aluOp : in STD_LOGIC_VECTOR (1 downto 0);
           addressRAM : out STD_LOGIC_VECTOR (3 downto 0);
           regAOut : out STD_LOGIC_VECTOR (3 downto 0);
           regBOut : out STD_LOGIC_VECTOR (3 downto 0);
           regOOut : out STD_LOGIC_VECTOR (3 downto 0);
           regInstOut : out STD_LOGIC_VECTOR (9 downto 0);
           opCode : out STD_LOGIC_VECTOR (2 downto 0);
           FZOut : out STD_LOGIC;
           segmentViolationLine : out STD_LOGIC);
end MicroArchitecture;

architecture Behavioral of MicroArchitecture is
	-- SIGNAL declarations
	-----------------------
	-- sigResetSrc selects the source of reset signal
	signal sigResetSrc : std_logic;
	
	-- sigIROut gets Instruction Register's data
	signal sigIROut : std_logic_vector(9 downto 0);
	
	-- sigOpCode gets first field of Instruction Register, 
	-- the operation code
	signal sigOpCode : std_logic_vector(2 downto 0);
	
	-- sigIRField2 gets second field of Instruction Register, 
	-- mem/imm/reg1
	signal sigIRField2 : std_logic_vector(3 downto 0);
	
	-- sigIRDirR2 gets third field of Instruction Register, reg2
	signal sigIRDirR2 : std_logic_vector(2 downto 0);
	
	-- sigR1Data gets first data output (R1) of register file
	signal sigR1Data : std_logic_vector(3 downto 0);
	
	-- sigRAMDataOut goes from data output
	-- of RAM carrying memory data to
	-- multiplexer for  B operand's register of alu and
	-- instruction register
	signal sigRAMDataOut : std_logic_vector(9 downto 0);
	
	-- sigR1Data gets second data output (R2) of register file
	signal sigR2Data : std_logic_vector(3 downto 0);
	
	-- sigOpeA gets from A register the A operand of ALU
	signal sigOpeA : std_logic_vector(3 downto 0);
	
	-- sigBInput goes from multiplexer that selects the 
	-- source of B operand data to input of B register
	signal sigBInput : std_logic_vector(3 downto 0);
	
	-- sigOpeB gets from B register the B operand of ALU
	signal sigOpeB : std_logic_vector(3 downto 0);
	
	-- sigALUOut gets the result of ALU's operation
	signal sigALUOut : std_logic_vector(3 downto 0);
	
	-- sigFZ gets the result of compare if alu output is zero
	signal sigFZ : std_logic;
	
	-- sigALUResult gets O data (output register of ALU) 
	-- and carry to either ram data input or register
	-- file data input
	signal sigALUResult : std_logic_vector(3 downto 0);
	
	-- sigRAMDataIn extends sigALUResult from four
	-- width bits to ten width bits 
	signal sigRAMDataIn : std_logic_vector(9 downto 0);
	
	-- sigPCIn carry address shall be loaded in program counter(PC)
	signal sigPCIn : std_logic_vector(3 downto 0);
	
	-- sigPCOut carry output data of program counter
	signal sigPCOut : std_logic_vector(3 downto 0);
	
	-- sigPCOutInc carry program counter incremented
	signal sigPCOutInc : std_logic_vector(3 downto 0);
	
	-- sigInSegmentChecker the input of segmentChecker
	signal sigInSegmentChecker : std_logic_vector(3 downto 0);
	
	-- sigOutSegmentChecker the output of segmentChecker
	signal sigOutSegmentChecker : std_logic_vector(3 downto 0);
	
	-- sigMAROut is the output of memory addres register,
	-- is a bus that carry memory address for data or code
	-- (in case of beq instructions).
	-- Goes to input address of RAM and to program counter
	-- through a multiplexer to select data source of program
	-- counter
	signal sigMAROut : std_logic_vector(3 downto 0);
	
	-- CONSTANT declarations
	-------------------------
	-- segment limit, is 0xA memory address
	constant segmentLimit : std_logic_vector(3 downto 0) := "1010";
	
begin

	-- mux to select the source of reset,
	-- global asynchronous reset or selective
	-- reset for segment violations
	muxSelRst:
	with selRst select
		sigResetSrc <= RST when '1',
							RESET when others;

	-- instantiate Instruction Register (IR) 
	IR: RegN generic map(n => 10) 
				port map(
							CLK => CLK, RESET => sigResetSrc, enable => LIR, 
							D => sigRAMDataOut, Q => sigIROut
						  );
														
	-- gets instruction fields in their signals from IR output signal
	sigOpCode <= sigIROut(9 downto 7);	-- 3 bits of width of bus
	sigIRField2 <= sigIROut(6 downto 3); -- 4 bits of width of bus
	sigIRDirR2 <= sigIROut(2 downto 0); -- 3 bits of width of bus
	
	-- instantiate Register File
	-- needs reduce bits width of sigIRField2 
	-- and gets only the 3 LSBs for dirReg1
	registerFile: 
	RegisterFile8x4 port map(
									 CLK => CLK, RESET => sigResetSrc, dirReg1 => sigIRField2(2 downto 0), 
									 dirReg2 => sigIRDirR2, dataInReg2 => sigALUResult, 
									 RW => RW, dataOutReg1 => sigR1Data, dataOutReg2 => sigR2Data 
									 );
														
	-- instantiate alu's A operand register (A)
	A: RegN generic map(n => 4) 
			  port map(
						  CLK => CLK, RESET => sigResetSrc, enable => LA,
						  D => sigR2Data, Q => sigOpeA
						 );
	
	-- description of mux to select the data
	-- source(register file, immediate or memory data) 
	-- for B operand of ALU. In case of memory data
	-- catch only the four less significant bits of
	-- its bus
	muxSelOpBSrc:
	with selBSrc select
		sigBInput <= sigR1Data when "00",
						 sigIRField2 when "01",
						 sigRAMDataOut(3 downto 0) when "10",
						 (others => '0') when others;
	
	-- instantiate alu's B operand register (B)
	B: RegN generic map(n => 4) 
			  port map(
						  CLK => CLK, RESET => sigResetSrc, 
						  enable => LB, D => sigBInput, 
						  Q => sigOpeB
						 );
	
	-- Description of the ALU with 3 operations
	--	move operand A, add operands A and B; and
	-- substract A and B operands.
	ALU: 
	process(aluOp, sigOpeA, sigOpeB)
	begin
		case aluOp is
			-- move A operand to alu's output
			when "00" =>
				sigALUOut <= sigOpeA;
			-- move B operand to alu's output
			when "01" =>
				sigALUOut <= sigOpeB;
			-- alu's output <- A plus B
			when "10" =>
				sigALUOut <= 
					std_logic_vector(
						unsigned(sigOpeA) + unsigned(sigOpeB)
						);
			-- alu's output <- A minus B			
			when "11" =>
				 sigALUOut <= 
					std_logic_vector(
						unsigned(sigOpeA) - unsigned(sigOpeB)
						);
			-- clause "catch all"
			when others =>
				sigALUOut <= (others => '0');
		end case;
	end process ALU;	

	-- process to evaluate if alu's output 
	-- is equal to zero
	zeroFlag:
	process(aluOp, sigALUOut)
	begin 
		-- compare alu's output with zero
		-- only if selected operations are
		-- add or sub
		if (aluOp = "10") or (aluOp = "11") then
			if (sigALUOut = "0000") then
				sigFZ <= '1';
			else
				sigFZ <= '0';
			end if;
		else
			-- other operation not compare
			sigFZ <= '0';
		end if;
	end process zeroFlag;

	-- instantiate Flag Zero register (FZ)
	FZ: FFD port map(
							CLK => CLK, RESET => sigResetSrc,
							enable => LFZ, D => sigFZ, 
							Q => FZOut
						  );
	
	-- instantiate alu's result operand register (O)
	O: RegN generic map(n => 4) 
			  port map(
						  CLK => CLK, RESET => sigResetSrc, enable => LO, 
						  D => sigALUOut, Q => sigALUResult
						 );
	
	-- extend sigALUResult to ten witdh bits
	extension10bit:
	sigRAMDataIn <= "000000" & sigALUResult;
	
	-- instantiate RAM
	RAM: 
	RAM16x10 port map(
							CLK => CLK, dataIn => sigRAMDataIn, 
							address => sigMAROut, we => WE,
							dataOut => sigRAMDataOut
						  );
	
	-- mux to select the source of program counter,
	-- if is loaded jump address from beq instruction
	-- or the incremented program counter
	muxSelPCSrc:
	with selPC select
		sigPCIn <= sigPCOutInc when '0', 
					  sigMAROut when '1',
					  (others => '0') when others;
						
	
	-- instantiate Program Counter (PC)
	PC: RegN generic map(n => 4) 
				port map(
							CLK => CLK, RESET => sigResetSrc, 
							enable => LPC, D => sigPCIn, 
							Q => sigPCOut
						  );
	
	-- increment program counter data out
	incrementPC:
	sigPCOutInc <= std_logic_vector(unsigned(sigPCOut) + 1);
	
	-- mux that select what is the source address
	-- to check by segment checker (program counter
	-- for next instruction or memory address from
	-- instruction register's second field)
	muxSelSrcSegmentChecker:
	with selComp select
		sigInSegmentChecker <= sigPCOut when '0',
									  sigIRField2 when '1',
									  (others => '0') when others;
	
	-- instantiate segment checker 
	segmentCheckerLimiter: 
	SegmentChecker port map(
									opCode => sigOpCode,
									dirInput => sigInSegmentChecker,
									checkMode => checkMode,
									segmentLimit => segmentLimit,
									segmentViolationFlag => segmentViolationLine,
									dirOutput => sigOutSegmentChecker
								  );
	
	-- instantiate Memory Address Register (MAR)
	MAR: RegN generic map(n => 4) 
				 port map(
							 CLK => CLK, RESET => sigResetSrc, 
							 enable => LMAR, D => sigOutSegmentChecker, 
							 Q => sigMAROut
							);
	
	-- assign outputs of MicroArchitecture
	addressRAM <= sigMAROut;
	regAOut <= sigOpeA;
	regBOut <= sigOpeB;
	regOOut <= sigALUResult;
	regInstOut <= sigIROut;
	opCode <= sigOpCode;
	
end Behavioral;
