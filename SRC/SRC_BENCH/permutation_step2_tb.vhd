-----------------------------------------------------------------------------------------------------------------------------------
-- File	      : permutation_step2_tb
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-10
-- Last update: 2022-11-16
-- Standard   : VHDL'93/02
-----------------------------------------------------------------------------------------------------------------------------------
-- Description:	 conception du testbench de la permutation finale
-- Entrées: data_sel_i, resetb_i, clock_i, en_xor_begin_i, en_key_xor_end_i, en_bypass_i, round_i, data_i, en_reg_state_i, state_i
-- Sorties: state_o, cipher_o
-----------------------------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 
-----------------------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
-----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity permutation_step2_tb is
end entity permutation_step2_tb;

architecture permutation_step2_tb_arch of permutation_step2_tb is
	
	component permutation_step2 port (
		data_sel_i : in std_logic;
		resetb_i : in std_logic;
		clock_i : in std_logic;
		en_key_xor_end_i : in std_logic;	-- enable key de xor_end
		en_xor_begin_i : in std_logic;	-- enable key de xor_begin
		en_bypass_i : in std_logic;	-- enable bypass
		en_reg_state_i : in std_logic;
		round_i : in bit4;	-- la constante de ronde
		key_i : in bit128; -- la clé
		data_i : in bit64;
		state_i : in type_state;
		cipher_o : out bit64;
		state_o : out type_state);
	end component;

	signal data_sel_s, resetb_s : std_logic;
	signal clock_s : std_logic := '0';
	signal en_xor_begin_s, en_key_xor_end_s, en_bypass_s, en_reg_state_s : std_logic;
	signal round_s : bit4;
	signal state_i_s, state_o_s : type_state;
	signal key_s : bit128;
	signal data_s, cipher_s : bit64;

begin

	DUT : permutation_step2 port map(
		data_sel_i => data_sel_s,
		resetb_i => resetb_s,
		clock_i => clock_s,
		round_i => round_s,
		en_xor_begin_i => en_xor_begin_s,
		en_key_xor_end_i => en_key_xor_end_s,
		en_bypass_i => en_bypass_s,
		en_reg_state_i => en_reg_state_s,
		key_i => key_s,
		data_i => data_s,
		state_i => state_i_s,
		cipher_o => cipher_s,
		state_o => state_o_s);
	
	--stimuli
		resetb_s <= '0', '1' after 20 ns;
		
		-- transformation de l'état sur chaque front montant de l'horloge
		clock_s <= not(clock_s) after 50 ns;

		data_sel_s <= '0', '1' after 100 ns;
		
		-- Test d'initialisation, l'état prend en entrée les valeurs initiales. On fait une permutation p12 et on xor avec "0..0"&K
		
		-- Etant donné que l'on a un wait sur 100 ns pour round_i, on change les valeurs de en_bypass_i et en_key_i au 11ème tour
		en_xor_begin_s <= '1', '0' after 75 ns;
		en_reg_state_s <= '1';
		
		-- l'entrée est la sortie de l'initialisation
		state_i_s(0) <= x"BC830FBEF3A1651B";
		state_i_s(1) <= x"487A66865036B909";
		state_i_s(2) <= x"A031B0C5810C1CD6";
		state_i_s(3) <= x"DD7CE72083702217";
		state_i_s(4) <= x"9B17156EDE557CE7";
		
		data_s <= x"3230323280000000";
		
		key_s <= x"000102030405060708090A0B0C0D0E0F";

		p0 : process
		
		begin
			for i in 6 to 11 loop
				round_s <= std_logic_vector(to_unsigned(i, 4));
				wait for 100 ns;

			end loop;

		end process;
				
		en_bypass_s <= '0' after 500 ns;
		en_key_xor_end_s <= '0' after 500 ns;
		
end permutation_step2_tb_arch;

configuration permutation_step2_tb_conf of permutation_step2_tb is
	for permutation_step2_tb_arch
		for DUT : permutation_step2
			use entity LIB_RTL.permutation_step2(permutation_step2_arch);
		end for;
	end for;
end permutation_step2_tb_conf;
