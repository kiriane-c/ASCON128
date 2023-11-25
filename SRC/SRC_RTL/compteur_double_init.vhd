-------------------------------------------------------------------------------
-- Title      : Compteur double init
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : adder_double init.vhd
-- Author     : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2022-10-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 compteur avec deux signaux d'initialisation pour les valeurs a
-- ou b de la norme 12 et 6 pour notre cas
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-08-25  1.0	rigaud	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use LIB_RTL.ascon_pack.all;


entity compteur_double_init is
  
  port(
    clock_i  : in  std_logic;
    resetb_i : in  std_logic;
    enable_i : in  std_logic;
    init_0_i : in  std_logic;
    init_6_i : in  std_logic;
    compteur_o : out bit4);

end entity compteur_double_init;

architecture compteur_double_init_arch of compteur_double_init is

   signal compteur_s : integer range 0 to 15;

begin

    seq_0 : process (clock_i, resetb_i, enable_i, init_0_i, init_6_i) is

    begin 
        if resetb_i = '0' then
            compteur_s <= 0;
            
        elsif (clock_i'event and clock_i = '1') then -- rising clock
            if (enable_i = '1') then
                if (init_0_i = '1') then 
									compteur_s <= 0;
                elsif (init_6_i = '1') then
                	compteur_s <= 6;
                else 
                    if compteur_s = 11 then
                        compteur_s <= 0;
                    else
                        compteur_s <= compteur_s + 1;
                    end if;
                end if;
            else -- This statement for memorization is optional
							compteur_s <= compteur_s;
            end if;
            
        end if;
    end process seq_0;

    compteur_o <= std_logic_vector(to_unsigned(compteur_s, 4));

end architecture compteur_double_init_arch;
