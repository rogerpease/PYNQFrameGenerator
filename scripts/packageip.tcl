create_project project_1 ./project_1 -part xc7vx485tffg1157-1
ipx::infer_core -vendor user.org -library user -taxonomy /UserIP ./Verilog/module
ipx::edit_ip_in_project -upgrade true -name edit_ip_project -directory ./project_1/project_1.tmp ./Verilog/module/component.xml
ipx::current_core ./Verilog/module/component.xml
update_compile_order -fileset sources_1
close_project
ipx::infer_core -vendor user.org -library user -taxonomy /UserIP ./Verilog/module
ipx::edit_ip_in_project -upgrade true -name edit_ip_project -directory ./project_1/project_1.tmp ./Verilog/module/component.xml
ipx::current_core ./Verilog/module/component.xml
update_compile_order -fileset sources_1
ipx::package_project -root_dir ./Verilog/module -vendor rogerpease.com -library rogerpease -taxonomy /UserIP -force
ipx::merge_project_changes hdl_parameters [ipx::current_core]
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  ./Verilog/module [current_project]
update_ip_catalog
