local io2 = require("io_utils")
local p8c = require("p8_convert")
local pico8 = require("pico8")

-- Those unit tests are only executed if pico8 is in the $PATH:
if pico8.is_available() then
  describe("p8_convert", function()
    describe(".p8_to_png() & .png_to_p8()", function()
      it("should be complementary", function()
        io2.copy("tests/circle.p8", "dummy.p8")
        p8c.p8_to_png("dummy.p8")
        assert(os.remove("dummy.p8"))
        assert.True(io2.exists("dummy.p8.png"))
        p8c.png_to_p8("dummy.p8.png")
        assert(os.remove("dummy.p8.png"))
        assert.True(io2.exists("dummy.p8"))
        assert(os.remove("dummy.p8"))
      end)
    end)

    describe(".with_png_converted()", function()
      it("should raise an error unknown file extensions", function()
        assert.has_error(function()
          p8c.with_png_converted("dummy.pico8", function() end)
        end, "Unsupported file extension: dummy.pico8")
      end)
      it("should create a .p8 file when the input file is a PNG", function()
        -- Setup
        io2.copy("tests/circle.p8", "dummy.p8")
        p8c.p8_to_png("dummy.p8")
        -- Act
        local p8_filepath, is_png = p8c.with_png_converted("dummy.p8.png")
        -- Assert
        assert.True(is_png)
        assert.equal("dummy.p8", p8_filepath)
        assert.True(io2.exists(p8_filepath))
        -- Cleanup
        assert(os.remove(p8_filepath))
        assert(os.remove("dummy.p8.png"))
      end)
    end)

    describe(".p8_to_html()", function()
      it("should produce a .html and a .js file", function()
        io2.copy("tests/circle.p8", "dummy.p8")
        local html_filepath, js_filepath = p8c.p8_to_html("dummy.p8")
        assert.True(io2.exists(html_filepath))
        assert.True(io2.exists(js_filepath))
        assert(os.remove(html_filepath))
        assert(os.remove(js_filepath))
      end)
    end)
  end)
end
