const c = @import("../main.zig").c;
const window = @import("../main.zig").global_window;
const kabaos_image = @import("../assets.zig").kabaos_image;

const image_size = 100;

pub fn page(_: bool) void {
    const box = c.gtk_box_new(c.GTK_ORIENTATION_VERTICAL, 0);
    const kabaosImage = c.gdk_pixbuf_new_from_inline(-1, kabaos_image, @intFromBool(false), null);
    const image = c.gtk_picture_new_for_pixbuf(kabaosImage);
    c.gtk_picture_set_can_shrink(@ptrCast(image), @intFromBool(true));

    c.gtk_widget_set_margin_top(image, 12);
    c.gtk_widget_set_margin_bottom(image, 12);

    c.gtk_widget_set_margin_start(image, (400-image_size)/2);
    c.gtk_widget_set_margin_end(image, (400-image_size)/2);

    c.gtk_box_append(@ptrCast(box), image);
    c.gtk_box_append(@ptrCast(box), c.gtk_label_new("Thank you for using KabaOS!"));
    c.gtk_window_set_child(@ptrCast(window.window.?), box);

    c.gtk_window_set_title(@ptrCast(window.window.?), "Welcome");
}
