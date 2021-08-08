const c = @import("c.zig");
const nk = @import("../nuklear.zig");
const std = @import("std");

const mem = std.mem;
const testing = std.testing;

/// Same as `beginTitled` but instead of taking a `name` which the caller needs to ensure
/// is a unique string, this function generates a unique name for each unique type passed
/// to `id`.
pub fn begin(
    ctx: *nk.Context,
    comptime Id: type,
    bounds: nk.Rect,
    flags: nk.PanelFlags,
) ?*const nk.Window {
    const id = nk.typeId(Id);
    return beginTitled(ctx, mem.asBytes(&id), bounds, flags);
}

pub fn beginTitled(
    ctx: *nk.Context,
    name: []const u8,
    bounds: nk.Rect,
    flags: nk.PanelFlags,
) ?*const nk.Window {
    const res = c.nk_begin_titled(
        ctx,
        nk.slice(name),
        nk.slice(flags.title orelse ""),
        bounds,
        flags.toNuklear(),
    );
    if (res == 0)
        return null;

    return ctx.current;
}

pub fn end(ctx: *nk.Context) void {
    c.nk_end(ctx);
}

pub fn find(ctx: *nk.Context, comptime Id: type) ?*const nk.Window {
    const id = nk.typeId(Id);
    return findByName(ctx, mem.asBytes(&id));
}

pub fn findByName(ctx: *nk.Context, name: []const u8) ?*const nk.Window {
    return c.nk_window_find(ctx, nk.slice(name));
}

pub fn hasFocus(ctx: *nk.Context, win: *const nk.Window) bool {
    return win == @as(*const nk.Window, ctx.active);
}

pub fn isHovered(ctx: *nk.Context, win: *const nk.Window) bool {
    if ((win.flags & c.NK_WINDOW_HIDDEN) != 0)
        return false;
    return c.nk_input_is_mouse_hovering_rect(&ctx.input, win.bounds) != 0;
}

pub fn isAnyHovered(ctx: *nk.Context) bool {
    return c.nk_window_is_any_hovered(ctx) != 0;
}

pub fn isAnyActive(ctx: *nk.Context) bool {
    return c.nk_item_is_any_active(ctx) != 0;
}

pub fn getCanvas(ctx: *nk.Context) *nk.CommandBuffer {
    return c.nk_window_get_canvas(ctx);
}

pub fn getBounds(ctx: *nk.Context) nk.Rect {
    return c.nk_window_get_bounds(ctx);
}

pub fn getPosition(ctx: *nk.Context) nk.Vec2 {
    return c.nk_window_get_position(ctx);
}

pub fn getSize(ctx: *nk.Context) nk.Vec2 {
    return c.nk_window_get_size(ctx);
}

pub fn getWidth(ctx: *nk.Context) f32 {
    return c.nk_window_get_width(ctx);
}

pub fn getHeight(ctx: *nk.Context) f32 {
    return c.nk_window_get_height(ctx);
}

pub fn getPanel(ctx: *nk.Context) *nk.Panel {
    return c.nk_window_get_panel(ctx);
}

pub fn getContentRegion(ctx: *nk.Context) nk.Rect {
    return c.nk_window_get_content_region(ctx);
}

pub fn getContentRegionMin(ctx: *nk.Context) nk.Vec2 {
    return c.nk_window_get_content_region_min(ctx);
}

pub fn getContentRegionMax(ctx: *nk.Context) nk.Vec2 {
    return c.nk_window_get_content_region_max(ctx);
}

pub fn getContentRegionSize(ctx: *nk.Context) nk.Vec2 {
    return c.nk_window_get_content_region_size(ctx);
}


// pub extern fn nk_window_get_scroll([*c]struct_nk_context, offset_x: [*c]nk_uint, offset_y: [*c]nk_uint) void;
// pub extern fn nk_window_has_focus([*c]const struct_nk_context) nk_bool;
// pub extern fn nk_window_is_hovered([*c]struct_nk_context) nk_bool;
// pub extern fn nk_window_is_collapsed(ctx: [*c]struct_nk_context, name: struct_nk_slice) nk_bool;
// pub extern fn nk_window_is_closed([*c]struct_nk_context, name: struct_nk_slice) nk_bool;
// pub extern fn nk_window_is_hidden([*c]struct_nk_context, name: struct_nk_slice) nk_bool;
// pub extern fn nk_window_is_active([*c]struct_nk_context, name: struct_nk_slice) nk_bool;
// pub extern fn nk_window_is_any_hovered([*c]struct_nk_context) nk_bool;
// pub extern fn nk_item_is_any_active([*c]struct_nk_context) nk_bool;
// pub extern fn nk_window_set_bounds([*c]struct_nk_context, name: struct_nk_slice, bounds: struct_nk_rect) void;
// pub extern fn nk_window_set_position([*c]struct_nk_context, name: struct_nk_slice, pos: struct_nk_vec2) void;
// pub extern fn nk_window_set_size([*c]struct_nk_context, name: struct_nk_slice, struct_nk_vec2) void;
// pub extern fn nk_window_set_focus([*c]struct_nk_context, name: struct_nk_slice) void;
// pub extern fn nk_window_set_scroll([*c]struct_nk_context, offset_x: nk_uint, offset_y: nk_uint) void;
// pub extern fn nk_window_close(ctx: [*c]struct_nk_context, name: struct_nk_slice) void;
// pub extern fn nk_window_collapse([*c]struct_nk_context, name: struct_nk_slice, state: enum_nk_collapse_states) void;
// pub extern fn nk_window_collapse_if([*c]struct_nk_context, name: struct_nk_slice, enum_nk_collapse_states, cond: c_int) void;
// pub extern fn nk_window_show([*c]struct_nk_context, name: struct_nk_slice, enum_nk_show_states) void;
// pub extern fn nk_window_show_if([*c]struct_nk_context, name: struct_nk_slice, enum_nk_show_states, cond: c_int) void;


pub fn isClosed(ctx: *nk.Context,comptime Id: type)  bool {
    const id = nk.typeId(Id);
    return c.nk_window_is_closed(ctx, nk.slice( mem.asBytes(&id))) != 0;
}

test {
    testing.refAllDecls(@This());
}

test "window" {
    var ctx = &try nk.testing.init();
    defer nk.free(ctx);

    const Id = opaque {};
    if (nk.window.begin(ctx, Id, nk.rect(10, 10, 10, 10), .{})) |win| {
        try std.testing.expectEqual(@as(?*const nk.Window, win), nk.window.find(ctx, Id));
    }
    nk.window.end(ctx);
}
