set ip_name axis_pfb_readout_v4

set ip_dir ../ip/${ip_name}

create_project -in_memory tmp

ipx::edit_ip_in_project -upgrade false -name ${ip_name}_sim_proj -directory ${ip_dir}/${ip_name}_sim_proj ${ip_dir}/component.xml
add_files -fileset sim_1 ${ip_dir}/src/tb/
add_files -fileset sim_1 -norecurse ${ip_dir}/src/axi_mst_0/axi_mst_0.xci

set_property library xil_defaultlib [get_files -of [get_filesets {sim_1, sources_1}] -filter {NAME =~ "*.v"}]
set_property library xil_defaultlib [get_files -of [get_filesets {sim_1, sources_1}] -filter {NAME =~ "*.sv"}]

set_property source_mgmt_mode None [current_project]
set_property top tb [get_filesets sim_1]
set_property source_mgmt_mode All [current_project]

upgrade_ip [get_ips]
generate_target all [get_files -filter {NAME =~ "*.xci"}]
export_ip_user_files -of_objects [get_ips] -no_script -sync -force -quiet

launch_simulation -scripts_only
cd ${ip_dir}/${ip_name}_sim_proj/${ip_name}_sim_proj.sim/sim_1/behav/xsim
launch_simulation
run all
