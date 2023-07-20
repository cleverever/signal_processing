module FFT#(parameter SIZE = 8, IN_BITS = 32, OUT_BITS = 32)
(
    input logic[IN_BITS - 1 : 0] in[SIZE],
    output logic[OUT_BITS - 1 : 0] out_re[SIZE]
    output logic[OUT_BITS - 1 : 0] out_im[SIZE]
);

localparam LEVELS = $clog2(SIZE);

logic[IN_BITS - 1 : 0] bit_rev[SIZE];
for(logic unsigned[$clog2(SIZE) - 1 : 0] i = 0; i < SIZE; i++) begin
    assign bit_rev[{<<{i}}] = in[i];
end

logic[OUT_BITS - 1 : 0] re[LEVELS + 1][SIZE];
logic[OUT_BITS - 1 : 0] im[LEVELS + 1][SIZE];

assign re[0] = in;
assign im[0] = '{default:0};
assign out_re = re[LEVELS];
assign out_im = im[LEVELS];

for(int i = 0; i < LEVELS; i++) begin
    for(int j = 0; j < SIZE; j = j + (2 ** (i + 1))) begin
        FFT_cross#(.SIZE(i), .BITS()) cross
        (
            .in_re(re[i][j +: (2 ** (i + 1))]),
            .in_im(im[i][j +: (2 ** (i + 1))]),
            .out_re(re[i + 1][j +: (2 ** (i + 1))]),
            .out_im(im[i + 1][j +: (2 ** (i + 1))])
        );
    end
end
endmodule