-------------------------------------------------------------------------------
-- File	      : top_ASCON_mode_plain_text_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-10
-- Last update: 2022-12-10
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de la phase injection de blocs de textes clairs
-- Entrées: resetb_i, clock_i, start_i, key_i, nonce_i, data_i, IV_i, data_valid_i
-- Sorties: end_o, tag_o, cipher_o, cipher_valid_o
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

entity top_ASCON_mode_plain_text_tb is
end entity top_ASCON_mode_plain_text_tb;

architecture top_ASCON_mode_plain_text_tb_arch of top_ASCON_mode_plain_text_tb is
	component top_ASCON_mode_plain_text port(
		clock_i	 : in std_logic;
    resetb_i : in std_logic;
    start_i	: in std_logic;
    data_valid_i : in std_logic;
    data_i : in bit64;
    key_i : in bit128;
    nonce_i : in bit128;
    IV_i : in bit64;
    
    end_o : out std_logic;
    cipher_valid_o: out std_logic;
    cipher_o : out bit64);
   end component;
   
   signal resetb_s, start_s, end_s, data_valid_s, cipher_valid_s : std_logic;
   signal clock_s : std_logic := '0';
   signal data_s : bit64;
   signal key_s, nonce_s : bit128;
   signal IV_s, cipher_s : bit64;
   
begin

	DUT : top_ASCON_mode_plain_text port map(
		resetb_i => resetb_s,
		clock_i => clock_s,
		key_i => key_s,
		data_i => data_s,
		data_valid_i => data_valid_s,
		start_i => start_s,
		nonce_i => nonce_s,
		IV_i => IV_s,
		end_o => end_s,
		cipher_o => cipher_s,
		cipher_valid_o => cipher_valid_s);
		
		clock_s <= not(clock_s) after 50 ns;
		--stimuli
		
		P0 : process is
			begin --process P0
		
				resetb_s <= '0', '1' after 20 ns;
				data_valid_s <= '1';
				start_s <= '0', '1' after 100 ns;
				
				--key
				key_s <= x"000102030405060708090A0B0C0D0E0F";
				nonce_s <= x"000102030405060708090A0B0C0D0E0F";
				IV_s <= IV_c;
				
				--associated data
				data_s <= x"3230323280000000";
				wait for 2000 ns;	-- attente des deux premières phases du chiffrement
				
				data_s <= x"446576656c6f7070";
				wait for 800 ns;	-- attente du traitement de P1
				
				data_s <= x"657a204153434f4e";
				wait for 800 ns;	-- attente du traitement de P2
				
				data_s <= x"20656e206c616e67";
				wait for 800 ns;	-- attente du traitement de P3
				
				data_s <= x"6167652056484480";
				wait for 800 ns;	-- on introduit P4 mais il ne sera pas traiter. P4 est traité dans la phase finalisation
				
			end process;	
		
end architecture top_ASCON_mode_plain_text_tb_arch;

library LIB_RTL;
configuration top_ASCON_mode_plain_text_tb_conf of top_ASCON_mode_plain_text_tb is
	for top_ASCON_mode_plain_text_tb_arch
		for DUT : top_ASCON_mode_plain_text
			use configuration LIB_RTL.top_ASCON_mode_plain_text_conf;
		end for;
	end for;
end top_ASCON_mode_plain_text_tb_conf;   
