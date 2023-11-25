-------------------------------------------------------------------------------
-- File	      : xor_begin_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-23
-- Last update: 2022-11-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de la substitution
-- Entrées: state_i, key_i, en_xore_key_i, en_bypass_i
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

entity xor_end_tb is
end entity xor_end_tb;

architecture xor_end_tb_arch of xor_end_tb is
	
	component xor_end port (
		state_i : in type_state;
		key_i : in bit128;
		en_bypass_i : in std_logic;	--enable xor begin
		en_xore_key_i : in std_logic;
		state_o : out type_state);
	end component;

	signal en_bypass_s, en_xore_key_s : std_logic;
	signal state_i_s, state_o_s : type_state;
	signal key_s : bit128;

begin

	DUT : xor_end port map(
		state_i => state_i_s,
		en_xore_key_i => en_xore_key_s,
		en_bypass_i => en_bypass_s,
		key_i => key_s,
		state_o => state_o_s);
	--stimuli
	
	en_xore_key_s <= '1';
	en_bypass_s <= '1';
	
	key_s <= x"000102030405060708090A0B0C0D0E0F";
	
	-- Pour ce test, nous avons utilisé en entrée la sortie du bloc de texte 4 
	state_i_s <= (x"4484a574cc1220e9", x"b9d821ead71902ef", x"74491c2a9ada9011", x"c36df040c62a25a2", x"c77518af6e08589f");

end xor_end_tb_arch;

configuration xor_end_tb_conf of xor_end_tb is
	for xor_end_tb_arch
		for DUT : xor_end
			use entity LIB_RTL.xor_end(xor_end_arch);
		end for;
	end for;
end xor_end_tb_conf;
