library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops
--use ieee.std_logic_unsigned.all;


entity counter8X_rx is  --contatore a 2 bit
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(8 downto 0);
			tc: out std_logic
			);
end counter8X_rx;

architecture behavioural of counter8X_rx is

constant one: std_logic_vector(8 downto 0):= "000000001"; --constant to add one
--constant N: std_logic_vector(11 downto 0):="101000101011"; --2603 to binar
signal count_sig: std_logic_vector(8 downto 0); --


begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000000000";
					tc<='0';
				else --se non è resettato conta
						if(en = '1') then -- se enable è attivo allora conta
						
							
							if (count_sig= "101000011") then
	
								count_sig <="000000000"; --azzeramento del contatore
								tc<='0';
								
												
							else

							--count_sig <= count_sig + one;
							--faccio un casting in unsigned
							
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								tc<= '0';
									if( count_sig = "101000010") then  -- operatore "diverso" /=
									tc <= '1';
									end if;
								--count_sig <= count_sig +1;
							end if;
						--non devo comprire anche l'else perchè il processo è sensibile solo al clock
						
						
					--faccio somma tra unsigned
				end if;
			end if;
		end if;
	end process counter_process;
	count <= count_sig;
	
		
end  behavioural;