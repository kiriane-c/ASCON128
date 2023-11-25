-------------------------------------------------------------------------------
-- File	      : sbox_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-08
-- Last update: 2022-11-09
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de la sbox
-- Entrées: data_i
-- Sorties: data_o
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

entity sbox_tb is
end entity sbox_tb;

architecture sbox_tb_arch of sbox_tb is
	component sbox port(
		data_i : bit5;
		data_o : out bit5);
	end component;


	signal data_is, data_os : bit5;

begin

	DUT : sbox port map(
		data_i => data_is,
		data_o => data_os);
	
	--stimili
	data_is <= "00000" after 5 ns, "00001" after 10 ns, "00010" after 15 ns, "00011" after 20 ns, "00100" after 25 ns;

end sbox_tb_arch;

configuration sbox_tb_conf of sbox_tb is
	for sbox_tb_arch
		for DUT : sbox
			use entity LIB_RTL.sbox(sbox_arch);
		end for;
	end for;
end sbox_tb_conf;
