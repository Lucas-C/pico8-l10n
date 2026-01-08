local io2 = require("io_utils")
local p8_png = require("p8_png")
local pico8 = require("pico8")

-- Those unit tests are only executed if pico8 is in the $PATH:
if pico8.is_available() then
  describe("p8_png", function()
    describe(".p8_to_png() & .png_to_p8()", function()
      it("should be complementary", function()
        io2.copy("tests/circle.p8", "dummy.p8")
        p8_png.p8_to_png("dummy.p8")
        assert.True(io2.exists("dummy.p8.png"))
        assert.equal(io2.read_all("tests/circle.p8"), io2.read_all("dummy.p8"))
        assert(os.remove("dummy.p8"))
        p8_png.png_to_p8("dummy.p8.png")
        assert.True(io2.exists("dummy.p8.png"))
        assert(os.remove("dummy.p8.png"))
      end)
    end)

    describe(".with_png_converted()", function()
      it("should raise an error unknown file extensions", function()
        assert.has_error(function()
          p8_png.with_png_converted("dummy.pico8", function() end)
        end, "Unsupported file extension: dummy.pico8")
      end)
      it("should create a .p8 file when the input file is a PNG", function()
        -- Setup
        io2.copy("tests/circle.p8", "dummy.p8")
        p8_png.p8_to_png("dummy.p8")
        -- Act
        local p8_filepath, is_png = p8_png.with_png_converted("dummy.p8.png")
        -- Assert
        assert.True(is_png)
        assert.equal("dummy.p8", p8_filepath)
        assert.True(io2.exists(p8_filepath))
        -- Cleanup
        assert(os.remove(p8_filepath))
        assert(os.remove("dummy.p8.png"))
      end)
    end)
  end)
end
