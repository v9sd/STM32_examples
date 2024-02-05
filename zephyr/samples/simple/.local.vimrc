let zephyr_sdk_path = '/opt/zephyr-sdk-0.16.1'
call insert(g:cmake_generate_options, "-GUnix Makefiles") 
call insert(g:cmake_generate_options, "-DBOARD:STRING=stm32f401_mini") 
call insert(g:cmake_generate_options, "-DZEPHYR_SDK_INSTALL_DIR:STRING=/opt/zephyr-sdk-0.16.1") 
call insert(g:cmake_generate_options, '-DCMAKE_C_COMPILER:STRING='.zephyr_sdk_path.'/arm-zephyr-eabi/bin/arm-zephyr-eabi-gcc')
call insert(g:cmake_generate_options, '-DCMAKE_CXX_COMPILER:STRING='.zephyr_sdk_path . '/arm-zephyr-eabi/bin/arm-zephyr-eabi-g++')
let zephyr_debugger = zephyr_sdk_path.'/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb'
let zephyr_bin_file = getcwd().'/../'.fnamemodify(getcwd(), ':t').'-build/Debug/zephyr/zephyr.elf'
let g:termdebugger = [zephyr_debugger, '-ex', 'file '.zephyr_bin_file, '-ex', 'target extended-remote localhost:3333']
let g:termdebug_wide = 163
" call TermDebugSendCommand('file '.zephyr_bin_file)
" let g:termdebug_config['command_add_args'] = ['-ex','file '.zephyr_bin_file]
"let file_zephyr_bin_file = 'file '.zephyr_bin_file
" let g:termdebug_config['command_add_args'] = ['-ex','target remote localhost:3333','-ex',file_zephyr_bin_file, '-ex', 'echo tralala']

" let g:termdebug_config = {}
" let g:termdebug_config['command'] = ['-ex','file '.zephyr_bin_file]
