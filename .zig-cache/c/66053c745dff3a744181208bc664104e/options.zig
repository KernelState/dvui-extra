pub const snapshot_image_suffix: ?[]const u8 = null;
pub const image_dir: ?[]const u8 = null;
pub const log_stack_trace: ?u8 = null;
pub const log_error_trace: ?bool = null;
pub const @"build.VertexIndex" = enum (u1) {
    u16 = 0,
    u32 = 1,
};
pub const vertex_index: @"build.VertexIndex" = .u16;
pub const @"build.AccesskitOptions" = enum (u2) {
    static = 0,
    shared = 1,
    off = 2,
};
pub const accesskit: @"build.AccesskitOptions" = .off;
