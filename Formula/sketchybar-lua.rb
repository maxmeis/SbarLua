# typed: false

# frozen_string_literal: true

class SketchybarLua < Formula
  env :std
  desc "Lua API wrapper for SketchyBar"
  homepage "https://github.com/maxmeis/SbarLua"
  url "https://github.com/maxmeis/SbarLua/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256"
  license "GPL-3.0-only"
  head "https://github.com/maxmeis/SbarLua.git"

  depends_on :macos

  def clear_env
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
  end

  def install
    clear_env
    system "make", "install", "PREFIX=#{share}/sketchybar_lua"
  end

  def caveats
    <<~EOS
      To use the module, add the following to your sketchybarrc:
        package.cpath = package.cpath
          .. ";#{opt_share}/sketchybar_lua/?.so"
    EOS
  end

  test do
    assert_predicate share/"sketchybar_lua/sketchybar.so", :exist?
  end
end