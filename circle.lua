--
-- Author: James Dyke
-- Date: 2017/05/01
--

require 'cairo'

local FONT, ICON_FONT = "Mono", "StyleBats"

function init_cairo()
    if conky_window == nil then
        return false
    end

    cs = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)

    cr = cairo_create(cs)

    cairo_select_font_face(cr, FONT, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_source_rgba(cr, 0.933, 0.905, 0.894, 1)
    return true
end

function conky_main()
    if (not init_cairo()) then
        return
    end

    draw_date_and_time()
    draw_disk_usage()
    draw_cpu_usage()
    draw_memory_usage()
end

function draw_date_and_time()
    -- Time
    cairo_set_font_size(cr, 130)
    cairo_move_to(cr, 750, 270)
    cairo_show_text(cr, conky_parse("${time %H:%M}"))
    cairo_stroke(cr)

    -- Date
    cairo_set_font_size(cr, 55)
    cairo_move_to(cr, 778, 350)
    cairo_show_text(cr, conky_parse("${time %Y/%m/%d}"))
    cairo_stroke(cr)
end

function draw_disk_usage()
    cairo_set_font_size(cr, 18)
    cairo_move_to(cr, 25, 380)
    cairo_show_text(cr, "DISK USAGE")
    cairo_move_to(cr, 25, 385)
    cairo_line_to(cr, 170, 385)
    cairo_stroke(cr)

    cairo_move_to(cr, 40, 510)
    cairo_set_font_size(cr, 30)
    cairo_show_text(cr, conky_parse("/ at ${fs_used_perc /}%"))
    local diskRoot = (tonumber(conky_parse("${exec df -h / | grep -w / | awk '{print $5}' | sed 's/%//g'}")) / 100 * 360)
    cairo_stroke(cr)

    -- cairo_arc requires radions
    local angle2 = diskRoot
    local center_x = 110
    local center_y = 500
    local radius = 85
    local start_angle = 0
    cairo_set_source_rgba(cr, 1, 0.2, 0.2, 0.6)
    cairo_set_line_width(cr, 6.0)
    cairo_arc(cr, center_x, center_y, radius, (start_angle - 180) * (math.pi/180), (angle2 - 180) * (math.pi/180))
    cairo_line_to(cr, center_x, center_y)
    cairo_stroke(cr)
    cairo_set_source_rgba(cr, 0.933, 0.905, 0.894, 1)

    local center_x = 110
    local center_y = 500
    local radius = 90
    local start_angle = 0
    cairo_set_line_width(cr, 5.0)
    cairo_arc(cr, center_x, center_y, radius, (start_angle - 180) * (math.pi/180), 180 * (math.pi/180))
    cairo_stroke(cr)

end

function draw_cpu_usage()
    local base_x = 490
    local base_y = 905
    for i = 0, 4, 1
    do
        cairo_move_to(cr, base_x + 5 + (i * 200), base_y + 120)
        local cpu = tonumber(conky_parse("${cpu cpu" .. i .. "}"))
        cairo_show_text(cr, "Cpu" .. i)
        cairo_stroke(cr)

        cairo_set_source_rgba(cr, 1, 1, 0.2, 0.6)
        local angle2 = (cpu / 100) * 360
        local center_x = (base_x + 37) + (i * 200)
        local center_y = 900
        local radius = 85
        local start_angle = 0
        cairo_set_line_width(cr, 6.0)
        cairo_arc(cr, center_x, center_y, radius, (start_angle - 180) * (math.pi / 180), (angle2 - 180) * (math.pi / 180))
        cairo_line_to(cr, center_x, center_y)
        cairo_stroke(cr)

        cairo_set_source_rgba(cr, 0.933, 0.905, 0.894, 1)
        cairo_set_line_width(cr, 5.0)
        cairo_arc(cr, center_x, center_y, radius + 5, (start_angle - 180) * (math.pi/180), 180 * (math.pi/180))
        cairo_stroke(cr)

        cairo_move_to(cr, base_x + 20 + (i * 200), base_y)
        cairo_show_text(cr, cpu .. "%")

    end
end

function draw_memory_usage()
    cairo_set_font_size(cr, 18)
    cairo_move_to(cr, 1735, 380)
    cairo_show_text(cr, "MEMORY USAGE")
    cairo_set_line_width(cr, 2.0)
    cairo_move_to(cr, 1735, 385)
    cairo_line_to(cr, 1900, 385)
    cairo_stroke(cr)

    cairo_move_to(cr, 1785, 510)
    cairo_set_font_size(cr, 30)
    cairo_show_text(cr, conky_parse("${memperc}%"))
    cairo_stroke(cr)

    local memusage = (100 - tonumber(conky_parse("${memperc}"))) / 100 * 360
    local start_angle = 0 * (math.pi/180)
    local end_angle = memusage * (math.pi/180)
    local radius = 85
    local center_y = 500
    local center_x = 1810
    cairo_set_source_rgba(cr, 1, 0.2, 0.2, 0.6)

    cairo_set_line_width(cr, 6.0)
    cairo_line_to(cr, center_x, center_y)
    cairo_arc(cr, center_x, center_y, radius, end_angle, start_angle)
    cairo_stroke(cr)
    cairo_set_source_rgba(cr, 0.933, 0.905, 0.894, 1)

    local center_x = 1810
    local center_y = 500
    local radius = 90
    local start_angle = 0
    cairo_set_line_width(cr, 5.0)
    cairo_arc(cr, center_x, center_y, radius, (start_angle - 180) * (math.pi/180), 180 * (math.pi/180))
    cairo_stroke(cr)

end