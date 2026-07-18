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
    start();
    while (true) {}
}

fn start() void {
    //var i: usize = 0;
    const bss: [*]u8 = @ptrCast(@constCast(&_bss_start));
    const max = @intFromPtr(&_bss_end) - @intFromPtr(&_bss_start);
    // while (i < max) : (i += 1) {
    //     bss[i] = 0;
    // }
    @memset(bss[0..max], 0);

    uart0Write("testprint lol\n\r");
}

const UART0_BASE = 0x3FF40000;
const UART0_FIFO = UART0_BASE + 0x00;
const UART0_STATUS = UART0_BASE + 0x1C;

fn uart0CharWrite(c: u8) void {
    while (mmioRead32(UART0_STATUS) >> 16 & 0xff >= 127) {}
    mmioWrite32(UART0_FIFO, c);
}

fn uart0Write(str: []const u8) void {
    for (str) |c| {
        uart0CharWrite(c);
    }
}

fn mmioWrite32(address: usize, value: usize) void {
    const ptr: *volatile usize = @ptrFromInt(address);
    ptr.* = value;
}

fn mmioRead32(address: usize) usize {
    const ptr: *volatile usize = @ptrFromInt(address);
    return ptr.*;
}

const RTC_CNTL_BASE = 0x3FF48000;

const RTC_CNTL_WDTCONFIG0 = 0x3FF4808C;
const RTC_CNTL_WDTFEED = 0x3FF480A0;
const RTC_CNTL_WDTWPROTECT = 0x3FF480A4;
const RTC_CNTL_WDT_WKEY = 0x50D83AA1;
