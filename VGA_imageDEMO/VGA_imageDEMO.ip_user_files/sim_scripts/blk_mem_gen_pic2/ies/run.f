-makelib ies_lib/xil_defaultlib -sv \
  "D:/vivado/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../VGA_imageDEMO.srcs/sources_1/ip/blk_mem_gen_pic2/sim/blk_mem_gen_pic2.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

