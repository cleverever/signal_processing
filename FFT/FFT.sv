module FFT#(parameter SIZE = 8, IN_BITS = 32, OUT_BITS = 32)
(
    input logic signed[IN_BITS - 1 : 0] in[SIZE],
    output logic signed[OUT_BITS - 1 : 0] out_re[SIZE],
    output logic signed[OUT_BITS - 1 : 0] out_im[SIZE]
);

localparam LEVELS = $clog2(SIZE);
localparam STEP_RESOLUTION = OUT_BITS - IN_BITS;

logic signed[IN_BITS - 1 : 0] bit_rev[SIZE];
for(genvar i = 0; i < SIZE; i++) begin
    assign bit_rev[{<<{i[$clog2(SIZE) - 1 : 0]}}] = in[i];
end

logic signed[OUT_BITS - 1 : 0] re[LEVELS + 1][SIZE];
logic signed[OUT_BITS - 1 : 0] im[LEVELS + 1][SIZE];

assign re[0] = bit_rev;
assign im[0] = '{default:0};
assign out_re = re[LEVELS];
assign out_im = im[LEVELS];

for(genvar i = 0; i < LEVELS; i++) begin : LEVEL
    for(genvar j = 0; j < SIZE; j = j + (2 ** (i + 1))) begin : SET
        FFT_cross #(.SIZE(2 ** (i + 1)), .BITS(32), .RESOLUTION(8)) c
        (
            .in_re(re[i][j +: (2 ** (i + 1))]),
            .in_im(im[i][j +: (2 ** (i + 1))]),
            .out_re(re[i + 1][j +: (2 ** (i + 1))]),
            .out_im(im[i + 1][j +: (2 ** (i + 1))])
        );
    end
end
endmodule