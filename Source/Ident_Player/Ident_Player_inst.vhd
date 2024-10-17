	component Ident_Player is
		port (
			clk_clk                               : in  std_logic                     := 'X';             -- clk
			reset_reset_n                         : in  std_logic                     := 'X';             -- reset_n
			onchip_audio_flash_data_address       : in  std_logic_vector(17 downto 0) := (others => 'X'); -- address
			onchip_audio_flash_data_read          : in  std_logic                     := 'X';             -- read
			onchip_audio_flash_data_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			onchip_audio_flash_data_waitrequest   : out std_logic;                                        -- waitrequest
			onchip_audio_flash_data_readdatavalid : out std_logic;                                        -- readdatavalid
			onchip_audio_flash_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => 'X')  -- burstcount
		);
	end component Ident_Player;

	u0 : component Ident_Player
		port map (
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                     clk.clk
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                   reset.reset_n
			onchip_audio_flash_data_address       => CONNECTED_TO_onchip_audio_flash_data_address,       -- onchip_audio_flash_data.address
			onchip_audio_flash_data_read          => CONNECTED_TO_onchip_audio_flash_data_read,          --                        .read
			onchip_audio_flash_data_readdata      => CONNECTED_TO_onchip_audio_flash_data_readdata,      --                        .readdata
			onchip_audio_flash_data_waitrequest   => CONNECTED_TO_onchip_audio_flash_data_waitrequest,   --                        .waitrequest
			onchip_audio_flash_data_readdatavalid => CONNECTED_TO_onchip_audio_flash_data_readdatavalid, --                        .readdatavalid
			onchip_audio_flash_data_burstcount    => CONNECTED_TO_onchip_audio_flash_data_burstcount     --                        .burstcount
		);

