-------------------------------------------------------------------------------
-- File	      : xor_end.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-23
-- Last update: 2022-11-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception de l'opération xor de fin
-- Entrées: state_i, key_i, en_key_xor_end_i, en_bypass_i
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

entity xor_end is

	port(
			state_i : in type_state;
			key_i : in bit128;	-- la clé K
			en_bypass_i : in std_logic;	-- bypass xor end
			en_key_xor_end_i : in std_logic; -- enable xor end
			state_o : out type_state);
		
end xor_end;

architecture xor_end_arch of xor_end is 

	signal data_inter_s : bit128;

begin
	
	-- On traite au cas par cas pour chaque mot ; x0, x1, x2, x3 et x4

	-- Le cas 1 : Bypass quand (en_bypass_i = '1' et en_key_i = '0'), les états ne changent pas. 
	-- Le cas 2 : quand (en_bypass_i = '0' et en_key_i = '1'), la sortie est state xor "0...0"&K
	-- Le cas 3 : quand (en_bypass_i = '1' et en_key_i = '1'), la sortie est state xor K&"0...0"
	-- Le cas 4 : quand (en_bypass_i = '0' et en_key_i = '0'), la sortie est state xor "0...0"&1
	
	state_o(0) <= state_i(0); -- Pour tous les cas, x0 reste inchangé
	
	data_inter_s <= key_i xor (state_i(1)&state_i(2)) when (en_bypass_i = '1' and en_key_xor_end_i = '1') else -- cas 3 
									state_i(1)&state_i(2);	-- Pour les autres cas, x1 et x2 restent inchangés
									
	state_o(1) <= data_inter_s(127 downto 64); -- prend les 64 premiers bits du signal data_inter_s
								
	state_o(2) <= data_inter_s(63 downto 0); -- prend les 64 derniers bits du signal data_inter_s
	
	state_o(3) <= state_i(3) xor key_i(127 downto 64) when (en_bypass_i = '0' and en_key_xor_end_i = '1') else -- cas 2
								state_i(3);	-- Pour les autres cas, x3 ne change pas
								
	state_o(4) <= state_i(4) xor key_i(63 downto 0) when (en_bypass_i = '0' and en_key_xor_end_i = '1') else -- cas 2
								state_i(4) xor x"0000000000000001" when (en_bypass_i = '0' and en_key_xor_end_i = '0') else -- cas 4
								state_i(4); -- Autres cas x4 ne change pas
		
end xor_end_arch;
