---------------------------------------------------------------------------------------------------
-- File	      : permutation_step1_tb
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-10
-- Last update: 2022-11-16
-- Standard   : VHDL'93/02
---------------------------------------------------------------------------------------------------
-- Description:	 conception du testbench de la permutation intermédiaire
-- Entrées: data_sel_i, resetb_i, clock_i, en_xor_begin_i, round_i, data_i, en_reg_state_i, state_i
-- Sorties: state_o
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 
---------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity permutation_step1_tb is
end entity permutation_step1_tb;

architecture permutation_step1_tb_arch of permutation_step1_tb is
	
	component permutation_step1 port (
		data_sel_i : in std_logic;
		resetb_i : in std_logic;
		clock_i : in std_logic;
		en_xor_begin_i : in std_logic;
		en_reg_state_i : in std_logic;
		round_i : in bit4;
		data_i : in bit64;
		state_i : in type_state;
		state_o : out type_state);
	end component;

	signal data_sel_s, resetb_s, en_reg_state_s : std_logic;
	signal clock_s : std_logic := '0';
	signal en_xor_begin_s : std_logic;
	signal round_s : bit4;
	signal state_i_s, state_o_s : type_state;
	signal data_s : bit64;

begin

	DUT : permutation_step1 port map(
		data_sel_i => data_sel_s,
		resetb_i => resetb_s,
		clock_i => clock_s,
		round_i => round_s,
		en_xor_begin_i => en_xor_begin_s,
		en_reg_state_i => en_reg_state_s,
		data_i => data_s,
		state_i => state_i_s,
		state_o => state_o_s);
	
	--stimuli
	
		resetb_s <= '0', '1' after 20 ns;
		
		-- changement de l'état sur chaque front montant de l'horloge
		clock_s <= not(clock_s) after 50 ns;

		data_sel_s <= '0', '1' after 100 ns; --initalement, l'entrée de la permutation est l'état initiale. Ensuite, ce sont les états en sorti du registre
		en_xor_begin_s <= '1', '0' after 75 ns; -- initialement, l'opération de xor est activée.
		en_reg_state_s <= '1';
		
		-- l'entrée est la sortie de la permutation de base (12 rondes)
		state_i_s(0) <= x"BC830FBEF3A1651B";
		state_i_s(1) <= x"487A66865036B909";
		state_i_s(2) <= x"A031B0C5810C1CD6";
		state_i_s(3) <= x"DD7CE72083702217";
		state_i_s(4) <= x"9B17156EDE557CE7";
		
		data_s <= x"3230323280000000";

		p0 : process
		
		begin
		-- 6 rondes à effectuer
			for i in 6 to 11 loop
				round_s <= std_logic_vector(to_unsigned(i, 4));
				wait for 100 ns;
			end loop;
		end process;

end permutation_step1_tb_arch;

configuration permutation_step1_tb_conf of permutation_step1_tb is
	for permutation_step1_tb_arch
		for DUT : permutation_step1
			use entity LIB_RTL.permutation_step1(permutation_step1_arch);
		end for;
	end for;
end permutation_step1_tb_conf;
