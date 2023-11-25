-------------------------------------------------------------------------------
-- File	      : xor_begin_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-16
-- Last update: 2022-11-21
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de l'opération de xor du début
-- Entrées: state_i, data_i, en_xorb_begin_i
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

entity xor_begin_tb is
end entity xor_begin_tb;

architecture xor_begin_tb_arch of xor_begin_tb is
	
	component xor_begin port (
		state_i : in type_state;
		data_i : in bit64;
		en_xorb_key_i : in std_logic;
		state_o : out type_state);
	end component;

	signal en_xorb_key_s : std_logic;
	signal state_i_s, state_o_s : type_state;
	signal data_s : bit64;

begin

	DUT : xor_begin port map(
		state_i => state_i_s,
		en_xorb_key_i => en_xorb_key_s,
		data_i => data_s,
		state_o => state_o_s);
	
	--stimuli
	en_xorb_key_s <= '0', '1' after 20 ns;
	
	data_s <= x"3230323280000000";
	
	state_i_s <= (x"bc830fbef3a1651b", x"487a66865036b909", x"a031b0c5810c1cd6", x"dd7ce72083702217", x"9b17156ede557ce7");

end xor_begin_tb_arch;

configuration xor_begin_tb_conf of xor_begin_tb is
	for xor_begin_tb_arch
		for DUT : xor_begin
			use entity LIB_RTL.xor_begin(xor_begin_arch);
		end for;
	end for;
end xor_begin_tb_conf;
