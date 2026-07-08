/* ESP32 WROOM Second Stage Bootloader Linker Script */

MEMORY
{
  /* IRAM: Instruction RAM around 0x40078000 / 0x40080400 */
  iram (RWX) : ORIGIN = 0x40080400, LENGTH = 0xfc00

  /* DRAM: Data RAM around 0x3fff0000 */
  dram (RW) : ORIGIN = 0x3fff0000, LENGTH = 0x10000
}

/* Entry point */
ENTRY(call_start_cpu0);

SECTIONS
{
  /* IRAM sections: startup code, tiny text sections, interrupt code */
  .text :
  {
    . ALIGN(4);

    *(.literal) 
    *(.literal.*)
    *(.lit4)
    *(.lit4.*)

    KEEP(*(.entry))
    KEEP(*(.entry.*))

    *(.text)
    *(.text.*)
    
    *(.rodata)
    *(.rodata.*)

  } > iram

  /* DRAM sections: stack, bss, data, early rodata */
  .data :
  {
    *(.data)
    *(.data.*)
  } > dram /*AT > iram */

  .bss (NOLOAD) :
  {
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    _bss_end = .;
  } > dram

  /* Stack at end of DRAM */
  .stack (NOLOAD) :
  {
    . = ALIGN(4);
    _stack_bottom = .;
    . += 0x2000;
    _stack_top = .;
  } > dram

  /* Discard unnecessary sections */
  /DISCARD/ :
  {
    *(.note.GNU-stack)
    *(.gnu_debuglink)
    *(.gnu_debugdata)
    *(.eh_frame)
    *(.eh_frame.*)
    *(.eh_frame_hdr)
  }
}
