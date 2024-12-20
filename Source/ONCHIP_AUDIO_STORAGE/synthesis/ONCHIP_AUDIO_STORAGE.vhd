-- ONCHIP_AUDIO_STORAGE.vhd

-- Generated using ACDS version 23.1 993

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ONCHIP_AUDIO_STORAGE is
	port (
		clk_clk                         : in  std_logic                     := '0';             --               clk.clk
		onchip_audio_data_address       : in  std_logic_vector(18 downto 0) := (others => '0'); -- onchip_audio_data.address
		onchip_audio_data_read          : in  std_logic                     := '0';             --                  .read
		onchip_audio_data_readdata      : out std_logic_vector(31 downto 0);                    --                  .readdata
		onchip_audio_data_waitrequest   : out std_logic;                                        --                  .waitrequest
		onchip_audio_data_readdatavalid : out std_logic;                                        --                  .readdatavalid
		onchip_audio_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => '0'); --                  .burstcount
		reset_reset_n                   : in  std_logic                     := '0'              --             reset.reset_n
	);
end entity ONCHIP_AUDIO_STORAGE;

architecture rtl of ONCHIP_AUDIO_STORAGE is
	component altera_onchip_flash is
		generic (
			INIT_FILENAME                       : string  := "";
			INIT_FILENAME_SIM                   : string  := "";
			DEVICE_FAMILY                       : string  := "Unknown";
			PART_NAME                           : string  := "Unknown";
			DEVICE_ID                           : string  := "Unknown";
			SECTOR1_START_ADDR                  : integer := 0;
			SECTOR1_END_ADDR                    : integer := 0;
			SECTOR2_START_ADDR                  : integer := 0;
			SECTOR2_END_ADDR                    : integer := 0;
			SECTOR3_START_ADDR                  : integer := 0;
			SECTOR3_END_ADDR                    : integer := 0;
			SECTOR4_START_ADDR                  : integer := 0;
			SECTOR4_END_ADDR                    : integer := 0;
			SECTOR5_START_ADDR                  : integer := 0;
			SECTOR5_END_ADDR                    : integer := 0;
			MIN_VALID_ADDR                      : integer := 0;
			MAX_VALID_ADDR                      : integer := 0;
			MIN_UFM_VALID_ADDR                  : integer := 0;
			MAX_UFM_VALID_ADDR                  : integer := 0;
			SECTOR1_MAP                         : integer := 0;
			SECTOR2_MAP                         : integer := 0;
			SECTOR3_MAP                         : integer := 0;
			SECTOR4_MAP                         : integer := 0;
			SECTOR5_MAP                         : integer := 0;
			ADDR_RANGE1_END_ADDR                : integer := 0;
			ADDR_RANGE2_END_ADDR                : integer := 0;
			ADDR_RANGE1_OFFSET                  : integer := 0;
			ADDR_RANGE2_OFFSET                  : integer := 0;
			ADDR_RANGE3_OFFSET                  : integer := 0;
			AVMM_DATA_ADDR_WIDTH                : integer := 19;
			AVMM_DATA_DATA_WIDTH                : integer := 32;
			AVMM_DATA_BURSTCOUNT_WIDTH          : integer := 4;
			SECTOR_READ_PROTECTION_MODE         : integer := 31;
			FLASH_SEQ_READ_DATA_COUNT           : integer := 2;
			FLASH_ADDR_ALIGNMENT_BITS           : integer := 1;
			FLASH_READ_CYCLE_MAX_INDEX          : integer := 4;
			FLASH_RESET_CYCLE_MAX_INDEX         : integer := 29;
			FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX  : integer := 112;
			FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX : integer := 40603248;
			FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX : integer := 35382;
			PARALLEL_MODE                       : boolean := true;
			READ_AND_WRITE_MODE                 : boolean := true;
			WRAPPING_BURST_MODE                 : boolean := false;
			IS_DUAL_BOOT                        : string  := "False";
			IS_ERAM_SKIP                        : string  := "False";
			IS_COMPRESSED_IMAGE                 : string  := "False"
		);
		port (
			clock                   : in  std_logic                     := 'X';             -- clk
			reset_n                 : in  std_logic                     := 'X';             -- reset_n
			avmm_data_addr          : in  std_logic_vector(18 downto 0) := (others => 'X'); -- address
			avmm_data_read          : in  std_logic                     := 'X';             -- read
			avmm_data_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			avmm_data_waitrequest   : out std_logic;                                        -- waitrequest
			avmm_data_readdatavalid : out std_logic;                                        -- readdatavalid
			avmm_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- burstcount
			avmm_data_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avmm_data_write         : in  std_logic                     := 'X';             -- write
			avmm_csr_addr           : in  std_logic                     := 'X';             -- address
			avmm_csr_read           : in  std_logic                     := 'X';             -- read
			avmm_csr_writedata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avmm_csr_write          : in  std_logic                     := 'X';             -- write
			avmm_csr_readdata       : out std_logic_vector(31 downto 0)                     -- readdata
		);
	end component altera_onchip_flash;

	component altera_reset_controller is
		generic (
			NUM_RESET_INPUTS          : integer := 6;
			OUTPUT_RESET_SYNC_EDGES   : string  := "deassert";
			SYNC_DEPTH                : integer := 2;
			RESET_REQUEST_PRESENT     : integer := 0;
			RESET_REQ_WAIT_TIME       : integer := 1;
			MIN_RST_ASSERTION_TIME    : integer := 3;
			RESET_REQ_EARLY_DSRT_TIME : integer := 1;
			USE_RESET_REQUEST_IN0     : integer := 0;
			USE_RESET_REQUEST_IN1     : integer := 0;
			USE_RESET_REQUEST_IN2     : integer := 0;
			USE_RESET_REQUEST_IN3     : integer := 0;
			USE_RESET_REQUEST_IN4     : integer := 0;
			USE_RESET_REQUEST_IN5     : integer := 0;
			USE_RESET_REQUEST_IN6     : integer := 0;
			USE_RESET_REQUEST_IN7     : integer := 0;
			USE_RESET_REQUEST_IN8     : integer := 0;
			USE_RESET_REQUEST_IN9     : integer := 0;
			USE_RESET_REQUEST_IN10    : integer := 0;
			USE_RESET_REQUEST_IN11    : integer := 0;
			USE_RESET_REQUEST_IN12    : integer := 0;
			USE_RESET_REQUEST_IN13    : integer := 0;
			USE_RESET_REQUEST_IN14    : integer := 0;
			USE_RESET_REQUEST_IN15    : integer := 0;
			ADAPT_RESET_REQUEST       : integer := 0
		);
		port (
			reset_in0      : in  std_logic := 'X'; -- reset
			clk            : in  std_logic := 'X'; -- clk
			reset_out      : out std_logic;        -- reset
			reset_req      : out std_logic;        -- reset_req
			reset_req_in0  : in  std_logic := 'X'; -- reset_req
			reset_in1      : in  std_logic := 'X'; -- reset
			reset_req_in1  : in  std_logic := 'X'; -- reset_req
			reset_in2      : in  std_logic := 'X'; -- reset
			reset_req_in2  : in  std_logic := 'X'; -- reset_req
			reset_in3      : in  std_logic := 'X'; -- reset
			reset_req_in3  : in  std_logic := 'X'; -- reset_req
			reset_in4      : in  std_logic := 'X'; -- reset
			reset_req_in4  : in  std_logic := 'X'; -- reset_req
			reset_in5      : in  std_logic := 'X'; -- reset
			reset_req_in5  : in  std_logic := 'X'; -- reset_req
			reset_in6      : in  std_logic := 'X'; -- reset
			reset_req_in6  : in  std_logic := 'X'; -- reset_req
			reset_in7      : in  std_logic := 'X'; -- reset
			reset_req_in7  : in  std_logic := 'X'; -- reset_req
			reset_in8      : in  std_logic := 'X'; -- reset
			reset_req_in8  : in  std_logic := 'X'; -- reset_req
			reset_in9      : in  std_logic := 'X'; -- reset
			reset_req_in9  : in  std_logic := 'X'; -- reset_req
			reset_in10     : in  std_logic := 'X'; -- reset
			reset_req_in10 : in  std_logic := 'X'; -- reset_req
			reset_in11     : in  std_logic := 'X'; -- reset
			reset_req_in11 : in  std_logic := 'X'; -- reset_req
			reset_in12     : in  std_logic := 'X'; -- reset
			reset_req_in12 : in  std_logic := 'X'; -- reset_req
			reset_in13     : in  std_logic := 'X'; -- reset
			reset_req_in13 : in  std_logic := 'X'; -- reset_req
			reset_in14     : in  std_logic := 'X'; -- reset
			reset_req_in14 : in  std_logic := 'X'; -- reset_req
			reset_in15     : in  std_logic := 'X'; -- reset
			reset_req_in15 : in  std_logic := 'X'  -- reset_req
		);
	end component altera_reset_controller;

	signal rst_controller_reset_out_reset           : std_logic; -- rst_controller:reset_out -> rst_controller_reset_out_reset:in
	signal reset_reset_n_ports_inv                  : std_logic; -- reset_reset_n:inv -> rst_controller:reset_in0
	signal rst_controller_reset_out_reset_ports_inv : std_logic; -- rst_controller_reset_out_reset:inv -> ONCHIP_AUDIO_DATA:reset_n

begin

	onchip_audio_data : component altera_onchip_flash
		generic map (
			INIT_FILENAME                       => "",
			INIT_FILENAME_SIM                   => "C:/Users/admin/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/TEST_SINE_1kHz_WAV.mif",
			DEVICE_FAMILY                       => "MAX 10",
			PART_NAME                           => "10M50DAF484C7G",
			DEVICE_ID                           => "50",
			SECTOR1_START_ADDR                  => 0,
			SECTOR1_END_ADDR                    => 8191,
			SECTOR2_START_ADDR                  => 8192,
			SECTOR2_END_ADDR                    => 16383,
			SECTOR3_START_ADDR                  => 16384,
			SECTOR3_END_ADDR                    => 114687,
			SECTOR4_START_ADDR                  => 114688,
			SECTOR4_END_ADDR                    => 188415,
			SECTOR5_START_ADDR                  => 188416,
			SECTOR5_END_ADDR                    => 360447,
			MIN_VALID_ADDR                      => 0,
			MAX_VALID_ADDR                      => 360447,
			MIN_UFM_VALID_ADDR                  => 0,
			MAX_UFM_VALID_ADDR                  => 188415,
			SECTOR1_MAP                         => 1,
			SECTOR2_MAP                         => 2,
			SECTOR3_MAP                         => 3,
			SECTOR4_MAP                         => 4,
			SECTOR5_MAP                         => 5,
			ADDR_RANGE1_END_ADDR                => 360447,
			ADDR_RANGE2_END_ADDR                => 360447,
			ADDR_RANGE1_OFFSET                  => 2048,
			ADDR_RANGE2_OFFSET                  => 0,
			ADDR_RANGE3_OFFSET                  => 0,
			AVMM_DATA_ADDR_WIDTH                => 19,
			AVMM_DATA_DATA_WIDTH                => 32,
			AVMM_DATA_BURSTCOUNT_WIDTH          => 4,
			SECTOR_READ_PROTECTION_MODE         => 31,
			FLASH_SEQ_READ_DATA_COUNT           => 4,
			FLASH_ADDR_ALIGNMENT_BITS           => 2,
			FLASH_READ_CYCLE_MAX_INDEX          => 5,
			FLASH_RESET_CYCLE_MAX_INDEX         => 12,
			FLASH_BUSY_TIMEOUT_CYCLE_MAX_INDEX  => 60,
			FLASH_ERASE_TIMEOUT_CYCLE_MAX_INDEX => 17500000,
			FLASH_WRITE_TIMEOUT_CYCLE_MAX_INDEX => 15250,
			PARALLEL_MODE                       => true,
			READ_AND_WRITE_MODE                 => false,
			WRAPPING_BURST_MODE                 => false,
			IS_DUAL_BOOT                        => "False",
			IS_ERAM_SKIP                        => "True",
			IS_COMPRESSED_IMAGE                 => "True"
		)
		port map (
			clock                   => clk_clk,                                  --    clk.clk
			reset_n                 => rst_controller_reset_out_reset_ports_inv, -- nreset.reset_n
			avmm_data_addr          => onchip_audio_data_address,                --   data.address
			avmm_data_read          => onchip_audio_data_read,                   --       .read
			avmm_data_readdata      => onchip_audio_data_readdata,               --       .readdata
			avmm_data_waitrequest   => onchip_audio_data_waitrequest,            --       .waitrequest
			avmm_data_readdatavalid => onchip_audio_data_readdatavalid,          --       .readdatavalid
			avmm_data_burstcount    => onchip_audio_data_burstcount,             --       .burstcount
			avmm_data_writedata     => "00000000000000000000000000000000",       -- (terminated)
			avmm_data_write         => '0',                                      -- (terminated)
			avmm_csr_addr           => '0',                                      -- (terminated)
			avmm_csr_read           => '0',                                      -- (terminated)
			avmm_csr_writedata      => "00000000000000000000000000000000",       -- (terminated)
			avmm_csr_write          => '0',                                      -- (terminated)
			avmm_csr_readdata       => open                                      -- (terminated)
		);

	rst_controller : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => reset_reset_n_ports_inv,        -- reset_in0.reset
			clk            => clk_clk,                        --       clk.clk
			reset_out      => rst_controller_reset_out_reset, -- reset_out.reset
			reset_req      => open,                           -- (terminated)
			reset_req_in0  => '0',                            -- (terminated)
			reset_in1      => '0',                            -- (terminated)
			reset_req_in1  => '0',                            -- (terminated)
			reset_in2      => '0',                            -- (terminated)
			reset_req_in2  => '0',                            -- (terminated)
			reset_in3      => '0',                            -- (terminated)
			reset_req_in3  => '0',                            -- (terminated)
			reset_in4      => '0',                            -- (terminated)
			reset_req_in4  => '0',                            -- (terminated)
			reset_in5      => '0',                            -- (terminated)
			reset_req_in5  => '0',                            -- (terminated)
			reset_in6      => '0',                            -- (terminated)
			reset_req_in6  => '0',                            -- (terminated)
			reset_in7      => '0',                            -- (terminated)
			reset_req_in7  => '0',                            -- (terminated)
			reset_in8      => '0',                            -- (terminated)
			reset_req_in8  => '0',                            -- (terminated)
			reset_in9      => '0',                            -- (terminated)
			reset_req_in9  => '0',                            -- (terminated)
			reset_in10     => '0',                            -- (terminated)
			reset_req_in10 => '0',                            -- (terminated)
			reset_in11     => '0',                            -- (terminated)
			reset_req_in11 => '0',                            -- (terminated)
			reset_in12     => '0',                            -- (terminated)
			reset_req_in12 => '0',                            -- (terminated)
			reset_in13     => '0',                            -- (terminated)
			reset_req_in13 => '0',                            -- (terminated)
			reset_in14     => '0',                            -- (terminated)
			reset_req_in14 => '0',                            -- (terminated)
			reset_in15     => '0',                            -- (terminated)
			reset_req_in15 => '0'                             -- (terminated)
		);

	reset_reset_n_ports_inv <= not reset_reset_n;

	rst_controller_reset_out_reset_ports_inv <= not rst_controller_reset_out_reset;

end architecture rtl; -- of ONCHIP_AUDIO_STORAGE
