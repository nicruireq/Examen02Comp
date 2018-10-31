----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		 Nicolás Ruiz Requejo
-- 
-- Create Date:    10:30:19 11/22/2017 
-- Design Name: 
-- Module Name:    Display7seg_4ON - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--	Display7seg_4ON.vhd  -- This file is part of Examen02Comp
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display7seg_4ON is
    Port ( Dato1 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato2 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato4 : in  STD_LOGIC_VECTOR (3 downto 0);
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Anodo : out  STD_LOGIC_VECTOR (3 downto 0);
           Catodo : out  STD_LOGIC_VECTOR (6 downto 0));
end Display7seg_4ON;

architecture Behavioral of Display7seg_4ON is

	COMPONENT CLK_1KHz
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;          
		Out_1KHz : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Counter_2bits
	PORT(
		ENABLE : IN std_logic;
		CLK : IN std_logic;
		RESET : IN std_logic;          
		Q : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux4_4bit
	PORT(
		I0 : IN std_logic_vector(3 downto 0);
		I1 : IN std_logic_vector(3 downto 0);
		I2 : IN std_logic_vector(3 downto 0);
		I3 : IN std_logic_vector(3 downto 0);
		Sel : IN std_logic_vector(1 downto 0);          
		F_Out : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT Disp7Seg
	PORT(
		Hex : IN std_logic_vector(3 downto 0);
		Select_Disp : IN std_logic_vector(1 downto 0);          
		Seg : OUT std_logic_vector(6 downto 0);
		Anode : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	signal sig_clock_1KHz : std_logic;
	signal sig_sel_disp : std_logic_vector(1 downto 0);
	signal sig_seg_data : std_logic_vector(3 downto 0);

begin

	Inst_CLK_1KHz: CLK_1KHz PORT MAP(
		CLK => CLK,
		Reset => RESET,
		Out_1KHz => sig_clock_1KHz
	);
	
	Inst_Counter_2bits: Counter_2bits PORT MAP(
		ENABLE => sig_clock_1KHz,
		CLK => CLK,
		RESET => RESET,
		Q => sig_sel_disp
	);
	
	Inst_mux4_4bit: mux4_4bit PORT MAP(
		I0 => Dato1,
		I1 => Dato2,
		I2 => Dato3,
		I3 => Dato4,
		Sel => sig_sel_disp,
		F_Out => sig_seg_data
	);

	Inst_Disp7Seg: Disp7Seg PORT MAP(
		Hex => sig_seg_data,
		Select_Disp => sig_sel_disp,
		Seg => Catodo,
		Anode => Anodo
	);

end Behavioral;

