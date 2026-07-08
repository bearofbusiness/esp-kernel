pub extern const _stack_bottom: usize; //remember to get the addr of each
pub extern const _stack_top: usize;
pub extern const _bss_start: usize;
pub extern const _bss_end: usize;
// entry
export fn call_start_cpu0() callconv(.c) noreturn {
    defer while (true) {};

    // create the stack
    asm volatile ("mov a1, %[stack_top]"
        :
        : [stack_top] "r" (@intFromPtr(&_stack_top)),
        : .{ .a1 = true });
    startShim();
}

// idk i just want to use zig callconv
fn startShim() callconv(.c) noreturn {
    start();
    while (true) {}
}

fn start() void {
    var i: usize = 0;
    const bss: [*]u8 = @ptrCast(@constCast(&_bss_start));
    const max = @intFromPtr(&_bss_start) - @intFromPtr(&_bss_end);
    while (i < max) : (i += 1) {
        bss[i] = 0;
    }
}
