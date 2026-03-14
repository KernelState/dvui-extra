const std = @import("std");

pub const Backend = enum {
    custom,
    /// DEPRECATED: Use either sdl2 or sdl3
    sdl,
    sdl2,
    sdl3,
    sdl3gpu,
    raylib,
    raylib_zig,
    dx11,
    glfw_opengl,
    web,
    /// Does no rendering!
    testing,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("dvui_extra", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const lib = b.addLibrary(.{
        .name = "dvui_extra",
        .root_module = mod,
    });

    const mod_name = b.option([]const u8, "dvui_mod_name", "The name of the dvui module defaults to \"dvui_sdl3\"") orelse "dvui_sdl3";
    const renderer = b.option(Backend, "renderer", "The rendering backend defaults to `.sdl3`") orelse .sdl3;

    const dvui_dep = b.dependency("dvui", .{ .target = target, .optimize = optimize, .backend = renderer });
    lib.root_module.addImport("dvui", dvui_dep.module(mod_name));

    b.installArtifact(lib);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(lib);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
