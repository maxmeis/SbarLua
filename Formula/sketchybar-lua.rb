# typed: false

# frozen_string_literal: true

class SketchybarLua < Formula
  env :std
  desc "Lua API wrapper for SketchyBar"
  homepage "https://github.com/maxmeis/SbarLua"
  url "https://github.com/maxmeis/SbarLua/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "09f878874d13c875581415c66878dc7356d6b9f74e87f46b0cae792baf95f31a"
  license "GPL-3.0-only"
  head "https://github.com/maxmeis/SbarLua.git"

  depends_on :macos
  depends_on "lua"

  def clear_env
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
  end

  def install
    clear_env
    lua = Formula["lua"]
    system "make", "install",
           "PREFIX=#{share}/sketchybar_lua",
           "LUA_CFLAGS=-I#{lua.opt_include}/lua5.5",
           "LUA_LIBS=-L#{lua.opt_lib} -llua",
           "LUA_DEPS="
  end

  def caveats
    <<~EOS
      To use the module, add the following to your sketchybarrc:
        package.cpath = package.cpath
          .. ";#{opt_share}/sketchybar_lua/?.so"
    EOS
  end

  test do
    lua = Formula["lua"].opt_bin/"lua"
    system lua, "-e", "package.cpath = '#{opt_share}/sketchybar_lua/?.so;' .. package.cpath; require('sketchybar')"
  end
end