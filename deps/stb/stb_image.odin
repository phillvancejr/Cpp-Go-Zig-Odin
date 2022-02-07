package stb

foreign import _stb "./libstb_image.a"

import _c "core:c"

@(default_calling_convention="c")
foreign _stb {
    // stbi_load_from_memory :: proc (buffer: ^u8, len: int, w, h, channels: ^int, desired: int) -> ^u8 ---
    stbi_load_from_memory    :: proc(buffer: ^u8, len: i32, x, y, channels_in_file: ^i32, desired_channels: i32) -> ^u8 ---;
    stbi_image_free :: proc(retval_from_stbi_load: rawptr) ---;
}

