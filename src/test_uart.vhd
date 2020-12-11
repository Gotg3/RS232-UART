library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity test_uart is
end test_uart;

architecture dut of test_uart is

signal clk_sig: std_logic:='0';
signal d_out_sig:  std_logic_vector(7 downto 0);--D_out
signal d_in_sig:  std_logic_vector(7 downto 0);
signal rst_sig: std_logic;
signal ack_sig:  std_logic;
signal data_valid_sig:  std_logic;
--signal TX_sig: std_logic; -- per testare si è collegato tx ed rx insiame con un signal
--signal RX_sig: std_logic;
signal Tx_rdy_sig: std_logic;
signal Rx_rdy_sig: std_logic;
signal Tx_RX_sig: std_logic;

component UART is 

port(d_out: in std_logic_vector(7 downto 0);--D_out
     d_in: out std_logic_vector(7 downto 0);
	  CLOCK_25: in std_logic;
	  rst:in std_logic;
	  data_valid:in std_logic;
	  ack:in std_logic;
	  TX: out std_logic;
	  RX: in std_logic; --ricontrollare le porte della uart
	  Tx_rdy: out std_logic;
	  Rx_rdy: out std_logic
	  );
	  
end component;

begin

uart_test: UART
port map(
	d_out=>d_out_sig,
	d_in=>d_in_sig,
	CLOCK_25=>clk_sig,
	rst=>rst_sig,
	data_valid=>data_valid_sig,
	ack=>ack_sig,
	TX=>TX_RX_sig,
	RX=>TX_RX_sig,
	Tx_rdy=>Tx_rdy_sig,
	Rx_rdy=>Rx_rdy_sig
	);
	
	clk_sig <= not(clk_sig) after 20 ns;--periodo 40 ns
	
	
	stimuli: process 
	begin
	data_valid_sig<='0';
	ack_sig<='0';
	D_out_sig<="10000100";
	rst_sig<='1';
	wait for 30 ns;
	rst_sig<='0';
	wait for 100 us;
	data_valid_sig<='1';
	wait for 80 ns;
	data_valid_sig<='0';
	wait for 1100 us;
	ack_sig<='1';
	wait for 80 ns;
	ack_sig<='0';
	wait for 100 us;
	
	wait for 80 ns;
	D_out_sig<="11100100";
	wait for 40 ns;
	data_valid_sig<='1';
	wait for 80 ns;
	data_valid_sig<='0';
	wait for 1500 us;
	ack_sig<='1';
	wait for 80 ns;
	ack_sig<='0';
	wait for 80 ns;
	wait;
end process;
end dut;