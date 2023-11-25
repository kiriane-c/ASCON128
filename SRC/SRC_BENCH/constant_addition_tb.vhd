-------------------------------------------------------------------------------
-- File	      : constant_addition_tb.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-03
-- Last update: 2022-11-07
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du testbench de l'addition de constante
-- Entrées: state_i, counter_i
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

entity constant_addition_tb is
end entity constant_addition_tb;

architecture constant_addition_tb_arch of constant_addition_tb is
	component constant_addition port(
		state_i : type_state;
		counter_i : bit4;
		state_o : out type_state);
	end component;


	signal state_is, state_os : type_state;
	signal counter_s : bit4;

begin
	DUT : constant_addition port map(
		state_i => state_is,
		counter_i => counter_s,
		state_o => state_os);
		
	--stimuli
	--(concaténation de IV, la clé K et le nonce N)
	state_is <= (x"80400c0600000000", x"0001020304050607", x"08090a0b0c0d0e0f", x"0001020304050607", x"08090a0b0c0d0e0f");
	
	counter_s <= "0000" after 10 ns, "0001" after 20 ns, "0010" after 30 ns;

end constant_addition_tb_arch;

configuration constant_addition_tb_conf of constant_addition_tb is
	for constant_addition_tb_arch
		for DUT : constant_addition
			use entity LIB_RTL.constant_addition(constant_addition_arch);
		end for;
	end for;
end constant_addition_tb_conf;
