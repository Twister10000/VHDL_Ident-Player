	Ident_Player u0 (
		.clk_clk                               (<connected-to-clk_clk>),                               //                     clk.clk
		.reset_reset_n                         (<connected-to-reset_reset_n>),                         //                   reset.reset_n
		.onchip_audio_flash_data_address       (<connected-to-onchip_audio_flash_data_address>),       // onchip_audio_flash_data.address
		.onchip_audio_flash_data_read          (<connected-to-onchip_audio_flash_data_read>),          //                        .read
		.onchip_audio_flash_data_readdata      (<connected-to-onchip_audio_flash_data_readdata>),      //                        .readdata
		.onchip_audio_flash_data_waitrequest   (<connected-to-onchip_audio_flash_data_waitrequest>),   //                        .waitrequest
		.onchip_audio_flash_data_readdatavalid (<connected-to-onchip_audio_flash_data_readdatavalid>), //                        .readdatavalid
		.onchip_audio_flash_data_burstcount    (<connected-to-onchip_audio_flash_data_burstcount>)     //                        .burstcount
	);

