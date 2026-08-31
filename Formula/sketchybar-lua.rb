# typed: false

# frozen_string_literal: true

class SketchybarLua < Formula
  env :std
  desc "Lua API wrapper for SketchyBar"
  homepage "https://github.com/maxmeis/SbarLua"
  url "https://github.com/maxmeis/SbarLua/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d7e0fd735bf129f55fa49d0a56b4b56d73094bc76a9f8c52df25ca3b04ca8b4b"
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