---------------------------------------------------------------------------------------------------------------------------
-- File	      : fsm_moore_initialisation.vhd
-- Author     : Audrey NGUEGO  <audrey.nguegochimi@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-24
-- Last update: 2022-11-24
-- Standard   : VHDL'93/02
---------------------------------------------------------------------------------------------------------------------------
-- Description:	 conception de la machine d'état de type Moore de la phase d'initialisation
-- Entrées: clock_i, resetb_i, start_i, round_i
-- Sorties: data_sel_o, end_o, en_cpt_o, init_0_o, init_6_o, en_xor_begin_o, en_reg_state_o, en_bypass_o, en_key_xor_end_o
---------------------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2022 
---------------------------------------------------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-10-24  1.0	nguego	Created
---------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_RTL;
use lib_rtl.ascon_pack.all;

entity fsm_moore_initialisation is
  port (
    clock_i	 : in std_logic;
    resetb_i	 : in std_logic;
    start_i	 : in std_logic;
    round_i	 : in bit4;

    data_sel_o : out std_logic;
    end_o	: out std_logic;
    en_cpt_o : out std_logic;	-- active compteur double
    init_0_o : out std_logic;	-- la constante de ronde commence à 0 (p12)
    init_6_o : out std_logic; -- la constante de ronde commence à 6 (p6)
    en_xor_begin_o : out std_logic;	-- active xor_begin
    en_reg_state_o : out std_logic;	
    en_bypass_o : out std_logic;	-- bypass xor_end
    en_key_xor_end_o : out std_logic);	-- active xor_end

end entity fsm_moore_initialisation; -- machine d'état de type Moore

-- c'est la machine d'état qui va gérer l'ensemble des sous modules du chiffrement ASCON

-- fsm_initialisation gère la première phase du chiffrement ASCON; l'initialisation incluant une permutation p12,
-- les opérations de xor de début et de fin

architecture fsm_moore_initialisation_arch of fsm_moore_initialisation is

  type fsm_state is (attente, conf_init, init_ronde0, initialisation, end_init, fin); -- les états de la machine
  signal etat_present : fsm_state;
  signal etat_futur    : fsm_state;
  
begin  -- architecture fsm_initialisation_arch

  seq0 : process (clock_i, resetb_i) is
  begin	 -- process seq0
    if (resetb_i = '0') then		-- asynchronous reset (active low)
      etat_present <= attente;
      
    elsif (clock_i'event and clock_i = '1') then  -- rising clock edge
      etat_present <= etat_futur;
    end if;
  end process seq0;

	comb_0 : process (etat_present, start_i, round_i) is -- la machine dépend de l'état present, le start_i et la constante de ronde, round_i
		begin	 -- process comb_0
		  case etat_present is
		  
	      when attente => -- l'état est initialement en attente
	          if (start_i = '1') then -- quand start_i passe à 1, l'état futur est la configuration de l'initialisation
	              etat_futur <= conf_init;
	          else
	              etat_futur <= attente; -- sinon, on reste en attente
	          end if;
	          
	      when conf_init => 
		      etat_futur <= init_ronde0; -- on passe à initialisation de la ronde
		      
	      when init_ronde0 =>
		      etat_futur <= initialisation; -- on passe à l'initialisation propre
		      
	      when initialisation =>
	          if (round_i = x"A") then -- durant la permutation, si la constante de ronde vaut 10, on passe à la fin l'initialisation
	              etat_futur <= end_init;
	          else
	              etat_futur <= initialisation;
	          end if;
	          
	      when end_init=>
		      etat_futur <= fin; -- on passe à la fin de la phase

	      when fin =>
		      etat_futur <= attente; -- à la fin de la phase, on se remet en attente en attendant à nouveau start_i
	
	      when others => etat_futur <= attente;
	      
		  end case;
		end process comb_0;

  comb_1 : process (etat_present) is
		begin	 -- process comb_1
		  
		  -- valeurs par défaut des stimuli de la FSM
		  data_sel_o <= '0';
		  end_o <= '0';
		  en_cpt_o <= '0';
		  init_0_o <= '0';
		  init_6_o <= '0';
		  en_xor_begin_o <= '0';
		  en_bypass_o  <= '1';
		  en_key_xor_end_o <= '0';
		  en_reg_state_o <= '0';

		  case etat_present is
	      when attente =>
          en_reg_state_o <= '1'; -- on sauvegarde le state dans chaque état de la machine
	          
	      when conf_init =>
          en_cpt_o <= '1';	-- on active le compteur de ronde
          init_0_o <= '1';	-- on active le début de la ronde à 0
          en_reg_state_o <= '1'; -- state sauvegardé

	      when init_ronde0 =>
          en_cpt_o <= '1';
          en_reg_state_o <= '1';

	      when initialisation =>
          en_cpt_o <= '1';
          data_sel_o <= '1';	-- le state en entrée n'est plus la valeur initiale mais ceux en sortie du registre
         	en_reg_state_o <= '1';

	      when end_init =>
          en_cpt_o <= '1';
          data_sel_o <= '1';
          
          -- cas 2 du xor_end (en_bypass_i = '0' et en_key_i = '1'), la sortie est state xor "0...0"&K
          en_bypass_o  <= '0';
          en_key_xor_end_o <= '1';
          en_reg_state_o <= '1';

	      when fin =>
          end_o <= '1';	-- indique la fin de la phase
          en_reg_state_o <= '1'; -- state toujours sauvegardé

	      when others =>

		  end case;
  end process comb_1;

end architecture fsm_moore_initialisation_arch;
