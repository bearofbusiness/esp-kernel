pub extern const _stack_bottom: usize; //remember to get the addr of each
pub extern const _stack_top: usize;
pub extern const _bss_start: usize;
pub extern const _bss_end: usize;

export fn call_start_cpu0() callconv(.c) noreturn {
    // asm volatile (
    //     \\ movl %[stack_top], %%
    // );
    defer while (true) {};
}

fn start() callconv(.c) noreturn {
    defer while (true) {};
}
