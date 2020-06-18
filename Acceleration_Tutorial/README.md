<table width="100%">
 <tr width="100%">
    <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>2020.1 Vitis™ - Acceleration Tutorial</h1>
    <a href="https://www.xilinx.com/products/design-tools/vitis.html">See Vitis™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

This tutorial is divided in 3 sections.
* [**Section 1**](./Section_1-Workflows) (~10 mins):
  + A walkthrough of the algorithm chosen for the tutorial: the Cholesky decomposition 
  + Compile and run the non-accelerated version of the algorithm on the CPU
  + Evaluate the performance
* [**Section 2**](./Section_2-System_Setup) (a couple of mins):
  + Setup the Vitis development tools
  + Detect and check the card installed on the server 
* [**Section 3**](./Section_3-Algorithm_Acceleration) (a few hours):
  + Re-organize the code to create both a host and a kernel program
  + Review the APIs needed to bind the host and the kernel
  + Apply incremental optimizations to the kernel across several modules to improve throughput. Finally program the Alveo card with the fully optimized accelerator to verify the performance
  + [**Module 1:**](./docs/module1_baseline)
    * Get a performance baseline that can be used as a reference point
  + [**Module 2**](./docs/module2_pipeline)
    * Boost throughput with the HLS PIPELINE pragma
  + [**Module 3**](.docs/module3_dependency_removal)
    * Remove dependencies on memory accesses to improve performance
  + [**Module 4**](.docs/module4_flatten_loop)
    * Flatten loop to improve design
  + [**Module 5**](./docs/module5_dataflow)
    * Apply the task parallelism optimization pragma