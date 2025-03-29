`timescale 1ns / 1ps

module fir_filter_tb;

    reg clk;
    reg rst;
    reg signed [15:0] data_in;
    wire signed [31:0] data_out;

    integer input_file, output_file, scan_file;
    
    // Instantiate the FIR filter module
    fir_filter_128 uut (
        .clk(clk),
        .rst(rst),
        .xin(data_in),
        .y_out(data_out)
    );

    // Clock generation (10ns period = 100 MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        data_in = 0;
        
        #10 rst = 0;  // Release reset

        // Open input file
        input_file = $fopen("test_data3.txt", "r");
        if (input_file == 0) begin
            $display("Error: Could not open input_data.txt");
            $finish;
        end

        // Open output file
        output_file = $fopen("test_data3_ouptut.txt", "w");
        if (output_file == 0) begin
            $display("Error: Could not create output_data.txt");
            $finish;
        end

        // Read and apply input samples
        while (!$feof(input_file)) begin
            scan_file = $fscanf(input_file, "%d\n", data_in);
            #10; // Wait for one clock cycle per sample
            $fwrite(output_file, "%d\n", data_out);  // Write output to file
        end

        #10 data_in = 0;  // Stop input signal
        
        // Close files after reading & writing
        $fclose(input_file);
        $fclose(output_file);

        #100;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%t | Input=%d | Output=%d", $time, data_in, data_out);
    end

endmodule
