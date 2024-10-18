
module ONCHIP_AUDIO_STORAGE (
	clk_clk,
	onchip_audio_data_address,
	onchip_audio_data_read,
	onchip_audio_data_readdata,
	onchip_audio_data_waitrequest,
	onchip_audio_data_readdatavalid,
	onchip_audio_data_burstcount,
	reset_reset_n);	

	input		clk_clk;
	input	[18:0]	onchip_audio_data_address;
	input		onchip_audio_data_read;
	output	[31:0]	onchip_audio_data_readdata;
	output		onchip_audio_data_waitrequest;
	output		onchip_audio_data_readdatavalid;
	input	[3:0]	onchip_audio_data_burstcount;
	input		reset_reset_n;
endmodule
