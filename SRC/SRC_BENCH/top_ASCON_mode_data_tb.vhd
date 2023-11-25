-------------------------------------------------------------------------------
-- File	      : top_ASCON_mode_data_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-03
-- Last update: 2022-12-03
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de la phase de traitement de données associées
-- Entrées: resetb_i, clock_i, start_i, key_i, nonce_i, data_i, data_valid_i, IV_i
-- Sorties: end_o
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

entity top_ASCON_mode_data_tb is
end entity top_ASCON_mode_data_tb;

architecture top_ASCON_mode_data_tb_arch of top_ASCON_mode_data_tb is
	component top_ASCON_mode_data port(
		clock_i	 : in std_logic;
    resetb_i : in std_logic;
    start_i	: in std_logic;
    data_valid_i : in std_logic;
    data_i : in bit64;
    key_i : in bit128;	-- la clé K
    nonce_i : in bit128;	-- le nonce N
    IV_i : in bit64;	-- le vecteur d'initialisation IV
    
    end_o : out std_logic);
   end component;
   
   signal resetb_s, start_s, end_s, data_valid_s : std_logic;
   signal clock_s : std_logic := '0';
   signal data_s : bit64;
   signal key_s, nonce_s : bit128;
   signal IV_s : bit64;
   
begin

	DUT : top_ASCON_mode_data port map(
		resetb_i => resetb_s,
		clock_i => clock_s,
		key_i => key_s,
		data_i => data_s,
		data_valid_i => data_valid_s,
		start_i => start_s,
		nonce_i => nonce_s,
		IV_i => IV_s,
		end_o => end_s);
		
		--stimuli
		
		resetb_s <= '0', '1' after 20 ns;
		clock_s <= not(clock_s) after 50 ns;
		
		data_valid_s <= '1';
		start_s <= '0', '1' after 100 ns;
		
		IV_s <= IV_c;	--IV_c est défini dans ascon_pack.vhd
		
		nonce_s <= x"000102030405060708090A0B0C0D0E0F";
		key_s <= x"000102030405060708090A0B0C0D0E0F";
		
		data_s <= x"3230323280000000";
		
end architecture top_ASCON_mode_data_tb_arch;

library LIB_RTL;
configuration top_ASCON_mode_data_tb_conf of top_ASCON_mode_data_tb is
	for top_ASCON_mode_data_tb_arch
		for DUT : top_ASCON_mode_data
			use configuration LIB_RTL.top_ASCON_mode_data_conf;
		end for;
	end for;
end top_ASCON_mode_data_tb_conf;   
