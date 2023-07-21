module FFT_cross#(parameter SIZE, BITS, RESOLUTION = 4)
(
    input logic signed[BITS - 1 : 0] in_re[SIZE],
    input logic signed[BITS - 1 : 0] in_im[SIZE],
    output logic signed[BITS - 1 : 0] out_re[SIZE],
    output logic signed[BITS - 1 : 0] out_im[SIZE]
);

localparam PI = $acos(-1);

logic signed[RESOLUTION + 1 : 0] w_re[SIZE / 2];
logic signed[RESOLUTION + 1 : 0] w_im[SIZE / 2];

always_comb begin
    for(int i = 0; i < SIZE / 2; i++) begin
        w_re[i] = $cos(-2 * PI * i / SIZE) * (2 ** RESOLUTION);
        w_im[i] = $sin(-2 * PI * i / SIZE) * (2 ** RESOLUTION);
    end
end

logic signed[BITS - 1 : 0] adjusted_re[SIZE];
logic signed[BITS - 1 : 0] adjusted_im[SIZE];

always_comb begin
    for(int i = 0; i < SIZE / 2; i++) begin
        adjusted_re[i] = in_re[i];
        adjusted_re[i + SIZE / 2] = $signed((in_re[i + SIZE / 2] * w_re[i]) - (in_im[i + SIZE / 2] * w_im[i])) >>> RESOLUTION;

        adjusted_im[i] = in_im[i];
        adjusted_im[i + SIZE / 2] = $signed((in_im[i + SIZE / 2] * w_re[i]) + (in_re[i + SIZE / 2] * w_im[i])) >>> RESOLUTION;
    end
end

always_comb begin
    for(int i = 0; i < SIZE / 2; i++) begin
        //assign out[i] = in[i] + w[i] * in[i + SIZE / 2];
        out_re[i] = adjusted_re[i] + adjusted_re[i + SIZE / 2];
        out_im[i] = adjusted_im[i] + adjusted_im[i + SIZE / 2];

        //assign out[i + SIZE / 2] = in[i] - w[i] * in[i + SIZE / 2];
        out_re[i + SIZE / 2] = adjusted_re[i] - adjusted_re[i + SIZE / 2];
        out_im[i + SIZE / 2] = adjusted_im[i] - adjusted_im[i + SIZE / 2];
    end
end
endmodule