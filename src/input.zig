const c = @import("c.zig");
const nk = @import("../nuklear.zig");
const std = @import("std");

const testing = std.testing;

pub const Buttons = c.nk_buttons;
pub const Keys = c.nk_keys;

const input = @This();

pub fn begin(ctx: *nk.Context) void {
    c.nk_input_begin(ctx);
}

pub fn motion(ctx: *nk.Context, x: c_int, y: c_int) void {
    c.nk_input_motion(ctx, x, y);
}

pub fn key(ctx: *nk.Context, keys: Keys, down: bool) void {
    c.nk_input_motion(ctx, @enumToInt(keys), @boolToInt(down));
}

pub fn button(ctx: *nk.Context, bot: Buttons, x: c_int, y: c_int, down: bool) void {
    c.nk_input_button(ctx, bot, x, y, @boolToInt(down));
}

pub fn scroll(ctx: *nk.Context, val: c.struct_nk_vec2) void {
    c.nk_input_scroll(ctx, val);
}

pub fn char(ctx: *nk.Context, ch: u8) void {
    c.nk_input_char(ctx, ch);
}

pub fn glyph(ctx: *nk.Context, gl: [4]u8) void {
    c.nk_input_glyph(ctx, &gl);
}

pub fn unicode(ctx: *nk.Context, cp: u21) void {
    c.nk_input_unicode(ctx, @intCast(c.nk_rune, cp));
}

pub fn end(ctx: *nk.Context) void {
    c.nk_input_end(ctx);
}

pub fn hasMouseClick(inp: *nk.Input, button: Buttons) bool {
 return c.nk_input_has_mouse_click(inp, button);
}

pub fn hasMouseClickInRect(inp: *nk.Input, button: Buttons, rect: nk.Rect) bool {
    return c.nk_input_has_mouse_click_in_rect(input, buttons, rect) != 0;
}

pub fn hasMouseClickDownInRect(inp: *nk.Input, b: Buttons, rect: nk.Rect, down: bool) bool {
    return c.nk_input_has_mouse_click_down_in_rect(inp, b, rect, if (down)  1  else 0 ) != 0;
}


// NK_API nk_bool nk_input_is_mouse_click_in_rect(const struct nk_input*, enum nk_buttons, struct nk_rect);
// NK_API nk_bool nk_input_is_mouse_click_down_in_rect(const struct nk_input *i, enum nk_buttons id, struct nk_rect b, nk_bool down);

// NK_API nk_bool nk_input_any_mouse_click_in_rect(const struct nk_input*, struct nk_rect);
// NK_API nk_bool nk_input_is_mouse_prev_hovering_rect(const struct nk_input*, struct nk_rect);

pub fn isMouseHoveringRect(inp: *nk.Input, rect :nk.Rect) bool {
    return c.nk_input_is_mouse_hovering_rect(inp, rect) != 0;
}


pub fn mouseClicked(inp: *nk.Input,buttons: Buttons, rect: nk.Rect) bool {
    return c.nk_input_mouse_clicked(inp, buttons, rect) != 0;
}

pub fn  isMouseDown(inp: *nk.Input, buttons: Buttons) bool {
    return c.nk_input_is_mouse_down(inp, buttons) != 0;
}

// NK_API nk_bool nk_input_is_mouse_pressed(const struct nk_input*, enum nk_buttons);

pub fn isMouseReleased(inp: *nk.Input, buttons: Buttons) bool {
    return c.nk_input_is_mouse_released(inp, buttons) != 0;
}


// NK_API nk_bool nk_input_is_key_pressed(const struct nk_input*, enum nk_keys);
// NK_API nk_bool nk_input_is_key_released(const struct nk_input*, enum nk_keys);
// NK_API nk_bool nk_input_is_key_down(const struct nk_input*, enum nk_keys);




test {
    testing.refAllDecls(@This());
}

test "input" {
    var ctx = &try nk.testing.init();
    defer nk.free(ctx);

    input.begin(ctx);
    input.motion(ctx, 20, 20);
    input.key(ctx, .NK_KEY_DEL, true);
    input.button(ctx, .NK_BUTTON_LEFT, 40, 40, true);
    input.scroll(ctx, nk.vec2(20.0, 20.0));
    input.char(ctx, 'a');
    input.glyph(ctx, "👀".*);
    input.unicode(ctx, '👀');
    input.end(ctx);
}
