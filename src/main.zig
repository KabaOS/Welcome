const std = @import("std");
const page_update = @import("move.zig").page_update;

pub const allocator = std.heap.c_allocator;
pub const c = @cImport({
    @cInclude("gtk/gtk.h");
    @cInclude("gio/gio.h");
    @cInclude("glib.h");
    @cInclude("adwaita.h");
    @cInclude("xfconf/xfconf.h");
});

pub const global_window = struct {
    pub var window: ?*c.GtkWidget = null;

    pub var back: ?*c.GtkWidget = null;
    pub var next: ?*c.GtkWidget = null;
    pub var finish: ?*c.GtkWidget = null;

    pub const functions = [_]*const fn (bool) void{
        @import("pages/welcome.zig").page,
        @import("pages/layout.zig").page,
        //@import("pages/wifi.zig").page,
        @import("pages/finish.zig").page,
    };
    pub var index: usize = 0;

    pub const pages = struct {
        pub const layout = struct {
            pub var languageSelected: i16 = @intCast(-1);
            pub var variantSelected: i16 = @intCast(0);
        };
    };
};

pub fn main() !u8 {
    const app = c.adw_application_new("com.github.arthurmelton.KabaOS.Welcome", c.G_APPLICATION_DEFAULT_FLAGS) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    _ = c.g_signal_connect_data(app, "activate", @ptrCast(&welcome_new_main), null, null, 0);
    const status = c.g_application_run(@ptrCast(app), 0, null);

    return @intCast(status);
}

fn welcome_new_main(app: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
    const back = c.gtk_button_new_from_icon_name("go-previous");
    c.gtk_widget_hide(back);
    c.gtk_widget_set_tooltip_text(back, "Back");
    _ = c.g_signal_connect_data(back, "clicked", @ptrCast(&struct {
        fn f(_: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
            page_update(false);
        }
    }.f), null, null, 0);
    global_window.back = back;

    const next = c.gtk_button_new_from_icon_name("go-next");
    c.gtk_widget_set_tooltip_text(next, "Next");
    _ = c.g_signal_connect_data(next, "clicked", @ptrCast(&struct {
        fn f(_: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
            page_update(true);
        }
    }.f), null, null, 0);
    global_window.next = next;

    const finish = c.gtk_button_new_with_label("Finish");
    c.gtk_widget_add_css_class(finish, "suggested-action");
    c.gtk_widget_hide(finish);
    _ = c.g_signal_connect_data(finish, "clicked", @ptrCast(&struct {
        fn f(_: *c.GtkApplication, _: c.gpointer) callconv(.C) void {
            page_update(true);
        }
    }.f), null, null, 0);
    global_window.finish = finish;

    const header = c.adw_header_bar_new();
    c.adw_header_bar_pack_start(@ptrCast(header), back);
    c.adw_header_bar_pack_end(@ptrCast(header), next);
    c.adw_header_bar_pack_end(@ptrCast(header), finish);

    const window = c.gtk_application_window_new(app);
    c.gtk_widget_set_state_flags(window, c.GTK_DIALOG_MODAL, @as(u1, @bitCast(true)));
    c.gtk_window_set_deletable(@ptrCast(window), @as(u1, @bitCast(false)));
    c.gtk_window_set_resizable(@ptrCast(window), @as(u1, @bitCast(false)));
    c.gtk_window_set_default_size(@ptrCast(window), 400, 650);
    c.gtk_window_set_titlebar(@ptrCast(window), header);

    global_window.window = window;

    global_window.functions[global_window.index](true);

    c.gtk_widget_show(window);
}
