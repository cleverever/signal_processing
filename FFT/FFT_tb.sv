module FFT_tb();

logic clk;

logic signed[31 : 0] in[8];
logic signed[31 : 0] out_re[8];
logic signed[31 : 0] out_im[8];


FFT #(.SIZE(8)) fft
(
    .in(in),
    .out_re(out_re),
    .out_im(out_im)
);

initial begin
    clk = 1'b0;
    in = '{1, 2, 4, 8, 16, 32, 64, 128};
end

always begin
    clk <= ~clk;
    #10ns;
end
endmodule