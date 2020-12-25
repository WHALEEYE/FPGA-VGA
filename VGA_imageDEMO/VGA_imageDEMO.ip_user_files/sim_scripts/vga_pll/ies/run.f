-makelib ies_lib/xil_defaultlib -sv \
  "D:/vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../VGA_imageDEMO.srcs/sources_1/ip/vga_pll/vga_pll_clk_wiz.v" \
  "../../../../VGA_imageDEMO.srcs/sources_1/ip/vga_pll/vga_pll.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

