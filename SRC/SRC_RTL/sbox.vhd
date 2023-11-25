-------------------------------------------------------------------------------
-- File	      : sbox.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-08
-- Last update: 2022-11-09
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de la sbox ASCON
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

entity sbox is

	port(
		data_i : in bit5;
		data_o : out bit5);
		
end sbox;

architecture sbox_arch of sbox is

	-- déclaration d'un tableau de 32 lignes de 8 bits
	type sbox_t is array (0 to 31) of bit8;
	
	-- définition du tableau de substitution
	-- l'indice de chaque valeur du tableau correspond à la valeur à substituer
	-- par exemple : les entrées vont de 0 à 31. La valeur substituée de x"00" est donc à l'indice 0 dans le tableau ci dessous et vaut x"04" ainsi de suite.
	constant sbox_c : sbox_t := (x"04", x"0B", x"1F", x"14", x"1A", x"15", x"09", x"02", x"1B", x"05", x"08", x"12", x"1D", x"03", x"06", x"1C", x"1E", x"13", x"07", x"0E", x"00", x"0D", x"11", x"18", x"10", x"0C", x"01", x"19", x"16", x"0A", x"0F", x"17");
	
	signal sbox_s : bit8;

	begin
		
		-- conversion de bits en entier
		sbox_s <= sbox_c(to_integer(unsigned(data_i)));
		
		data_o <= sbox_s(4 downto 0);
			
end sbox_arch;
