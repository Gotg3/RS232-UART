library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- for the signed, unsigned types and arithmetic ops
--use ieee.std_logic_unsigned.all;


entity counter2_rx is  --contatore a 2 bit
	port(
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(14 downto 0);
			ttr: out std_logic
			);
end counter2_rx;

architecture behavioural of counter2_rx is

constant one: std_logic_vector(14 downto 0):= "000000000000001"; --constant to add one
--constant N: std_logic_vector(14 downto 0):="101000101011"; --2603 to binar
signal count_sig: std_logic_vector(14 downto 0); --

begin
	counter_process: process(clk)
	begin
			if(clk' event and clk= '1') then
				if(rst ='1') then
					count_sig <= "000000000000000";
					ttr <= '0';
				else --se non è resettato conta
						if(en = '1') then -- se enable è attivo allora conta
						
							if( count_sig = "100011011011111") then  
							
								count_sig<="000000000000000";						
								ttr <= '0';
--
							--count_sig <= count_sig + one;
							--faccio un casting in unsigned
							else 
								count_sig <= std_logic_vector(unsigned(count_sig)+ unsigned(one));
								ttr <= '0';
								--count_sig <= count_sig +1;
								if(count_sig = "100011011011110") then
								ttr<='1';
								end if;
							end if;
						--non devo comprire anche l'else perchè il processo è sensibile solo al clock
						
						end if;
					--faccio somma tra unsigned
				end if;
			end if;
	end process counter_process;

	count <= count_sig;
		
end behavioural;