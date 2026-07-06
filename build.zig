const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const target = b.standardTargetOptions(.{
        // .default_target = .{
        //     .cpu_arch = .xtensa,
        //     // .cpu_model = .{
        //     //     .explicit = &(std.Target.xtensa.cpu.generic),
        //     // },
        //     .os_tag = .freestanding,
        //     .abi = .none,
        // },
    });

    const exe = b.addExecutable(.{
        .name = "bear32",
        .root_module = b.addModule("main", .{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.setLinkerScript(b.path("boot.ld"));
    exe.entry = .{ .symbol_name = "call_start_cpu0" };

    exe.linkage = .static;
    exe.is_linking_libc = false;
    //exe.bundle_compiler_rt = false;

    b.installArtifact(exe);
}
