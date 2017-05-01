--
-- Author: James Dyke
-- Date: 2017/05/01
--

require 'cairo'

function init_cairo()
    if conky_window == nil then
        return false
    end

    cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)

    cr = cairo_create(cs)

    font = "droid"

    cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_source_rgba(cr, 0.933,0.905,0.894,1)
    return true
end

function conky_main()
    if (not init_cairo()) then
        return
    end

    draw_date_and_time()
end

function draw_date_and_time()
    -- TIME
    cairo_set_font_size(cr, 130)
    cairo_move_to(cr, 750, 270)
    cairo_show_text(cr, conky_parse("${time %H:%M}"))
    cairo_stroke(cr)

    -- DATE
    cairo_set_font_size(cr, 55)
    cairo_move_to(cr, 778, 350)
    cairo_show_text(cr, conky_parse("${time %Y/%m/%d}"))
    cairo_stroke(cr)
end