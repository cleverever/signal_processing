module FFT_cross#(parameter SIZE, BITS, RESOLUTION = 4, TRUNCATION = 4)
(
    input logic[BITS - 1 : 0] in_re[SIZE],
    input logic[BITS - 1 : 0] in_im[SIZE],
    output logic[BITS + RESOLUTION - TRUNCATION : 0] out_re[SIZE],
    output logic[BITS + RESOLUTION - TRUNCATION : 0] out_im[SIZE]
);

localparam PI = $acos(-1);

logic[RESOLUTION - 1 : 0] w_r[SIZE / 2];
logic[RESOLUTION - 1 : 0] w_i[SIZE / 2];

always_comb begin
    for(int i = 0; i < SIZE / 2; i++) begin
        w_r[i] = RESOLUTION * $cos(PI * i / SIZE);
        w_i[i] = RESOLUTION * $sin(PI * i / SIZE);
    end
end

always_comb begin
    for(int i = 0; i < SIZE / 2; i++) begin
        //assign out[i] = in[i] + w[i] * in[i + SIZE / 2];
        out_re[i] = (in_re[i] + (w_r[i] * in_re[i + SIZE / 2]) - (w_i[i] * in_im[i + SIZE / 2])) >> TRUNCATION;
        out_im[i] = (in_im[i] + (w_r[i] * in_im[i + SIZE / 2]) + (w_i[i] * in_re[i + SIZE / 2])) >> TRUNCATION;

        //assign out[i + SIZE / 2] = in[i] - w[i] * in[i + SIZE / 2];
        out_re[i + SIZE / 2] = (in_re[i] + (w_i[i] * in_im[i + SIZE / 2]) - (w_r[i] * in_re[i + SIZE / 2])) >> TRUNCATION;
        out_im[i + SIZE / 2] = (in_im[i] - (w_i[i] * in_re[i + SIZE / 2]) - (w_r[i] * in_im[i + SIZE / 2])) >> TRUNCATION;
    end
end
endmodule