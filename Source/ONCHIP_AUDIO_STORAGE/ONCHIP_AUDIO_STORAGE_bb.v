
module ONCHIP_AUDIO_STORAGE (
	clk_clk,
	reset_reset_n,
	onchip_audio_data_address,
	onchip_audio_data_read,
	onchip_audio_data_readdata,
	onchip_audio_data_waitrequest,
	onchip_audio_data_readdatavalid,
	onchip_audio_data_burstcount);	

	input		clk_clk;
	input		reset_reset_n;
	input	[17:0]	onchip_audio_data_address;
	input		onchip_audio_data_read;
	output	[31:0]	onchip_audio_data_readdata;
	output		onchip_audio_data_waitrequest;
	output		onchip_audio_data_readdatavalid;
	input	[3:0]	onchip_audio_data_burstcount;
endmodule
