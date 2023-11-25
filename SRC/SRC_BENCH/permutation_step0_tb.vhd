-------------------------------------------------------------------------------
-- File	      : permutation_step0_tb
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-10
-- Last update: 2022-11-16
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de la permutation de base
-- Entrées: data_sel_i, resetb_i, clock_i, en_reg_state_i, round_i, state_i
-- Sorties: state_o
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity permutation_step0_tb is
end entity permutation_step0_tb;

architecture permutation_step0_tb_arch of permutation_step0_tb is
	
	component permutation_step0 port (
		data_sel_i : in std_logic;
		resetb_i : in std_logic;
		clock_i : in std_logic;
		en_reg_state_i : in std_logic;
		round_i : in bit4;
		state_i : in type_state;
		state_o : out type_state);
	end component;

	signal data_sel_s, resetb_s, en_reg_state_s : std_logic;
	signal clock_s : std_logic := '0';
	signal round_s : bit4;
	signal state_is, state_os : type_state;

begin
	DUT : permutation_step0 port map(
		data_sel_i => data_sel_s,
		resetb_i => resetb_s,
		clock_i => clock_s,
		en_reg_state_i => en_reg_state_s,
		round_i => round_s,
		state_i => state_is,
		state_o => state_os);
	
	--stimuli
	resetb_s <= '0', '1' after 20 ns;

	-- les transformations sur l'état se font sur chaque front montant de l'horloge
	clock_s <= not(clock_s) after 50 ns;
	data_sel_s <= '0', '1' after 100 ns;
	en_reg_state_s <= '1';
	
	-- l'entrée est IV&K&N
	state_is(0) <= x"80400c0600000000";
	state_is(1) <= x"0001020304050607";
	state_is(2) <= x"08090a0b0c0d0e0f";
	state_is(3) <= x"0001020304050607";
	state_is(4) <= x"08090a0b0c0d0e0f";
	
	p0 : process
	begin
		for i in 0 to 11 loop
			round_s <= std_logic_vector(to_unsigned(i, 4));
			wait for 100 ns;
		end loop;
	end process; 
	
	--stimuli sortie 12èmes ronde

end permutation_step0_tb_arch;

configuration permutation_step0_tb_conf of permutation_step0_tb is
	for permutation_step0_tb_arch
		for DUT : permutation_step0
			use entity LIB_RTL.permutation_step0(permutation_step0_arch);
		end for;
	end for;
end permutation_step0_tb_conf;
