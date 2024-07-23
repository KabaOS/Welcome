const c = @import("../main.zig").c;
const window = @import("../main.zig").global_window;

pub fn page(_: bool) void {
    const box = c.gtk_box_new(c.GTK_ORIENTATION_VERTICAL, 0);
    const thankyou_text = c.gtk_label_new("Thank you for using Kaba!");
    c.gtk_widget_set_margin_top(thankyou_text, 12);
    c.gtk_box_append(@ptrCast(box), thankyou_text);

    const info_text = c.gtk_label_new("Just know that it usually takes a minute or two to be able to connect to b32 addresses, and another minute or two to be able to connect to the domains you know and love!");
    c.gtk_label_set_wrap(@ptrCast(info_text), @intFromBool(true));
    c.gtk_widget_set_margin_top(info_text, 12);
    c.gtk_widget_set_margin_start(info_text, 12);
    c.gtk_widget_set_margin_end(info_text, 12);
    c.gtk_box_append(@ptrCast(box), info_text);

    c.gtk_window_set_child(@ptrCast(window.window.?), box);

    c.gtk_window_set_title(@ptrCast(window.window.?), "Thank You");
}
